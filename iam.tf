resource "aws_iam_account_alias" "alias" {
  account_alias = var.aws_account_alias
  count         = var.aws_account_alias == "" ? 0 : 1
}

resource "aws_iam_user" "mach_user" {
  name = var.mach_user_name
}

resource "aws_iam_access_key" "mach_user" {
  user = aws_iam_user.mach_user.name
}

resource "aws_ssm_parameter" "mach_user_credential_access_key" {
  name  = "/deploy-credentials/${aws_iam_user.mach_user.name}/access-key-id"
  type  = "SecureString"
  value = aws_iam_access_key.mach_user.id
}

resource "aws_ssm_parameter" "mach_user_credentials_secret_key" {
  name  = "/deploy-credentials/${aws_iam_user.mach_user.name}/secret-access-key"
  type  = "SecureString"
  value = aws_iam_access_key.mach_user.secret
}

/**
 * Create a role for deployment purposes
 */
data "aws_iam_policy_document" "deploy_role_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"

      identifiers = concat(
        var.deploy_principle_identifiers, [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      )
    }
  }
}

resource "aws_iam_role" "mach_role" {
  name = var.mach_role_name
  assume_role_policy = data.aws_iam_policy_document.deploy_role_assume.json
}
