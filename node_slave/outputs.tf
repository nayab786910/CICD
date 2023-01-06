output "instance_id" {
  value = aws_instance.my_instance.public_ip
}
output "elastic_ip" {
 value = aws_eip.elastic_ip.allocation_id
}
output "security_group" {
 value = aws_security_group.ec2-sg.id
}
output "volume_id" {
 value = aws_ebs_volume.volume.id
}
