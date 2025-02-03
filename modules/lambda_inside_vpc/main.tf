


resource "aws_security_group" "sg" {
  name        = "${var.resource_tags["environ"]}-${var.lambda_function_name}-sg"
  description = "${var.resource_tags["environ"]}-${var.lambda_function_name}-sg"
  vpc_id      = var.vpc_id

  # Inbound Rules (allow all inbound traffic)
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  # Outbound Rules (allow all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Open to all IPs
  }
  tags = {
    Name = "${var.resource_tags["environ"]}-${var.lambda_function_name}-sg"
  }
}



resource "aws_iam_policy" "policy" {
  name        = "policy-${var.lambda_function_name}"
  path        = "/"
  description = "policy-${var.lambda_function_name}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "logs:CreateLogGroup",
        "Resource" : "arn:aws:logs:${var.aws_region}:${var.account_id}:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:AttachNetworkInterface"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/aws/lambda/${var.lambda_function_name}:*"
        ]
      }
    ]
  })
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "lambda-${var.lambda_function_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "${var.lambda_function_name}-attachment"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_policy_attachment" "secret-attach" {
  name       = "${var.lambda_function_name}--secret-manager-attachment"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_cloudwatch_log_group" "example" {
  name = "/aws/lambda/${var.lambda_function_name}"
}

resource "aws_lambda_function" "lambda" {

  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  layers        = length(var.lambda_layers) > 0 ? var.lambda_layers : null

  filename = "${path.module}/${var.filename}"
  runtime  = var.runtime
  handler  = var.handler
  timeout  = var.timeout
  publish  = true
  vpc_config {

    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.sg.id]
  }
  environment {
    variables = var.environment_variables
  }
}
