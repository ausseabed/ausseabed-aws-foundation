#!/bin/bash

echo "The RDS takes about 15 minutes to save. Don't interrupt while it does this."

# set -x

SNAPSHOT_NAME="push-to-staging-"`date --iso-8601=seconds | sed "s/[-:]//g" | sed "s/+0000/Z/" | sed "s/Z/z/g" | sed "s/T/t/g"`
echo "Creating $SNAPSHOT_NAME" 
SNAPSHOT_ID=$( aws rds create-db-snapshot --profile prod --db-snapshot-identifier "$SNAPSHOT_NAME" --db-instance-identifier ga-sb-prod-wh-asbwarehouse-db --query 'DBSnapshot.[DBSnapshotIdentifier]' --output text )

echo "Snapshot id: $SNAPSHOT_ID"
# --cli-auto-prompt ?
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/wait/db-snapshot-available.html
aws rds wait db-snapshot-completed  --profile prod --db-snapshot-identifier "$SNAPSHOT_NAME" --db-instance-identifier ga-sb-prod-wh-asbwarehouse-db 

echo "Created DB, sharing with non-prod"

# share with non-prod 288871573946
aws rds modify-db-snapshot-attribute --profile prod --db-snapshot-identifier "$SNAPSHOT_NAME" --attribute-name restore --values-to-add {"831535125571","288871573946"}

terraform taint module.postgres.aws_db_instance.asbwarehouse

echo "Add or create my.auto.tfvars with"
echo "postgres_snapshot_id = \"arn:aws:rds:ap-southeast-2:831535125571:snapshot:$SNAPSHOT_NAME\""
echo "or replace with (assuming the latter)"
echo "sed -i \"s/postgres_snapshot_id =.*/postgres_snapshot_id = \\\"arn:aws:rds:ap-southeast-2:831535125571:snapshot:$SNAPSHOT_NAME\\\"/\"" my.auto.tfvars

sed -i "s/postgres_snapshot_id =.*/postgres_snapshot_id = \"arn:aws:rds:ap-southeast-2:831535125571:snapshot:$SNAPSHOT_NAME\"/" my.auto.tfvars

terragrunt apply

for x in `cat .env`; do export "$x"; done

POSTGRES_DATABASE_PROD=`echo $POSTGRES_DATABASE | sed "s/default/prod/g"`
# echo "Insert password: $POSTGRES_PASSWORD"
echo "ALTER DATABASE $POSTGRES_DATABASE_PROD RENAME TO $POSTGRES_DATABASE;" | PGPASSWORD="$POSTGRES_PASSWORD" psql -U "$POSTGRES_USER" -h "$POSTGRES_HOSTNAME" -p "$POSTGRES_PORT"

# Could also taint and redeploy geoserver
echo "to restart geoserver:"
echo 
echo "cd ../geoserver-app-deployment"
echo "terragrunt taint module.geoserver.aws_ecs_task_definition.geoserver"
echo "terragrunt apply"
