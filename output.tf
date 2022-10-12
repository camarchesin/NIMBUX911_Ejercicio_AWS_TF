####  ALB URL  #############################################################
output "Load-Balancer-URL" {
  value = aws_lb.ALB_1.dns_name
}