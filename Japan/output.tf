
#                  Output Blocks
output "region" {
  value = data.aws_region.current.region
}
output "vpc_cidr" {
  value = aws_vpc.Star.cidr_block
}
output "Ec2_transit_gateway" {
  value = aws_ec2_transit_gateway.shinjuku_tgw01.id
}
# output "Ec2_transit_gateway" {
#   value = aws_db_instance.below_the_valley.address
# }
