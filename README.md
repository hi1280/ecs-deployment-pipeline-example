# ecs-deployment-pipeline-example

Amazon ECS deployment example using GitHub Actions and Terraform and ecspresso.  
The following are available.

- A test environment is created for each pull request
- When merged into the main branch, a staging environment will be created
- Create the production environment by manually executing GitHub Actions
- GitHub's OIDC is used for authentication with AWS

## Usage

### Configuring Secrets

Add the following to Secrets.

|Name|Value|
|:--|:--|
|AWS_ACCOUNT_ID|AWS account ID|
|PERSONAL_ACCESS_TOKEN|A GitHub personal access token|
|DOMAIN|Domain name of the environment|
|TFSTATE_BUCKET|S3 bucket to store tfstate|
|SLACK_BOT_TOKEN|Slack App's Bot Token from the OAuth & Permissions page|
|SLACK_CHANNEL|Slack channel name|

### Configuring Environment Variable

Add the following to Environment Variable on Local.

|Name|Value|
|:--|:--|
|PERSONAL_ACCESS_TOKEN|A GitHub personal access token|

### Configuring Deploy Script for Production

Fix the following in `deploy-production.sh` for your environment.

|Variable|Description|
|:--|:--|
|ORG|GitHub Organization Name|
|REPO|GitHub Repository Name|
|BRANCH|Branch Name|

### Moving the files of GitHub Actions

This repository does not place workflows in `.gihub/workflows`, so move `workflows` under `.github`.

### Creating a Route53 host zone

Create a host zone for the domain.

### Creating Common Resources

```sh
cd terraform/common
terraform init -backend-config='bucket=<The bucket name set in TFSTATE_BUCKET>'
terraform apply -var domain='<Domain name>' -var repository='<GitHub Org/Repository name>'
```

## Thanks to

I used the following as a reference.
- <https://github.com/takenoko-gohan/creating-qa-environment-example>
- <https://github.com/stavshamir/docker-tutorial>
