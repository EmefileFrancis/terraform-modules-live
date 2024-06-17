provider "aws" {
  region = "us-east-2"
  profile = "emefile.franklin"
}

terraform {
  backend "s3" {
    bucket = "wajei-terraform-up-and-running-state"
    key = "prod/services/web-server-cluster/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}

module "webserver-cluster" {
  source = "../../../../modules/services/webserver-cluster"

  cluster_name = "webservers-prod"
  db_remote_state_bucket = "wajei-terraform-up-and-running-state"
  db_remote_state_key = "prod/services/web-server-cluster/terraform.tfstate"

  instance_type = "t2.micro"
  min_size = 2
  max_size = 2
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  autoscaling_group_name = module.webserver-cluster.autoscaling_group_name
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  autoscaling_group_name = module.webserver-cluster.autoscaling_group_name
  scheduled_action_name  = "scale-in-at-night"
  min_size = 2
  max_size = 10
  desired_capacity = 2
  recurrence = "0 17 * * *"
}
