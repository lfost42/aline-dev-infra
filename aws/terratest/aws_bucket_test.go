package test

import (
  "fmt"
  "strings"
  "testing"

  "github.com/gruntwork-io/terratest/modules/aws"
  "github.com/gruntwork-io/terratest/modules/random"
  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/assert"
)

// Standard Go test, with the "Test" prefix and accepting the *testing.T struct.
func TestS3Bucket(t *testing.T) {
  awsRegion := "us-east-1"

  // This is using the terraform package that has a sensible retry function.
  terraformOpts := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
    TerraformDir: "../aws/environments/develop/aline-eks/app",

    // This allows us to define Terraform variables. We have a variable named
    // "bucket_name" which essentially is a suffix. Here we are are using the
    // random package to get a unique id we can use for testing, as bucket names
    // have to be unique.
    Vars: map[string]interface{}{
      "bucket_name": fmt.Sprintf("-%v", strings.ToLower(random.UniqueId())),
    },

    // Setting the environment variables, specifically the AWS region.
    EnvVars: map[string]string{
      "AWS_DEFAULT_REGION": awsRegion,
    },
  })

  // We want to destroy the infrastructure after testing.
  defer terraform.Destroy(t, terraformOpts)

  // Deploy the infrastructure with the options defined above
  terraform.InitAndApply(t, terraformOpts)

  // Get the bucket ID so we can query AWS
  bucketID := terraform.Output(t, terraformOpts, "bucket_id")

  // Get the versioning status to test that versioning is enabled
  actualStatus := aws.GetS3BucketVersioning(t, awsRegion, bucketID)

  // Test that the status we get back from AWS is "Enabled" for versioning
  assert.Equal(t, "Enabled", actualStatus)
}
