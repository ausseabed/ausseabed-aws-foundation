output "db_host" {
  value = aws_db_instance.spt-db.address
}

output "db_port" {
  value = aws_db_instance.spt-db.port
}

output "db_name" {
  value = aws_db_instance.spt-db.name
}

output "db_user" {
  value = aws_db_instance.spt-db.username
}

output "db_password" {
  value = aws_db_instance.spt-db.password
}

