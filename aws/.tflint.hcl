// tflint --config=aws/tflint/.tflint.hcl --chdir=modules/--recursive

plugin "terraform" {
  enabled = true
  preset  = "recommended"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
  version = "0.2.2"
}

plugin "aws" {
    enabled = true
    version = "0.21.2"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_required_version" {
  exclude = ["aws/terraform_required_version"]
  enabled = false
  
}

rule "terraform_required_providers" {
  enabled = false
  exclude = ["aws/terraform_required_providers"]
}

rule "terraform_deprecated_index" {
  enabled = false
  exclude = ["aws/terraform_depricated_index"]
}