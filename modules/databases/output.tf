output "db_host" {
  value = aws_db_instance.default.address
}

# output "secret" {
#   value = aws_db_instance.default.master_user_secret
# }

output "secret" {
  value = join("-", slice(split("-", element(split(":", aws_db_instance.default.master_user_secret[0].secret_arn), 6)), 0, length(split("-", element(split(":", aws_db_instance.default.master_user_secret[0].secret_arn), 6))) - 1))
}
