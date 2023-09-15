locals {
  region_name        = "${basename(get_terragrunt_dir())}"
  tf_provider_region = "{{ cookiecutter.default_region }}"
  tf_state_bucket    = "${get_aws_account_id()}.${local.region_name}.tfstate"
}