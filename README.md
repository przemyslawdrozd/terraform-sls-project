Serverless architecture (API, Lambda, DynamoDB) in terraform to provide basic workflow
User will pass payload that will be validated by lambda na put in dynamo.


Command to apply
Create local.tfvars
Add account_id = <accound_id>
terraform apply -var-file="local.tfvars"
