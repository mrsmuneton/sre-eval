provider "aws" {
  region  = "us-west-2"
}

resource "aws_ecr_repository" "ecr-nginx" {
  name = "nginx"
}

resource "aws_ecr_repository" "ecr-php-app" {
  name = "php-app"
}
