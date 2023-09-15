# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

terraform_version_constraint  = "{{ cookiecutter.terraform_version }}"
terragrunt_version_constraint = "{{ cookiecutter.terragrunt_version }}"


terraform {
  extra_arguments "plan_out" {
    commands  = ["plan"]
    arguments = ["-out", "tfplan"]
  }
  after_hook "after_hook" {
    commands = ["plan"]
    execute  = ["sh", "-c", "terraform show -json tfplan > plan.json"]
  }
}

locals {
  # Automatically load account-level variables - Currently not being used
  common_vars      = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  # Automatically load region-level variables
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))


  # Extract the variables we need for easy access
  region_name        = local.region_vars.locals.region_name
  tf_provider_region = local.region_vars.locals.tf_provider_region
  tf_state_bucket    = local.region_vars.locals.tf_state_bucket

  environment_name = local.environment_vars.locals.environment
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.tf_provider_region}"
  default_tags {
    tags = {
      environment_name = "${local.environment_name}"
      provisioned_by   = "terraform"
      region           = "${local.region_name}"
    }
  }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config  = {
    encrypt        = true
    bucket         = local.tf_state_bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.tf_provider_region
    dynamodb_table = "{{ cookiecutter.terragrunt_locks_table }}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = {}
