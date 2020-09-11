#!/bin/bash

echo "The RDS takes about 15 minutes to save. Don't interrupt while it does this."
echo "Press q when it is done."
echo "Note, it won't tell you when it is done (check through GUI)."

set -x

SNAPSHOT_NAME="push-to-staging-"`date --iso-8601=seconds | sed "s/[-:]//g" | sed "s/+0000/Z/" | sed "s/Z/z/g" | sed "s/T/t/g`
aws rds create-db-snapshot --profile prod --db-snapshot-identifier "$SNAPSHOT_NAME" --db-instance-identifier ga-sb-prod-wh-asbwarehouse-db

# share with non-prod 288871573946
aws rds modify-db-snapshot-attribute --profile prod --db-snapshot-identifier "$SNAPSHOT_NAME" --attribute-name restore --values-to-add {"831535125571","288871573946"}

terraform taint module.postgres.aws_db_instance.asbwarehouse

echo "Add or create my.auto.tfvars with"
echo "postgres_snapshot_id = \"arn:aws:rds:ap-southeast-2:831535125571:snapshot:$SNAPSHOT_NAME\""
echo "or replace with (assuming the latter)"
echo "sed -i \"s/postgres_snapshot_id =.*/postgres_snapshot_id = \\\"arn:aws:rds:ap-southeast-2:831535125571:snapshot:$SNAPSHOT_NAME\\\"/\"" my.auto.tfvars

sed -i "s/postgres_snapshot_id =.*/postgres_snapshot_id = \"arn:aws:rds:ap-southeast-2:831535125571:snapshot:push-to-staging-20200911t043026z\"/" my.auto.tfvars

terragrunt apply

for x in `cat .env`; do export $x; done

POSTGRES_DATABASE_PROD=`echo $POSTGRES_DATABASE | sed "s/default/prod/g"`
echo "Insert password: $POSTGRES_PASSWORD"
echo "ALTER DATABASE $POSTGRES_DATABASE_PROD RENAME TO $POSTGRES_DATABASE;" | psql -U "$POSTGRES_USER" -h "$POSTGRES_HOSTNAME" -p "$POSTGRES_PORT"
