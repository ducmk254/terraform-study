variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "instance type for ec2"

  validation {
    condition = contains(["t2.micro","t3.small"],var.instance_type)

    error_message = "Value of instance_type now allow"
  }
}