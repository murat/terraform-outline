## Installation

### Get terraform

```bash
brew install terraform
```

### Get aws-cli

```bash
brew install awscli
```

### Get terraform-outline

```bash
git clone git@github.com:murat/terraform-outline.git
cd terraform-outline
```

### Apply

```bash
terraform apply \
  -var 'aws_profile=default' \
  -var 'aws_region=eu-central-1' \
  -var 'key_name=terraform' \
  -var 'public_key_path=/Users/murat/.ssh/id_rsa.pub'
```
