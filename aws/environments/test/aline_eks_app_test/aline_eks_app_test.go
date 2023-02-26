package test

import (
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestAlineEksApp(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: ".",
        Vars: map[string]interface{}{
            "infra_env": "test",
            "vpc_cidr": "10.1.0.0/22",
            "cidr_bits": 6,
            "az_count": 2,
            "create_public_subnet": true,
            "create_private_subnet": false,
            "create_database_subnet": false,
            "vpc_type": "Main",
        },
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    vpcId := terraform.Output(t, terraformOptions, "out_id")
    assert.NotEmpty(t, vpcId)

    subnets := terraform.Output(t, terraformOptions, "public_subnets")
    assert.NotEmpty(t, subnets)

    vpcCidr := terraform.Output(t, terraformOptions, "out_cidr")
    assert.Equal(t, vpcCidr, "10.1.0.0/22")

    azNames := terraform.OutputList(t, terraformOptions, "az_names")
    assert.Equal(t, len(azNames), 6)
    assert.Contains(t, azNames, "us-east-1a")
    assert.Contains(t, azNames, "us-east-1b")
		assert.Contains(t, azNames, "us-east-1c")
		assert.Contains(t, azNames, "us-east-1d")
		assert.Contains(t, azNames, "us-east-1e")
		assert.Contains(t, azNames, "us-east-1f")

}