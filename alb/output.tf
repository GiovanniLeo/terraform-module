output "target_group_arn" {
  value = aws_alb_target_group.lb_target_group.arn
}

output "alb_dns" {
  value = aws_lb.lb_for_auto_scaling_group.dns_name
}
