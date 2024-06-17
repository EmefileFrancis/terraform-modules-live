provider "aws" {
  region = "us-east-2"
  profile = "emefile.franklin"
}

terraform {
  backend "s3" {
    bucket = "wajei-terraform-up-and-running-state"
    key = "prod/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}

module "mysql_database" {
  source = "../../../../modules/data-stores/mysql"

  db_username = var.db_username
  db_password = var.db_password
  db_remote_state_bucket = "wajei-terraform-up-and-running-state"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
}
