package test

import (
	"fmt"
	"testing"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAsgExample(t *testing.T)  {
	t.Parallel()

	// Variables
	asgName := fmt.Sprintf("terratest-%s", random.UniqueId())

	terraformOptions := &terraform.Options{
		TerraformDir: "/go/project/examples/asg",
		Vars: map[string]interface{}{
			"cluster_name": asgName,
		},
	}

	// Clean up everything at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Deploy the example
	fmt.Println()
	fmt.Println("==> Starting ASG Unit test...")
	fmt.Println()
	terraform.InitAndApply(t, terraformOptions)

}
