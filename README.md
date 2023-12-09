Serverless architecture (API, Lambda, DynamoDB) in terraform to provide basic workflow
User will pass payload that will be validated by lambda na put in dynamo.


Command to apply
Create local.tfvars
Add account_id = <accound_id>
terraform apply -var-file="local.tfvars"
![Zrzut ekranu 2023-12-9 o 12 42 03](https://github.com/przemyslawdrozd/terraform-sls-project/assets/31375100/a0a7a72a-d20c-4b9e-8615-e4b81a91dcb2)
