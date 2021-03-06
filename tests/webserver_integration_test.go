package test

import (
	"fmt"
	"time"
	"strings"
	"testing"
	"crypto/tls"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
)

// Global constants
const vpcDirStaging = "/go/project/staging/vpc"
const dbDirStaging = "/go/project/staging/database-mysql"
const appDirStaging = "/go/project/staging/webserver"

// Global variables for Terraform Backends
var vpcBucketForTesting = "tf-state-060520"
var vpcBucketRegionForTesting = "eu-west-1"
var vpcStateKey = "terratest/vpc/terraform.tfstate"
var dbBucketForTesting = "tf-state-060520"
var dbBucketRegionForTesting = "eu-west-1"
var dbStateKey = "terratest/database/terraform.tfstate"
var webserverBucketForTesting = "tf-state-060520"
var webserverBucketRegionForTesting = "eu-west-1"
var webserverStateKey = "terratest/webserver/terraform.tfstate"
var dynamodbTableForTesting = "tf-locks-060520"

// Full-scope of integration tests for Staging
func TestWebserverStaging(t *testing.T)  {
	t.Parallel()

	// Deploy the VPC
	vpcOpts := createVpcOpts(t, vpcDirStaging)
	defer terraform.Destroy(t, vpcOpts)
	terraform.InitAndApply(t, vpcOpts)

	// Deploy the MySQL DB
	dbOpts := createDbOpts(t, dbDirStaging)
	defer terraform.Destroy(t, dbOpts)
	terraform.InitAndApply(t, dbOpts)

	// Deploy the Webserver
	webserverOpts := createWebserverOpts(dbOpts, appDirStaging)
	defer terraform.Destroy(t, webserverOpts)
	terraform.InitAndApply(t, webserverOpts)

	// Validate the Webserver works
	validateWebserver(t, webserverOpts)
}

func createVpcOpts(t *testing.T, terraformDir string) *terraform.Options {

	// VPC variables
	vpcCidr := "192.168.0.0/16"
	vpcAzs := []string{"eu-west-1a", "eu-west-1b", "eu-west-1c"}
	vpcPrivateSubnets := []string{"192.168.10.0/24", "192.168.11.0/24", "192.168.12.0/24"}
	vpcPublicSubnets := []string{"192.168.20.0/24", "192.168.21.0/24", "192.168.22.0/24"}

	return &terraform.Options{
		TerraformDir: terraformDir,

		Vars: map[string]interface{} {
			"cidr": vpcCidr,
			"azs": vpcAzs,
			"private_subnets": vpcPrivateSubnets,
			"public_subnets": vpcPublicSubnets,
		},

		BackendConfig: map[string]interface{} {
			"bucket":         vpcBucketForTesting,
			"region":         vpcBucketRegionForTesting,
			"key":            vpcStateKey,
			"dynamodb_table": dynamodbTableForTesting,
			"encrypt":        true,
		},
	}
}

func createDbOpts(t *testing.T, terraformDir string) *terraform.Options {

	// Variables
	uniqueId := random.UniqueId()

	// Database variables
	databasePrefix := "terratest"
	databaseName := "terratest"
	databasePort := int64(3306)
	databaseUsername := "admin"
	databasePassword := fmt.Sprintf("admin_%s", uniqueId)

	return &terraform.Options{
		TerraformDir: terraformDir,

		Vars: map[string]interface{} {
			"db_prefix": databasePrefix,
			"db_name": databaseName,
			"db_port": databasePort,
			"db_user_name": databaseUsername,
			"db_password": databasePassword,
			"vpc_remote_state_bucket": vpcBucketForTesting,
			"vpc_remote_state_key": vpcStateKey,
			"vpc_remote_state_region": vpcBucketRegionForTesting,
			"vpc_dynamodb_table": dynamodbTableForTesting,
		},

		BackendConfig: map[string]interface{}{
			"bucket":         dbBucketForTesting,
			"region":         dbBucketRegionForTesting,
			"key":            dbStateKey,
			"dynamodb_table": dynamodbTableForTesting,
			"encrypt":        true,
		},
	}
}

func createWebserverOpts(dbOpts *terraform.Options,terraformDir string) *terraform.Options {

	// Variables
	uniqueId := random.UniqueId()
	
	clusterName := fmt.Sprintf("webserver-%s", uniqueId)
	environment := "terratest"
	serverText := "webserver test"

	return &terraform.Options{
		TerraformDir: terraformDir,

		Vars: map[string]interface{} {
			"cluster_name": clusterName,
			"environment": environment,
			"server_text": serverText,
			"vpc_remote_state_bucket": vpcBucketForTesting,
			"vpc_remote_state_key": vpcStateKey,
			"vpc_remote_state_region": vpcBucketRegionForTesting,
			"vpc_dynamodb_table": dynamodbTableForTesting,
			"db_remote_state_bucket": dbBucketForTesting,
			"db_remote_state_key": dbStateKey,
			"db_remote_state_region": dbBucketRegionForTesting,
			"db_dynamodb_table": dynamodbTableForTesting,
		},

		BackendConfig: map[string]interface{} {
			"bucket":         webserverBucketForTesting,
			"region":         webserverBucketRegionForTesting,
			"key":            webserverStateKey,
			"dynamodb_table": dynamodbTableForTesting,
			"encrypt":        true,
		},

		// Retry up to 3 times, with 5 seconds between retries,
		// on known errors
		MaxRetries: 3,
		TimeBetweenRetries: 5 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"RequestError: send request failed": "Throttling issue?",
		},
	}
}

func validateWebserver(t *testing.T, webserverOpts *terraform.Options) {

	albDnsName := terraform.OutputRequired(t, webserverOpts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)
	serverText := "webserver test"

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second
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
