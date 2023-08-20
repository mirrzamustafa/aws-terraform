output "load_balancer_address" {
  value = aws_lb.load_balancer.id
}

output "instances_address" {
  value = aws_instance.instance[*].public_ip
}

