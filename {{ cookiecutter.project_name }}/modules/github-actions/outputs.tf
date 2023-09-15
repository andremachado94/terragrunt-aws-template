output "apply_role_name" {
  value = aws_iam_role.role_github_actions_apply.name
}

output "plan_role_name" {
  value = aws_iam_role.role_github_actions_plan.name
}

output "release_role_name" {
  value = aws_iam_role.role_github_actions_release.name
}

output "apply_role_arn" {
  value = aws_iam_role.role_github_actions_apply.arn
}

output "plan_role_arn" {
  value = aws_iam_role.role_github_actions_plan.arn
}

output "release_role_arn" {
  value = aws_iam_role.role_github_actions_release.arn
}
