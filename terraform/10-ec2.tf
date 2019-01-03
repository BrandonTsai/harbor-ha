


resource "aws_security_group" "harbor-ec2-sg" {
  name        = "harbor-ec2-sg"
  vpc_id      = "${module.vpc.vpc_id}"
  description = "Security group for harbor ec2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MariaDB
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Redis
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "harbor-ec2-sg"
    Environment = "production"
  }
}

resource "aws_key_pair" "harbor_ec2_key" {
  key_name   = "harbor_ec2_key"
  public_key = "${var.ec2_public_key}"}

resource "random_shuffle" "public_subnet" {
  input = ["${module.vpc.public_subnets}"]
  result_count = 1
}

module "ec2_instances" {
  source = "terraform-aws-modules/ec2-instance/aws"

  instance_count = "${var.ec2_number_of_instances}"

  name                        = "harbor-node"
  ami                         = "${var.ec2_ami}"
  instance_type               = "${var.ec2_instance_type}"
  key_name                    = "${aws_key_pair.harbor_ec2_key.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.harbor-ec2-sg.id}"]
  subnet_id                   = "${random_shuffle.public_subnet.result[0]}"
  associate_public_ip_address = true
}

# resource "aws_security_group" "harbor-lb-sg" {
#   name        = "harbor-lb-sg"
#   vpc_id      = "${module.vpc.vpc_id}"
#   description = "Security group for harbor lb instance"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port       = 0
#     to_port         = 0
#     protocol        = "-1"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "harbor-lb-sg"
#     Environment = "production"
#   }
# }


# module "elb" {
#   source = "terraform-aws-modules/elb/aws"
#   name = "harbor-elb"

#   subnets         = ["${module.vpc.public_subnets}"]
#   security_groups = ["${aws_security_group.harbor-lb-sg.id}"]
#   internal        = false

#   listener = [
#     {
#       instance_port     = "80"
#       instance_protocol = "HTTP"
#       lb_port           = "80"
#       lb_protocol       = "HTTP"
#     },
#     {
#       instance_port     = "443"
#       instance_protocol = "TCP"
#       lb_port           = "443"
#       lb_protocol       = "TCP"
#     },
#   ]

#   health_check = [
#     {
#       target              = "HTTP:80/"
#       interval            = 30
#       healthy_threshold   = 2
#       unhealthy_threshold = 2
#       timeout             = 10
#     },
#   ]

#   tags = {
#     Environment = "production"
#   }
#   # ELB attachments
#   number_of_instances = "${var.ec2_number_of_instances}"
#   instances           = ["${module.ec2_instances.id}"]
# }