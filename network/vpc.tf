#
# the ECS optimized AMI's change by region. You can lookup the AMI here:
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
#
# us-east-1 ami-aff65ad2
# us-east-2 ami-64300001
# us-west-1 ami-69677709
# us-west-2 ami-40ddb938
#

#
# need to add security group config
# so that we can ssh into an ecs host from bastion box
#

resource "aws_launch_configuration" "ecs-launch-configuration" {
  name = "ecs-launch-configuration"
  image_id = "ami-40ddb938"
  instance_type = "t2.medium"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"

  root_block_device {
    volume_type = "standard"
    volume_size = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  associate_public_ip_address = "false"
  key_name = "testone"

  #
  # register the cluster name with ecs-agent which will in turn coord
  # with the AWS api about the cluster
  #
  # user_data = <> /etc/ecs/ecs.config
  # EOF
}

#
# need an ASG so we can easily add more ecs host nodes as necessary
#
resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name = "ecs-autoscaling-group"
  max_size = "2"
  min_size = "1"
  desired_capacity = "1"

  # vpc_zone_identifier = ["subnet-41395d29"]
  vpc_zone_identifier = ["${aws_subnet.private_subnet.id}"]
  launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "ECS-userpics"
    propagate_at_launch = true
  }
}

resource "aws_ecs_cluster" "ecs-userpics" {
  name = "userpics"
}

output "address" {
  value = "${aws_elb.web.dns_name}"
}

variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "key_name" {
  description = "Desired name of AWS key pair"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-674cbc1e"
    us-east-1 = "ami-1d4e7a66"
    us-west-1 = "ami-969ab1f6"
    us-west-2 = "ami-8803e0f0"
  }
}
