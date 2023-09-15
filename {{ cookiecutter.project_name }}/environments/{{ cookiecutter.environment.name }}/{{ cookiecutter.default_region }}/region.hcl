locals {
  region_name        = "${basename(get_terragrunt_dir())}"
  tf_provider_region = local.region_name
  tf_state_bucket    = "${get_aws_account_id()}.${local.region_name}.tfstate"
}