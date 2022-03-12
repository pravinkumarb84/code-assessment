data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

locals {
  count = length(var.az_list)
}

resource "aws_launch_configuration" "code_assessment" {
  image_id        = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg.id]
  user_data       = <<EOF
            #! /bin/bash
            sudo apt-get update -y && apt-get install -y docker.io
            docker pull nginx:latest
            docker run -d -p 80:80 --name nginx nginx
EOF
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "code_assessment_asg" {
  name                      = "code-assessment-autoscaling-group"
  max_size                  = 6
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  launch_configuration      = aws_launch_configuration.code_assessment.id
  vpc_zone_identifier       = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  force_delete              = true
  tag {
    key                 = "Name"
    value               = "code-assessment-asg"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_attachment" "code_assessment_asg_attachment" {
  lb_target_group_arn    = aws_lb_target_group.code_assessment_tg.arn
  autoscaling_group_name = aws_autoscaling_group.code_assessment_asg.id
}