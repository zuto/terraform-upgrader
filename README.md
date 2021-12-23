# Terraform Version Upgrader

This tool is designed to run the necessary steps to upgrade from version 0.12 of terraform to version 1.

It will perform the following steps:

1. Check for any changes with version 0.12.31
2. Run `terraform 0.13upgrade -yes` to update the terraform files to be compatible with 0.13+
3. Plan and apply with version 0.13.7 _only_ if there are no changes in the plan
4. Plan and apply with version 0.14.11 _only_ if there are no changes in the plan
5. Plan and apply with version 1.1.2 _only_ if there are no changes in the plan

## Prerequisites

1. Have your target project cloned locally
2. Revert/reset your project to make sure there are no local changes
3. Your project terraform is functional, if outdated.
4. Have to hand all input variables for your projects current state (e.g. service_version)

## Usage

```
git clone git@github.com:zuto/terraform-upgrader.git
sh build.sh
sh run.sh TERRAFORM_DIR WORKSPACE
```

Example: `sh run.sh "c:\Users\tim.borrowdale\code\web-gateway\deploy\terraform" qa` would upgrade the web-gateway terraform to be compatible with 0.13+ and migrate the state to version 1.1.2

## Authentication

You will need to provide authentication methods for aws and github in order for this to work with the majority of Zuto applications.

### AWS

Authentication to AWS is via envionment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`) which can be set in the shell before running `run.sh`

### Github

Authentication to Github is via SSH keys. By default the run script will mount your .ssh folder assuming it is located in the base of your user directory (e.g. `c:\Users\tim.borrowdale\.ssh\`) and will add a key named `github`. If you want to change either of these values simply edit `run.sh`

## Terraform input variables

For most zuto applications there will be some required terraform input variables, even if it's just `service_version`. The best way to provide these is to temporarily add a terraform variables file to your terraform directory as described at https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files. Alternatively you can modify `run.sh` to pass in variables as environment variables in the format of TF_VAR_variablename.

## Skipping earlier versions

If your project is already greater than version 0.12 but is not at version 1 or later, you can modify `run.sh` and change the `STARTVER` environment variable sent to the container to be any of 12,13 or 14. This will skip the earlier version steps

## Multiple workspace projects

If, like many of Zutos ECS applications, your project uses terraform workspaces you will need to run the container for each workspace, in order to do this you will need to set new AWS credentials for the correct environment and revert any changes made to the terraform files (as we need to start again from 0.12).

### Example run through

```sh
cd /c/Users/tim.borrowdale/code
git clone git@github.com:zuto/web-gateway.git
echo service_version = "\"1.0.17\"" > web-gateway/deploy/terraform/terraform.tfvars
git clone git@github.com:zuto/terraform-upgrader.git
cd terraform-upgrader
sh build.sh

<export AWS credentials for QA account>
sh run.sh "C:\Users\tim.borrowdale\code\web-gateway\deploy\terraform" qa # important to use windows path style for the input location 

# wait for completion or fix any errors and repeat


git -C ../web-gateway reset --hard

<export AWS credentials for PROD account>
sh run.sh "C:\Users\tim.borrowdale\code\web-gateway\deploy\terraform" prod

# wait for completion or fix any errors and repeat

# commit changes once done all workspaces
cd ../web-gateway
rm deploy/terraform/terraform.tfvars
git add .
git commit "upgraded terraform"
git push
```
