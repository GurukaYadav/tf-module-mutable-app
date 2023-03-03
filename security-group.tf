resource "aws_security_group" "sg" {
  name        = "${local.TAG_NAME}-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      =  var.VPC_ID

  ingress {
    description      = "TLS from VPC"
    from_port        = var.PORT
    to_port          = var.PORT
    protocol         = "tcp"
    cidr_blocks      = var.PRIVATE_SUBNET_CIDR
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = var.SSH_PORT
    to_port          = var.SSH_PORT
    protocol         = "tcp"
    cidr_blocks      = [var.WORKSTATION_IP]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.TAG_NAME}-sg"
  }
}