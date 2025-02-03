module "jumpbox" {
  source                      = "../ec2_created"
  instance_name               = "jumpbox"
  instance_type               = "t3a.micro"
  key_name                    = "${var.resource_tags["environ"]}-kp"
  monitoring                  = true
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_id                      = module.vpc.vpc_id
  create_eip                  = false
  create_iam_instance_profile = true
  ami                         = "ami-06d9e8c7bf793c508"
  iam_role_policies = {
    ssmAccess = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  resource_tags = var.resource_tags
}


