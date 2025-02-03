locals {
}
# Create an EC2 instance and attach the new key pair
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_security_group" "sg" {
  name        = "${var.resource_tags["environ"]}-${var.instance_name}-sg"
  description = "${var.resource_tags["environ"]}-${var.instance_name}-sg-for-ec2"
  vpc_id      = var.vpc_id

  # Inbound Rules (allow all inbound traffic)
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  # Outbound Rules (allow all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Open to all IPs
  }
  tags = {
    Name = "${var.resource_tags["environ"]}-${var.instance_name}-sg"
  }
}


module "ec2_instance" {
  source                      = "../ec2_instance_public"
  ami                         = coalesce(var.ami, data.aws_ami.ubuntu.id)
  create_iam_instance_profile = var.create_iam_instance_profile
  iam_role_policies           = var.iam_role_policies
  name                        = "${var.resource_tags["environ"]}-${var.instance_name}"

  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = var.monitoring
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = var.subnet_id
  create_eip             = var.create_eip

  tags = var.resource_tags
}


