locals {
  environment  = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals.environment
  project_name = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.project_name
}

terraform {
  source = "${path_relative_from_include()}//modules/github-actions"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  prefix       = local.project_name
  apply_branch = local.environment
}