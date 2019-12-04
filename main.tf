# Specify the provider and access details
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "terraform" {
  name        = "terraform_example"
  description = "Used in the terraform"
  vpc_id      = aws_vpc.default.id

  # inbound access to server
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "outline" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "outline" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    type = "ssh"
    # The default username for our AMI
    user = "ubuntu"
    host = self.public_ip
    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = var.aws_amis[var.aws_region]

  # The name of our SSH keypair we created above.
  key_name = aws_key_pair.outline.id

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = [aws_security_group.terraform.id]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = aws_subnet.default.id

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install curl wget",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo systemctl start docker",
      "sudo wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh | sudo bash"
    ]
  }
}

