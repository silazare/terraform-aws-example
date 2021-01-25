package test

import (
	"fmt"
	"time"
	"testing"
	"crypto/tls"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAlbExample(t *testing.T)  {
	t.Parallel()

	// Variables
	albName := fmt.Sprintf("terratest-%s", random.UniqueId())

	terraformOptions := &terraform.Options{
		TerraformDir: "/go/project/examples/alb",
		Vars: map[string]interface{}{
			"alb_name": albName,
		},

	}

	// Clean up everything at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Deploy the example
	fmt.Println()
	fmt.Println("==> Starting ALB Unit test...")
	fmt.Println()
	terraform.InitAndApply(t, terraformOptions)

	// Get the URL of the ALB
	albDnsName := terraform.OutputRequired(t, terraformOptions, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	// Test that the ALB's default action is working and returns a 404
	expectedStatus := 404
	expectedBody := "404: page not found"

	// Retries config
	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	// Setup a TLS configuration to submit with the helper, a blank struct is acceptable
	tlsConfig := tls.Config{}

	http_helper.HttpGetWithRetry(
		t,
		url,
		&tlsConfig,
		expectedStatus,
		expectedBody,
		maxRetries,
		timeBetweenRetries,
	)

}
