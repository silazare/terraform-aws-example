### Usage with Docker

```shell
docker build -t terratest:latest .
```

### Initialize and update Gopkg files

```shell
cd tests

docker run --rm -ti -v ${PWD}/tests:/go/src/terratest terratest:latest dep init -v
docker run --rm -ti -v ${PWD}/tests:/go/src/terratest terratest:latest dep ensure -v
```


### Run Unit tests

```shell
cd ..

docker run --rm -ti \
    -v ${PWD}:/go/project \
    -v ${PWD}/tests:/go/src/terratest \
    -e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
    -e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
    terratest:latest go test -v -timeout 30m alb_example_test.go

docker run --rm -ti \
    -v ${PWD}:/go/project \
    -v ${PWD}/tests:/go/src/terratest \
    -e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
    -e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
    terratest:latest go test -v -timeout 30m asg_example_test.go

docker run --rm -ti \
    -v ${PWD}:/go/project \
    -v ${PWD}/tests:/go/src/terratest \
    -e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
    -e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
    terratest:latest go test -v -timeout 30m db_example_test.go

docker run --rm -ti \
    -v ${PWD}:/go/project \
    -v ${PWD}/tests:/go/src/terratest \
    -e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
    -e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
    terratest:latest go test -v -timeout 30m webserver_example_test.go
```

### Run Integration test all-in-one

```shell
docker run --rm -ti \
    -v ${PWD}:/go/project \
    -v ${PWD}/tests:/go/src/terratest \
    -e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
    -e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
    terratest:latest go test -run "TestWebserverStaging" -v -timeout 30m webserver_integration_test.go
```

### Run Integration test with stages - create infra

```shell
docker run --rm -ti \
    -v ${PWD}:/go/project \
    -v ${PWD}/tests:/go/src/terratest \
    -e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
    -e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
    -e SKIP_teardown_vpc=true \
    -e SKIP_teardown_db=true \
    -e SKIP_teardown_app=true \
    -e SKIP_redeploy_app=true \
    terratest:latest go test -run "TestWebserverStagingWithStages" -v -timeout 30m webserver_integration_test.go
```

### Run Integration test with stages - destroy infra

```shell
docker run --rm -ti \
    -v ${PWD}:/go/project \
    -v ${PWD}/tests:/go/src/terratest \
    -e AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> \
    -e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
    -e SKIP_deploy_vpc=true \
    -e SKIP_deploy_db=true \
    -e SKIP_deploy_app=true \
    -e SKIP_validate_app=true \
    -e SKIP_redeploy_app=true \
    terratest:latest go test -run "TestWebserverStagingWithStages" -v -timeout 30m webserver_integration_test.go
```
