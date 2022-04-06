aws_region = "ap-southeast-2"
vpc_cidr   = "173.31.0.0/16"
public_cidrs = [
  "173.31.0.0/24",
  "173.31.1.0/24"
]
accessip = "0.0.0.0/0"

# geoserver/mapserver vars
server_cpu    = 2048
server_memory = 16384
#------- compute vars---------------

#fargate_cpu = 512
#fargate_memory = 1024
#geoserver_image = "288871573946.dkr.ecr.ap-southeast-2.amazonaws.com/ausseabed-geoserver:latest"

geoserver_initial_memory = "4G"
geoserver_maximum_memory = "15G"
