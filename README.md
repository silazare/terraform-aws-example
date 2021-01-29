## Example AWS infrastructure layout based on Terraform Up and Running book and code

Prerequisites:
* terraform >= 0.13
* tfsec >= v0.36.11 (for pre-commit usage)
* tflint >= 0.23.0 (for pre-commit usage)
* checkov >= 1.0.675 (for pre-commit usage)

Pre-commit installation:
```shell
git secrets --install
pre-commit install -f
pre-commit run -a
```

Important notes:
* For Production ready you should use separate AWS accounts for Staging and Production as well.
* This is very simple and straight-forward layout structure with hard tfstate dependenices.

Description:

```shell
.
├── examples
│         ├── README.md
│         ├── alb
│         ├── asg
│         ├── database
│         └── webserver
├── global
│         ├── iam
│         └── s3
├── modules
│         ├── alb
│         ├── asg
│         ├── db-mysql
│         └── webserver
├── production
│         ├── database
│         ├── vpc
│         └── webserver
├── staging
│         ├── database
│         ├── vpc
│         └── webserver
```

1) Used file-layout isolation (per services and per system)
2) Used S3 remote backends isolation (per services and per system)
3) Used simple modules
4) Used Terratest for Unit tests

## Create Global Infrastructure:

1) Create buckets and DynamoDB table for remote backends
```shell
cd global/s3
make plan
make apply
```

## Create Staging Infrastructure:

1) Prepare backend.config and create Staging VPC
```shell
cd staging/vpc
make plan
make apply
```

2) Prepare backend.config and tfvars then create Staging Database
```shell
cd staging/database
make plan
make apply
```

3) Prepare backend.config and tfvars then create Staging Web cluster
```shell
cd staging/webserver
make plan
make apply
```

## Destroy Staging Infrastructure:

Important:
* You should destroy Infrastructure in strict reverse order, otherwise tfstate dependenices will be broken

1) Destroy Staging Web cluster
```shell
cd staging/webserver
make destroy
```

2) Destroy Staging Database
```shell
cd staging/database
make destroy
```

3) Destroy Staging VPC
```shell
cd staging/vpc
make destroy
```
