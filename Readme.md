
### Architecture Diagram


![image](https://github.com/user-attachments/assets/137c18d1-c4d0-4fc1-b1b4-ec01c0e6dca6)




### Our application contains the following resources -
- VPC with private subnets, NAT, public subnets, Internet Gateway, Route tables, Subnet Group for DB.
- RDS for postgres in private subnets.
- Lambda function inside private subnets.
- Jumpbox inside public subnet, so we can connect with RDS to create database and table.
- S3 bucket and CloudFront.
- API gateway.
- CloudWatch log Group.
- CLoudwatch Metrics.

### Network flow -
When a user visits the domain, the request is routed to an S3 bucket and CloudFront, which serve the frontend. The frontend, running in the browser, communicates with a Python backend hosted on AWS Lambda via API Gateway. The Lambda function then queries an RDS PostgreSQL database and returns the response to the user.

AWS Lambda will send any issues to Sentry. Sentry will then filter these issues based on predefined conditions and send notifications to the assigned team member.

AWS Lambda, RDS PostgreSQL, and API Gateway will send logs to CloudWatch. These logs will then be pulled by Splunk and stored in its index, allowing us to search through them.







## Setup Instructions

### Generate Access key and Secret Key from AWS -
- Login to your account.
- Click on your profile > Security credentials > Create Access Key.
- Create and download the access and secret key.

### Create an SSH Key Pair
- Login to your account.
- Go to EC2 > Key Pairs.
- Create key Pair with Type RSA. Name the key pair as `< ENV >-kp`

### Create role in AWS to add in GitHub Action -
- Login to your account.
- Navigate to IAM, Click on Roles in the left panel.
- Click on the Create Role button.
- Under Trusted entity type, select Custom trust policy.
- Add a trust policy for GitHub Repository
- Attach Required Permissions
- Review and Create the Role
- You need to copy the ARN of the Role add in GitHub Action.
- Copy the Role ARN
- Go to  GitHub repository, go to Settings > Secrets and variables > Actions.
- Add ARN to secrets
<!-- - Go to GitHub Action YAML Workflow code 
- - &minus; name: Configure AWS Credentials  <br>
    >uses: aws-actions/configure-aws-credentials@v2<br>
    >with:<br>
      >>role-to-assume: \${{ secrets.AWS_ROLE_ARN }} <br>
      >>aws-region: \${{ vars.AWS_REGION }}
- Push the code and run the Github Action Workflow -->


### Configure AWS CLI to run terraform -
- Install AWS CLI if it is not already installed. Ref - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- Run command `aws configure` and put those access, secret key, default region etc.

### Create Account in Sentry -
- Go to https://sentry.io and create a account.
- Go to project > Create project > Serverless > AWS Lambda ( Python ).
- Click on "I'll create my own alerts later", Give project name and Select team.
- Click on "Manual Setup".
- Copy the Sentry DSN and paste that inside Terraform lambda file to update that as environment variable. ( sentry SDK alredy installed inside python_function.zip file and sentry related code is also there, so those will be added automatically when we will create lambda using terraform / deploy lambda using GitHub Action )
- Click on "Take me to Issues"
- Will create alert in next step.

### Create Account in Splunk -
- Go to https://www.splunk.com/ > Products > Splunk Cloud Platform > Free Trail > Give details and create account.
- You will get URL, username and password in mail.
- Login with those details which are sent via mail.
- Apps > Find more Apps > Search by "Splunk Add-on for Amazon Web Services" > Give username and password of splunk.com > Agree and install.
- Got to Apps > "Splunk Add-on for AWS" > Configuration > Account > Add > Give name, access key and secret key which you generated before, Select "Global" as Region Category. > Add.
- Will set up configuration to get log in next step.

### Apply the terraform code -
- Using terraform we are creating the following resources -
  - VPC with private subnets, NAT, public subnets, Internet Gateway, Route tables, Subnet Group for DB.
  - RDS for postgres in private subnets.
  - Lambda layer for psycopg2.
  - Lambda function inside private subnets.
  - Jumpbox inside public subnet, so we can connect with RDS to create database and table.
  - S3 bucket and CloudFront.
  - API gateway.
- To apply this -
  - Download the terraform code.
  - cd inside `environment` folder, like - "cd production"
  - Make changes to the default values in the `variables.tf` file according to the required configurations
  - terraform plan
  - terraform apply
- It will create the resources and will show required details in output.


### Connect to the Jumpbox from console and create Database and Schema in RDS -
- To get RDS host - login to AWS > RDS > Select the database server > copy the endpoint ( endpoint is same as host)
- To get username and password of the database server - RDS > Select the database server > Configuration > Click on "Manage in Secrets Manager" > Click on Retrieve secret value" and copy the username and password.

- To create database and table - EC2 > select the jumpbox > connect > Session Manager > Connect.

- Run the following commands to create database and table.
```
bash
sudo su
cd
sudo apt install -y postgresql-client

psql -h <host> -p 5432 -U <username> -d postgres
"give password"

CREATE DATABASE taskdb; #to create db

\l #to see databases

\c taskdb #to use db

CREATE TABLE tasks (
id SERIAL PRIMARY KEY,
description TEXT NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

```

### Deploy backend code - ( Mandatory )
- Go to backend repository - https://github.com/SoumikDey/mightybyte-backend
- Settings > Secrets and variables > Actions 
- Secrets - Update the following things
  - `AWS_ROLE_TO_ASSUME` - This is the role created for Github Action in previous steps 
  - `AWS_REGION`
- Variables - Update the following things
  - `LAMBDA_FUNCTION_NAME` - Get this name from the terraform output
- Then trigger the GitHub Action to deploy the backend code.



### Deploy frontend code - ( Mandatory )
- Go to frontend repository - https://github.com/SoumikDey/mightybyte-frontend
- Settings > Secrets and variables > Actions 
- Secrets - Update the following things
  - `API_URL` - Get this from the terraform output
  - `AWS_REGION`
  - `AWS_ROLE_TO_ASSUME` - This is the role created for Github Action in previous steps
- Variables - Update the following things
  - `CLOUDFRONT_DISTRIBUTION_ID` - Get this from the terraform output
  - `S3_BUCKET_NAME` - Get this from the terraform output
- Then trigger the GitHub Action to deploy the frontend code.
- Hit the CloudFront URL to access the frontend.


### Create Alert in Sentry -
- Login to Sentry and go to Alerts.
- Click on "Create Alert" > Set Conditions.
- Select "All Environments" and Select the project which you created before.
- Set below conditions -
  - A new issue is created.
  - Add optional trigger > Number of events in an issue is > more than "0" in "one minute".
  - you can also add additional triggers as per your requirement.
- perform these actions > Add action > Suggested Assignees, Team or Member > Select "Member" and Select "Member name".
- Send Test Notoficatiion. - You will get a notification in the mail which is associated with the member account.
- Set action interval > 5 minutes.
- Give a name > Select the owner > Save Rule.
- Now you will get notofication if any issue happens.
- Note: You can see Issues if you click on "issues" in left panel.
  
### Splunk Configuration to get logs -

- Configuration to get logs from lambda -
   - Settings > indexes > New Index > give name - lambda-mightybyte, Max raw data size - 0, Searchable retention - 14 days.
   - Got to Apps > "Splunk Add-on for AWS" > Input > Create new Input > Custom Data Type > CloudWatch Logs > Give name, Select AWS account, Region, give log group name, like /aws/lambda/<function_name>, Index - lambda-mightybyte, keep other things unchanged > Add.

- Configuration to get logs from Postgres -
   - Settings > indexes > New Index > give name - Postgres-mightybyte, Max raw data size - 0, Searchable retention - 14 days.
   - Got to Apps > "Splunk Add-on for AWS" > Input > Create new Input > Custom Data Type > CloudWatch Logs > Give name, Select AWS account, Region, give log group name, like /aws/rds/instance/<Database-Server-Name>/postgresql, Index - Postgres-mightybyte, keep other things unchanged > Add.
  
- Configuration to get logs from API Gateway -
   - Settings > indexes > New Index > give name - apigateway-mightybyte, Max raw data size - 0, Searchable retention - 14 days.
   - Got to Apps > "Splunk Add-on for AWS" > Input > Create new Input > Custom Data Type > CloudWatch Logs > Give name, Select AWS account, Region, give log group name, like API-Gateway-Execution-Logs_<id>/<stage>, Index - apigateway-mightybyte, keep other things unchanged > Add.

- Note: when we applied terraform to create Lambda, RDS and API Gateway, it will automatically create log group and will send log there, then Splunk will get logs from CloudWatch log group. You can find the log group name in following step - login to AWS > CloudWatch > Log groups.

- View Logs from Splunk Console -
  - Got to Apps > "Splunk Add-on for AWS" > Search > index="index-name" > Search.


### Sample Curl Command to Test the API -

For adding tasks:

```
curl -X POST <API_URL>/tasks \\
-H "Content-Type: application/json" \\
-d '{"description": "Complete the project report"}'

```

For viewing tasks:
```
curl -X GET <API_URL>/tasks
```


## Bonus challenges answers -

### CICD -
#### Frontend -
- We are using GitHub Action to deploy code in s3, once it is deployed, we are executing CloudFront Cache invalidation.
- We are using GitHub Action's Secret and variables to store values.
- Here is the example of workflow file -
```
name: Production Frontend Build and Deploy

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    name: Deploy to S3 and Invalidate CloudFront
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v2
        with:
          submodules: true

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_TO_ASSUME }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Replace API URL in JavaScript file
        run: |
          sed -i "s|const API_URL = '';|const API_URL = '${{ secrets.API_URL }}';|" script.js

      - name: Upload Files to S3
        run: |
          aws s3 cp index.html s3://${{ vars.S3_BUCKET_NAME }}/ --region ${{ secrets.AWS_REGION }} --cache-control max-age=0
          aws s3 cp script.js s3://${{ vars.S3_BUCKET_NAME }}/ --region ${{ secrets.AWS_REGION }} --cache-control max-age=0
          aws s3 cp styles.css s3://${{ vars.S3_BUCKET_NAME }}/ --region ${{ secrets.AWS_REGION }} --cache-control max-age=0

      - name: Invalidate CloudFront Cache
        run: |
          aws cloudfront create-invalidation --distribution-id ${{ vars.CLOUDFRONT_DISTRIBUTION_ID }} --paths "/*"
```
#### Backend -
- We are using GitHub Action to deploy code in Lambda function.
- We are using GitHub Action's Secret and variables to store values.
- Here is the example of workflow file -
```
name: Deploy to AWS Lmmbda

on:
  push:
    branches: 
      - main

  workflow_dispatch:

  
permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest
    environment: production

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        role-to-assume: ${{ secrets.AWS_ROLE_TO_ASSUME }}
        aws-region: ${{ secrets.AWS_REGION }}


    - name: Making Zip of the code with package
      id: zipping
      
      run: |
        rm -rf lambda_function 
        mkdir lambda_function
        cp lambda_function.py lambda_function/
        cd lambda_function
        pip3 install sentry-sdk -t .
        ls
        zip -r ../lambda_function.zip .
        cd ..

    - name: Uploading that to lambda
      id: Uploading
      
      run: |
        aws lambda update-function-code --function-name ${{ vars.LAMBDA_FUNCTION_NAME }} --zip-file fileb://lambda_function.zip

```
### Cloudwatch Alarm -
- The Cloudwatch Alarm is automatically set via teraform, where it would send an email to the concerned person when the 5XX error reaches beyond the threshold.

### Secret Manager -
- When we will apply terraform to create RDS then it will manage it's credential in AWS secret manager, also Lambda function will pull database's creds from that secret manager only ( That secret manager name is passed as variable in lambda function using terraform )

### Unit Test -
- The unit test for lambda is integrated in the CI/CD pipeline itself



## Working links

Frontend Enpoint: https://dr5mm3v9jcs5c.cloudfront.net

![image](https://github.com/user-attachments/assets/d7ca1d42-0cb6-40ae-b700-1d52e3dabd94)


API Endpoint: https://ptdc6mm3eb.execute-api.us-west-2.amazonaws.com/prod/tasks

![image](https://github.com/user-attachments/assets/01854e0a-bc45-43a6-acef-cd1ef0e6867d)


Cloudwatch Dashboard: https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#dashboards/dashboard/prod-mightybyte-lambda-dashboard?start=PT1H&end=null
![image](https://github.com/user-attachments/assets/c4d648ef-6502-48e2-b068-d712ab1d26ec)



Sentry: https://sd-consultancy.sentry.io/issues/?referrer=sidebar&statsPeriod=24h

![image](https://github.com/user-attachments/assets/74c348c0-e1ab-4e7c-a9f1-64c54b9e3214)


Splunk: 

Frontend Repo: https://github.com/SoumikDey/mightybyte-frontend

Backend Repo: https://github.com/SoumikDey/mightybyte-backend
