aws_region = "ap-southeast-2"
#project_name = "ausseabed-processing-pipeline"
#------- compute vars---------------

fargate_cpu = 512
fargate_memory = 1024
caris_caller_image = "288871573946.dkr.ecr.ap-southeast-2.amazonaws.com/callcarisbatch:caris_caller_image-latest"
startstopec2_image = "288871573946.dkr.ecr.ap-southeast-2.amazonaws.com/callcarisbatch:startstopec2_image-latest"

gdal_image = "ausseabed-gdal:latest"
mbsystem_image = "ausseabed-mbsystem:latest"
pdal_image = "ausseabed-pdal:latest"


local_storage_folder="D:\\\\awss3bucket"

prod_data_s3_account_canonical_id="007391679308"
