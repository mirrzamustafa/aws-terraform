```bash
$ aws cloudformation create-stack \
    --stack-name TerraformBackendStateBucket \
    --template-body file://cf-terraform-state.yml \
    --parameters ParameterKey=BucketName,ParameterValue=<BUCKET_NAME> \
    --capabilities CAPABILITY_NAMED_IAM
```