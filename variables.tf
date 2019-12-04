variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/terraform.pub
DESCRIPTION

}

variable "key_name" {
  description = "Desired name of AWS key pair"
}

variable "aws_profile" {
  description = "AWS cli profile."
  default     = "default"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-central-1"
}

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-central-1 = "ami-09356619876445425"
    eu-north-1   = "ami-005bc7d72deb72a3d"
    eu-west-1    = "ami-04c58523038d79132"
    eu-west-2    = "ami-00622b440d92e55c0"
    us-east-1    = "ami-00a208c7cdba991ea"
    us-east-2    = "ami-059d836af932792c3"
    us-west-1    = "ami-0f42d8c4eb586ccf7"
    us-west-2    = "ami-0a7d051a1c4b54f65"
    sa-east-1    = "ami-049f5d88d2d436431"
  }
}

