provider "aws" {
  region = "us-east-2"
  profile = "emefile.franklin"
}

terraform {
  backend "s3" {
    bucket = "wajei-terraform-up-and-running-state"
    key = "staging/services/web-server-cluster/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}

module "webserver-cluster" {
  source = "github.com/EmefileFrancis/terraform-modules//services/webserver-cluster?ref=v0.0.1"

  cluster_name = "webservers-stage"
  db_remote_state_bucket = "wajei-terraform-up-and-running-state"
  db_remote_state_key = "staging/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size = 2
  max_size = 2
}
