#-------------------------------#
#   ENVIRONMENT SPECIFICATION   #
#-------------------------------#

variable "aws_account_id" {
  description = "The AWS account id"
  type        = number
}

variable "skypicker_zone_id" {
  description = "Zone ID of Route53 zone"
  type        = string
}

variable "instance_name_without_version" {
}

variable "db_name" {
}

variable "network" {
  type    = string
  default = "eu-west-1"
}

variable "regions" {
  type        = map(string)
  description = "Map of vpc ids"

  default = {
    eu-west-1        = "eu-west-1"
    eu-central-1-old = "eu-central-1"
    eu-central-1-new = "eu-central-1"
  }
}

variable "is_production" {
}

variable "read_replica" {
  default = "0"
}

variable "tribe" {
}

variable "responsible_people" {
}

variable "communication_slack_channel" {
}

variable "alert_slack_channel" {
}

variable "repository" {
}

variable "auto_statement_timeout_enabled" {
  default = "0"
}

variable "com_kiwi_devops_auto_created" {
  default = "0"
}

variable "extra_backup_copy_enabled" {
  default = "0"
}

#----------------------------#
#   INSTANCE SPECIFICATION   #
#----------------------------#

variable "engine_version" {
}

variable "read_replica_engine_version" {
  type    = string
  default = "11.1"
}

variable "instance_class" {
}

variable "read_replica_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "multi_az" {
}

variable "allocated_storage" {
}

variable "publicly_accessible" {
}

variable "backup_retention_period" {
  type    = string
  default = "7"
}

variable "backup_window" {
  type    = string
  default = "00:00-00:30"
}

variable "maintenance_window" {
  type    = string
  default = "Mon:03:30-Mon:04:00"
}

#-----------------------#
#   DNS SPECIFICATION   #
#-----------------------#

variable "dns_ttl" {
}

variable "dns_address" {
}

variable "replica_dns_address" {
  type    = string
  default = ""
}

variable "dns_postfix" {
  type    = string
  default = "pg.skypicker.com"
}

variable "dns_v3_postfix" {
  type    = string
  default = "pg.rds.skypicker.com"
}

variable "create_dns_v2" {
  type    = bool
  default = false
}

variable "create_dns_v3" {
  type    = bool
  default = false
}

variable "create_dns_v4" {
  type    = bool
  default = true
}

#-------------------------#
#   VAULT SPECIFICATION   #
#-------------------------#

variable "vault_master_username" {
}

#----------------------------------#
#   SECURITY GROUP SPECIFICATION   #
#----------------------------------#

variable "vpc_ids" {
  type        = map(string)
  description = "Map of vpc ids"
}

variable "sg_default_allowed_ips" {
  type        = list(string)
  description = "List of default whitelisted IPs"
}

variable "sg_custom_allowed_ips" {
  type        = list(string)
  description = "List of custom whitelisted IPs"
}
