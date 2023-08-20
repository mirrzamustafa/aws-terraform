resource "aws_instance" "instance" {
  count           = 2
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instances.name]
  key_name        = format("%s-%s", var.ssh_key, terraform.workspace)
  user_data       = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World ${count.index}, Environment: ${terraform.workspace}</h1>" > /var/www/html/index.html
    EOF
  depends_on      = [aws_key_pair.tf_key_pair]

}

