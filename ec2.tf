resource "aws_spot_instance_request" "instance" {
  ami           = data.aws_ami.ami.image_id
  spot_price    = data.aws_ec2_spot_price.spot_price.spot_price
  instance_type = var.INSTANCE_TYPE
  wait_for_fulfillment = true
  vpc_security_group_ids =  [aws_security_group.sg.id]
  subnet_id = var.PRIVATE_SUBNET_ID
  iam_instance_profile = aws_iam_instance_profile.profile.name

  tags = {
    Name = local.TAG_NAME
  }
}

resource "aws_ec2_tag" "tag" {
  resource_id = aws_spot_instance_request.instance.spot_instance_id
  key         = "Name"
  value       = local.TAG_NAME
}


resource "null_resource" "null" {
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_USER"]
      password = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_PASS"]
      host     = aws_spot_instance_request.instance.private_ip
    }
    inline = [
      "ansible-pull -U https://github.com/GurukaYadav/roboshop-ansible.git roboshop.yml -e HOST=localhost -e ROLE=${var.COMPONENT} -e ENV=${var.ENV}" ,
    ]
  }
}