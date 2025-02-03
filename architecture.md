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

### Architecture Diagram -


