
#                  Output Blocks
output "region" {
  value = data.aws_region.current.region
}
output "vpc_cidr" {
  value = var.vpc_cidr
}
output "Ec2_transit_gateway" {
  value = aws_ec2_transit_gateway.shinjuku_tgw01
}