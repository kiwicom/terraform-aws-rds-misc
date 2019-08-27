#-------------------------------#
#   ENVIRONMENT SPECIFICATION   #
#-------------------------------#

output "instance_name_without_version" {
  value = var.instance_name_without_version
}

output "db_name" {
  value = var.db_name
}

output "network" {
  value = var.network
}

output "is_production" {
  value = var.is_production
}

output "read_replica" {
  value = var.read_replica
}

output "tribe" {
  value = var.tribe
}

output "responsible_people" {
  value = var.responsible_people
}

output "communication_slack_channel" {
  value = var.communication_slack_channel
}

output "alert_slack_channel" {
  value = var.alert_slack_channel
}

output "repository" {
  value = var.repository
}

output "auto_statement_timeout_enabled" {
  value = var.auto_statement_timeout_enabled
}

output "com_kiwi_devops_auto_created" {
  value = var.com_kiwi_devops_auto_created
}

output "extra_backup_copy_enabled" {
  value = var.extra_backup_copy_enabled
}

#----------------------------#
#   INSTANCE SPECIFICATION   #
#----------------------------#

output "engine_version" {
  value = var.engine_version
}

output "read_replica_engine_version" {
  value = var.read_replica_engine_version
}

output "instance_class" {
  value = var.instance_class
}

output "read_replica_instance_class" {
  value = var.read_replica_instance_class
}

output "multi_az" {
  value = var.multi_az
}

output "allocated_storage" {
  value = var.allocated_storage
}

output "publicly_accessible" {
  value = var.publicly_accessible
}

output "backup_retention_period" {
  value = var.backup_retention_period
}

output "backup_window" {
  value = var.backup_window
}

output "maintenance_window" {
  value = var.maintenance_window
}

#-----------------------#
#   DNS SPECIFICATION   #
#-----------------------#

resource "aws_route53_record" "dns_v2" {
  count = var.create_dns_v2 ? 1 : 0

  zone_id = var.skypicker_zone_id
  name    = "${var.instance_name_without_version}.${var.tribe}.${var.dns_postfix}"
  type    = "CNAME"
  ttl     = var.dns_ttl
  records = [var.dns_address]
}

resource "aws_route53_record" "dns" {
  count = var.create_dns_v3 ? 1 : 0

  zone_id = var.skypicker_zone_id
  name    = "${var.instance_name_without_version}.${var.dns_v3_postfix}"
  type    = "CNAME"
  ttl     = var.dns_ttl
  records = [var.dns_address]
}

resource "aws_route53_record" "dns_v4" {
  count = var.create_dns_v4 ? 1 : 0

  zone_id = var.skypicker_zone_id
  name    = "${var.instance_name_without_version}.${var.dns_postfix}"
  type    = "CNAME"
  ttl     = var.dns_ttl
  records = [var.dns_address]
}

resource "aws_route53_record" "dns_replica_v2" {
  count = var.create_dns_v2 ? var.read_replica : 0

  zone_id = var.skypicker_zone_id
  name    = "${var.instance_name_without_version}-replica.${var.tribe}.${var.dns_postfix}"
  type    = "CNAME"
  ttl     = var.dns_ttl
  records = [var.replica_dns_address]
}

resource "aws_route53_record" "dns_replica" {
  count = var.create_dns_v3 ? var.read_replica : 0

  zone_id = var.skypicker_zone_id
  name    = "${var.instance_name_without_version}-replica.${var.dns_v3_postfix}"
  type    = "CNAME"
  ttl     = var.dns_ttl
  records = [var.replica_dns_address]
}

resource "aws_route53_record" "dns_replica_v4" {
  count = var.create_dns_v4 ? var.read_replica : 0

  zone_id = var.skypicker_zone_id
  name    = "${var.instance_name_without_version}-replica.${var.dns_postfix}"
  type    = "CNAME"
  ttl     = var.dns_ttl
  records = [var.replica_dns_address]
}

#-------------------------#
#   VAULT SPECIFICATION   #
#-------------------------#

resource "random_string" "master_user_password" {
  length  = 20
  special = false
}

resource "random_string" "datadog_user_password" {
  length  = 20
  special = false
}

resource "vault_generic_secret" "master_user_vault_secret" {
  path = "secret/platform/storage/${var.instance_name_without_version}/master"

  data_json = <<EOT
{
  "username": "${var.vault_master_username}",
  "password": "${random_string.master_user_password.result}"
}
EOT
}

resource "vault_generic_secret" "datadog_user_vault_secret" {
  path = "secret/platform/storage/${var.instance_name_without_version}/datadog"

  data_json = <<EOT
{
  "username": "datadog",
  "password": "${random_string.datadog_user_password.result}"
}
EOT
}

output "master_username" {
  value = var.vault_master_username
}

output "master_password" {
  value = random_string.master_user_password.result
}

#----------------------------------#
#   SECURITY GROUP SPECIFICATION   #
#----------------------------------#

resource "aws_security_group" "security_group" {
  name     = "rds-${var.instance_name_without_version}"
  vpc_id   = var.vpc_ids[var.network]
  provider = aws

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "TCP"

    cidr_blocks = var.sg_default_allowed_ips
  }

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "TCP"

    cidr_blocks = var.sg_custom_allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "security_group" {
  value = aws_security_group.security_group.id
}
