package test

import (
	"fmt"
	"time"
	"strings"
	"testing"
	"crypto/tls"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestWebserverExample(t *testing.T)  {
	t.Parallel()

	// Variables
	clusterName := fmt.Sprintf("terratest-%s", random.UniqueId())
	databaseAddress := "mock-value-for-test"
	databasePort := int64(3306)
	environment := "terratest"
	serverText := "webserver test"

	terraformOptions := &terraform.Options{
		TerraformDir: "/go/project/examples/webserver",

		Vars: map[string]interface{}{
			"cluster_name": clusterName,
			"db_address": databaseAddress,
			"db_port": databasePort,
			"environment": environment,
			"server_text": serverText,
		},
	}

	// Clean up everything at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Deploy the example
	fmt.Println()
	fmt.Println("==> Starting Webserver Unit test...")
	fmt.Println()
	terraform.InitAndApply(t, terraformOptions)

	albDnsName := terraform.OutputRequired(t, terraformOptions, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	// Setup a TLS configuration to submit with the helper, a blank struct is acceptable
	tlsConfig := tls.Config{}

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		&tlsConfig,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 &&
				strings.Contains(body, serverText)
		},
	)

}
