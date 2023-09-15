export AWS_PROFILE := $(profile)

require_profile:
	@if [ -z "$(profile)" ]; then \
		echo "Variable 'profile' is empty."; \
		exit 1; \
	fi ;

require_environment:
	@if [ -z "$(environment)" ]; then \
		echo "Variable 'environment' is empty."; \
		exit 1; \
	fi ;

setup:
	@echo "Installing dependencies from Brewfile"
	@brew bundle install

auth: require_profile
	@aws-sso console --profile $(profile)

lint:
	@pre-commit run --all-files

plan-all: require_environment auth
	@terragrunt run-all plan --terragrunt-working-dir environments/$(environment)


apply-all: require_environment auth
	@terragrunt run-all apply --terragrunt-working-dir environments/$(environment)

destroy-all: require_environment auth
	@terragrunt run-all destroy --terragrunt-working-dir environments/$(environment)

init: require_environment auth
	@terragrunt run-all init --terragrunt-working-dir environments/$(environment) -reconfigure


#######
format:
	@terraform fmt -recursive
	@terragrunt hclfmt

cost:
	@infracost breakdown --config-file infracost.yml

validate-all:
	@terragrunt run-all validate --terragrunt-working-dir $(acc)/$(region)

security:
	@for PLAN_DIR in $(shell find $(acc) -name plan.json -exec dirname {} \;); do \
		echo "Security check on: $$PLAN_DIR" ; \
		tfsec $$PLAN_DIR --config-file tfsec.yml -m high ; \
	done
