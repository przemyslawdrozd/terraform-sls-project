# Overview
Serverless architecture (API, Lambda, DynamoDB) in terraform to provide basic workflow
User will pass payload that will be validated by lambda retreive record from dynamodb.

![Zrzut ekranu 2023-12-9 o 12 42 03](https://github.com/przemyslawdrozd/terraform-sls-project/assets/31375100/a0a7a72a-d20c-4b9e-8615-e4b81a91dcb2)

# How To start

1. Add CLI aws user
   
3. Create local.tfvars and add:
 - account_id = <accound_id>
 - stage = <stage_name>

3. terraform apply -var-file="local.tfvars"

