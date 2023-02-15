// tflint --config=aws/tflint/tflint.hcl aws/modules

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
    enabled = true
    version = "0.21.2"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# TFLint configuration file
# Enforce naming conventions for resources
rule "aws_instance_name_format" {
  enabled = true
  severity = "error"

  enforcement_level = "mandatory"
  match = "aws_instance.+"

  message = "AWS instance name must match the pattern 'instance-[0-9]+'"
  pattern = "^instance-[0-9]+$"
}

# Check for unused variables
rule "variable_not_used" {
  enabled = true
  severity = "warning"

  enforcement_level = "recommended"
}

# Check for hardcoded values in Terraform code
rule "hardcoded_value" {
  enabled = true
  severity = "error"

  enforcement_level = "mandatory"
}

# Check for missing dependencies between resources
rule "missing_depends_on" {
  enabled = true
  severity = "error"

  enforcement_level = "mandatory"
}

config {
  module = true
  force  = false
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}

