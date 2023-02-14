package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAWSEC2(t *testing.T){
		t.Parallel()
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/ec2_instance",
	})

	// At the end of the test, runs `terraform destroy` to clean up any resources that were created.
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`; test fails if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the IP of the instance
	output := terraform.Output(t, terraformOptions, "ec2_ami")

	// Make an HTTP request to the instance and make sure we get a 200 response
	assert.Equal(t, "ami-07474bdcabd34c712a", output)
}
