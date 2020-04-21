aws_region = "ap-southeast-2"

/**
This should not exceed whatever AZs are available in region, i.e. 3 max AZs for ap-southeast-2 (SYDNEY)
*/
az_count = 3

/** 10.16.0.0 - 10.19.255.255 VPC */
ga_sb_vpc_cidr = "10.16.0.0/16"

ga_sb_vpc_secondary_cidrs = [
    "10.17.0.0/16",
    "10.18.0.0/16"
]

ga_sb_web_subnet_cidrs = [
    "10.16.0.0/20",
    "10.16.16.0/20",
    "10.16.32.0/20"
]

ga_sb_web_subnet_segments = [
  "10.16.0.0/18"
]


ga_sb_app_subnet_cidrs = [
    "10.17.0.0/20",
    "10.17.16.0/20",
    "10.17.32.0/20"
]

ga_sb_app_subnet_segments = [
    "10.17.0.0/18"
]

ga_sb_db_subnet_cidrs = [
    "10.18.0.0/20",
    "10.18.16.0/20",
    "10.18.32.0/20"
]

ga_sb_db_subnet_segments = [
    "10.18.0.0/18"
]
