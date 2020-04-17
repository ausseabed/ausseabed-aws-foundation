aws_region = "ap-southeast-2"

/**
This should not exceed whatever AZs are available in region, i.e. 3 max AZs for ap-southeast-2 (SYDNEY)
*/
az_count = 3

ga_sb_vpc_cidr = "10.30.0.0/16"

ga_sb_vpc_secondary_cidrs = [
    "10.130.0.0/16",
    "10.230.0.0/16"
]
ga_sb_web_subnet_cidrs = [
    "10.30.0.0/20",
    "10.130.0.0/20",
    "10.230.0.0/20"
]


ga_sb_app_subnet_cidrs = [
    "10.30.16.0/20",
    "10.130.16.0/20",
    "10.230.16.0/20"
]

ga_sb_db_subnet_cidrs = [
    "10.30.32.0/20",
    "10.130.32.0/20",
    "10.230.32.0/20"
]

