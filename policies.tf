# 
# Gateway policies
# 
data "aws_iam_policy_document" "apigateway" {
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListTagsForResource",
      "route53:ListResourceRecordSets",
      "route53:GetHostedZone",
      "route53:ChangeResourceRecordSets",
      "route53:GetChange",
      "acm:RequestCertificate",
      "acm:DescribeCertificate",
      "acm:ListTagsForCertificate",
      "acm:DeleteCertificate",
      "apigateway:*",
      "logs:CreateLogDelivery"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "iam:CreateServiceLinkedRole"
    ]

    resources = [
      "arn:aws:iam::${local.account_id}:role/aws-service-role/ops.apigateway.amazonaws.com/AWSServiceRoleForAPIGateway",
    ]
  }
}

resource "aws_iam_policy" "apigateway" {
  name        = "api-gateway-policy"
  path        = "/"
  description = "Policy to manage api gateway"
  policy      = data.aws_iam_policy_document.apigateway.json
}

resource "aws_iam_user_policy_attachment" "apigateway" {
  user       = aws_iam_user.mach_user.name
  policy_arn = aws_iam_policy.apigateway.arn
}

# 
# Component repository
#
data "aws_iam_policy_document" "componentrepo" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.code_repository_name}/*",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.code_repository_name}"
    ]
  }
}

resource "aws_iam_policy" "componentrepo" {
  name        = "component-repository-policy"
  path        = "/"
  description = "Policy to read from the components repository"
  policy      = data.aws_iam_policy_document.componentrepo.json
}

resource "aws_iam_user_policy_attachment" "componentrepo" {
  user       = aws_iam_user.mach_user.name
  policy_arn = aws_iam_policy.componentrepo.arn
}

# 
# Various
#
data "aws_iam_policy_document" "mach_deploy" {
  statement {
    actions = [
      "iam:GetRole",
      "iam:PassRole",
      "iam:CreateRole"
    ]

    resources = [
      "arn:aws:iam::${local.account_id}:role/*"
    ]
  }

  statement {
    actions = [
      "iam:CreateUser",
      "iam:GetUser",
      "iam:DeleteUser",
      "iam:GetUserPolicy",
      "iam:ListGroupsForUser",
      "iam:AttachRolePolicy",
      "iam:DeleteAccessKey",
      "iam:CreateAccessKey",
      "iam:ListAccessKeys"
    ]

    resources = [
      "arn:aws:iam::${local.account_id}:user/ct-*",
      "arn:aws:iam::${local.account_id}:role/*"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:ListTagsLogGroup",
      "logs:PutRetentionPolicy",
      "logs:DescribeLogGroups"
    ]

    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/*:log-stream:",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:*:log-stream:",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group::log-stream:"
    ]
  }

  statement {
    actions = [
      "iam:GetPolicy",
      "iam:CreatePolicy",
      "iam:GetPolicyVersion",
      "iam:ListEntitiesForPolicy",
      "iam:ListPolicyVersions",
      "iam:CreatePolicyVersion"
    ]

    resources = [
      "arn:aws:iam::${local.account_id}:policy/*",
      "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
    ]
  }

  statement {
    actions = [
      "lambda:*"
    ]

    resources = [
      "arn:aws:lambda:${local.region}:${local.account_id}:function:*"
    ]
  }

  statement {
    actions = [
      "sqs:*"
    ]

    resources = [
      "arn:aws:sqs:${local.region}:${local.account_id}:*"
    ]
  }
}

resource "aws_iam_policy" "mach_deploy" {
  name        = "mach-deploy"
  path        = "/"
  description = "Basic MACH deploy policies"
  policy      = data.aws_iam_policy_document.mach_deploy.json
}

resource "aws_iam_user_policy_attachment" "mach_deploy" {
  user       = aws_iam_user.mach_user.name
  policy_arn = aws_iam_policy.mach_deploy.arn
}
