resource "aws_instance" "test-server" {
  ami = "ami-0866a3c8686eaeeba"
  instance_type = "t3.medium"
  key_name = "terraform"
  vpc_security_group_ids = ["sg-046782757398317e1"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./terraform.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/Banking-Project/terraform-files/ansibleplaybook.yml"
     }
  }
