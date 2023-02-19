// tflint --config=aws/tflint/.tflint.hcl --chdir=modules/--recursive

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
    enabled = true
    version = "0.21.2"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_required_version" {
  name = "terraform-required-version"
  enabled = false
}

rule "terraform_required_providers" {
  name = "terraform-required-providers"
  enabled = false
}

rule "terraform_deprecated_index" {
  name = "terraform-depricated-index"
  enabled = false
}