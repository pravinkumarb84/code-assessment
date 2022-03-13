# challenge 1

path - `code-assessment/challenge1/`

# Pre Requirements
- Terraform >= `v1.0.1`


- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`environment variables set in aws config file and `AWS_PROFILE`exported as`code-assessment`.


- s3 bucket created -`code-assessment-tf-state`


- dynamodb table created -`terraform-lock` with LockID as key

from the path `code-assessment/challenge1/terraform/infra`

Initializing Terrraform remote backend:
`terraform init -backend-config=var/bootstrap.hcl`

Run the terraform plan command
`terraform plan`

Run the terraform apply command
`terraform apply`

# challenge 2

path - `code-assessment/challenge2/`

primary file - query_metadata.py

# challenge 3

path - `code-assessment/challenge3/`

file - nestedobject.py

command to execute - `python3 nestedobject.py --object '{"a":{"b":{"c":"d"}}}' --key 'a/b/c'`
