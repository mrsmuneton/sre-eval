provider "aws" {
  region     = "us-west-2"
}

resource "aws_ecs_cluster" "userpics" {
  name = "userpics"
}
