############### Github Action provider ###############
resource "aws_iam_openid_connect_provider" "openid_github_actions" {
  count           = var.openid_connect_provider.enabled ? 1 : 0
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.openid_connect_provider.thumbprint_list
}

resource "aws_iam_role" "role_github_actions_apply" {
  name               = "${var.prefix}-gh-actions-apply"
  assume_role_policy = local.role_github_actions_apply_assume_role_policy
}

resource "aws_iam_role_policy_attachment" "role_github_actions_apply" {
  role       = aws_iam_role.role_github_actions_apply.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "role_github_actions_plan" {
  name               = "${var.prefix}-gh-actions-plan"
  assume_role_policy = local.role_github_actions_plan_assume_role_policy
}

resource "aws_iam_role_policy_attachment" "role_github_actions_plan" {
  role       = aws_iam_role.role_github_actions_plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "role_github_actions_plan" {
  name   = "${var.prefix}-gh-actions-plan"
  policy = local.role_github_actions_plan_policy
  role   = aws_iam_role.role_github_actions_plan.id
}

resource "aws_iam_role" "role_github_actions_release" {
  name               = "${var.prefix}-gh-actions-release"
  assume_role_policy = local.role_github_actions_release_assume_role_policy
}

resource "aws_iam_role_policy_attachment" "role_github_actions_release" {
  role       = aws_iam_role.role_github_actions_release.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "role_github_actions_release" {
  name   = "${var.prefix}-gh-actions-release"
  policy = local.role_github_actions_release_policy
  role   = aws_iam_role.role_github_actions_release.id
}

locals {
  role_github_actions_apply_assume_role_policy = <<-POLICY
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "",
              "Effect": "Allow",
              "Principal": {
                  "Federated": "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"
              },
              "Action": "sts:AssumeRoleWithWebIdentity",
              "Condition": {
                  "StringEquals": {
                      "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
                      "token.actions.githubusercontent.com:sub": "repo:${var.repository}:ref:refs/heads/${var.apply_branch}"
                  }
              }
          }
      ]
  }
  POLICY

  role_github_actions_plan_assume_role_policy = <<-POLICY
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "",
              "Effect": "Allow",
              "Principal": {
                  "Federated": "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"
              },
              "Action": "sts:AssumeRoleWithWebIdentity",
              "Condition": {
                  "StringEquals": {
                      "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                  },
                  "StringLike": {
                      "token.actions.githubusercontent.com:sub": "repo:${var.repository}:*"
                  }
              }
          }
      ]
  }
  POLICY

  role_github_actions_plan_policy = <<-POLICY
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "kms:Decrypt",
                  "dynamodb:PutItem",
                  "dynamodb:DeleteItem",
                  "cur:Describe*"
              ],
              "Resource": [
                  "*"
              ]
          }
      ]
  }
  POLICY

  role_github_actions_release_assume_role_policy = <<-POLICY
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "",
              "Effect": "Allow",
              "Principal": {
                  "Federated": "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"
              },
              "Action": "sts:AssumeRoleWithWebIdentity",
              "Condition": {
                  "StringEquals": {
                      "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                  },
                  "StringLike": {
                      "token.actions.githubusercontent.com:sub": "repo:${var.repository}:ref:refs/tags/*"
                  }
              }
          }
      ]
  }
  POLICY

  role_github_actions_release_policy = <<-POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "kms:Decrypt",
                    "dynamodb:PutItem",
                    "dynamodb:DeleteItem",
                    "cur:Describe*"
                ],
                "Resource": [
                    "*"
                ]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "s3:Get*",
                    "s3:List*",
                    "s3:Put*",
                    "s3:Abort*"
                ],
                "Resource": [
                    "*"
                ]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "ecr:CompleteLayerUpload",
                    "ecr:GetAuthorizationToken",
                    "ecr:UploadLayerPart",
                    "ecr:InitiateLayerUpload",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:PutImage"
                ],
                "Resource": "*"
            }
        ]
    }
  POLICY
}