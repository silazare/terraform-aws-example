package test

import (
	"fmt"
	"testing"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestDatabaseExample(t *testing.T)  {
	t.Parallel()

	// Variables
	databasePrefix := "terratest"
	databaseName := "terratest"
	databasePort := int64(3306)
	databaseUsername := "admin"
	databasePassword := fmt.Sprintf("admin_%s", random.UniqueId())

	terraformOptions := &terraform.Options{
		TerraformDir: "/go/project/examples/database",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{} {
			"db_prefix": databasePrefix,
			"db_name": databaseName,
			"db_port": databasePort,
			"db_user_name": databaseUsername,
			"db_password": databasePassword,
		},
	}

	// Clean up everything at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Deploy the example
	fmt.Println()
	fmt.Println("==> Starting DB Unit test...")
	fmt.Println()
	terraform.InitAndApply(t, terraformOptions)

}
