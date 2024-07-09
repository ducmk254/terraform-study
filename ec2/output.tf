output "public_ip" {
  value = {
    public_ip = aws_instance.hello.public_ip
  }
}