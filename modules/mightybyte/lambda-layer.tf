resource "aws_lambda_layer_version" "lambda_layer" {
  filename                 = "${path.module}/psycopg2-layer.zip"
  layer_name               = "psycopg2-layer"
  compatible_architectures = ["x86_64"]
  compatible_runtimes = ["python3.12"]
}
