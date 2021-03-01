# AWS account module

Module to set up an AWS account which can be used for MACH deployments

## Usage

```
module "mach-account" {
  source = "git::https://github.com/labd/terraform-aws-mach-account.git"
  code_repository_name = "my-project-lambdas"
  aws_account_alias    = "my-new-site"
}
```
