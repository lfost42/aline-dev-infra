package test

import (
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestAlineVpc(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: "../test-aline-eks-app",
        Vars: map[string]interface{}{
            "infra_env":             "test",
            "aline_cidr":            "10.1.0.0/22",
            "aline_cidr_bits":       6,
            "aline_az_count":        2,
            "aline_public_subnet":   true,
            "aline_private_subnet":  false,
            "aline_database_subnet": false,
            "aline_vpc_type":        "Main",
        },
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    vpcId := terraform.Output(t, terraformOptions, "vpc_id")
    assert.NotEmpty(t, vpcId)

    // Check that the VPC has the expected subnets
    subnetIds := terraform.OutputList(t, terraformOptions, "public_subnet_ids")
    assert.Len(t, subnetIds, 2)

    // Check that the VPC has the expected security groups
    sgIds := terraform.OutputList(t, terraformOptions, "security_group_ids")
    assert.Len(t, sgIds, 1)
}