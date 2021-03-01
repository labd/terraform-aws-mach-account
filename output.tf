output "mach_role_id" {
  value = aws_iam_role.mach_role.id
}

output "mach_user_name" {
  value = aws_iam_user.mach_user.name
}

# output "ns_records" {
#   description = "Name servers hosted zone new site"
#   value       = aws_route53_zone.new_site.name_servers
# }
