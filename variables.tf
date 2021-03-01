variable "code_repository_name" {
  type = string
}

variable "deploy_principle_identifiers" {
  type    = list(any)
  default = []
}

# variable "route53_zone" {
#   type = string
# }

variable "aws_account_alias" {
  type        = string
  default     = ""
  description = "Set custom AWS account alias"
}

variable "mach_user_name" {
  default = "mach"
}

variable "mach_role_name" {
  default = "mach"
}
