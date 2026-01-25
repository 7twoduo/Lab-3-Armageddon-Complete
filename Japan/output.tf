
#                  Output Blocks
output "region" {
  value = data.aws_region.current.region
}
output "vpc_cidr" {
  value = var.vpc_cidr
}