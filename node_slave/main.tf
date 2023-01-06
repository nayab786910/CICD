locals {
   ingress_rules = [{
     port          = 80
     description   = "tcp  port number"
     protocol      = "tcp"
    },
    {
    port          = 22
     description   = "SSH port number"
     protocol      = "tcp"
   },
   {
     port          = 443
     description   = "jenkins port number"
     protocol      = "tcp"
   }]
 }
#-------------------------------------
# creating a security group for ec2 instance
#-------------------------------------
 resource "aws_security_group" "ec2-sg" {
   vpc_id = var.vpc_id

   dynamic "ingress" {
     for_each  = local.ingress_rules
     content{
       from_port     = ingress.value.port
       to_port       = ingress.value.port
       description   = ingress.value.description
       protocol      = ingress.value.protocol
       cidr_blocks   = ["0.0.0.0/0"]
     }
   }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
   tags =  {
       Name = "${var.tags}-securitygroup"
   }
 }

#-----------------------------------
#Creating a AWS Instance
#-------------------------------

resource "aws_instance" "my_instance" {
  ami                           = var.ami_id
  associate_public_ip_address   = var.associate_public_ip_address
  instance_type                 = var.instance_type
  availability_zone             = var.availability_zone
  key_name                      = var.key_name
  subnet_id                     = var.subnet_pub

  vpc_security_group_ids         = [aws_security_group.ec2-sg.id]
  tenancy                        = var.tenancy
  depends_on                    = [aws_security_group.ec2-sg]

    provisioner "remote-exec" {
    inline = ["echo 'java_slave'"]
   }

   connection {
    type        = "ssh"
    user        = var.user
    private_key = file("ohio.pem")
    host        = self.public_ip
  }
    provisioner "local-exec" {
    command = "sleep 30; ansible-playbook -i ${self.private_ip}, -u ${var.user} --key-file ${var.key_name}.pem sample.yml"
  }


 tags = {
  Name  = var.tags
  }
}
#----------------------------------------
# creating a elastic ip for ec2 instance
#-----------------------------------
resource "aws_eip" "elastic_ip" {
  instance      = aws_instance.my_instance.id
  vpc           = true
  depends_on    = [aws_instance.my_instance]

  tags = {

   Name = "${var.tags}-eip"
 }
}

#-------------------------------------------
# Creating a EBS volume
#-----------------------------------
resource "aws_ebs_volume" "volume" {
  availability_zone = var.availability_zone
  size              = var.volume_size
  type              = var.volume_type
  depends_on    = [aws_instance.my_instance]

  tags = {
     Name = "${var.tags}-ebs"
  }
}

#-------------------------------------------
#Attaching EBS volume to the ec2 instance
#-------------------------------------------
resource "aws_volume_attachment" "volume-attach" {
  device_name = var.device_name
  volume_id   = aws_ebs_volume.volume.id
  instance_id = aws_instance.my_instance.id
}
