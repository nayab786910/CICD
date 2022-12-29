# #---------------------------------------------------------
# instance variables
#---------------------------------------------------------
variable "ami_id" {
  description = "AMI ID"
  type = string
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
}

variable "instance_type" {
 description = "instance type for ec2 instance"
 type = string
}

variable "availability_zone" {
  description = "AZ to start the instance in"
  type        = string
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  type        = bool
  default     = true
}


variable "subnet_pub" {
  description = "Subnet id where the instance should create"
  type = string
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = string
}

variable "volume_size" {
 description = "volume size attaching to Ec2 instance"
 type = number
}

variable "volume_type" {
 description = "volume type attaching to EC2 instance"
 type = string
}

variable "vpc_id" {
  type = string
  description = "vpc id for security group"
}

variable "device_name" {
  description = "Additional EBS block devices to attach to the instance"
  type        = string
}
variable "user" {
   default = "ubuntu"
}
