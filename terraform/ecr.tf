resource "aws_ecr_repository" "ecr-nginx" {
  name = "nginx"
}

resource "aws_ecr_repository" "ecr-php-app" {
  name = "php-app"
}

resource "aws_ecr_repository" "ecr-jenkins" {
  name = "jenkins"
}
