import json
import argparse
import re
import logging
from get_secrets import get_secret
from auth_broker import AuthBroker
from product_database import ProductDatabase
from product_catalogue_py_rest_client.models import ProductL3Dist, ProductL3Src, SurveyL3Relation, Survey
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    logging.info("Running the envent handler")
    logging.info(event)
    logging.info(context)

    logging.info(event["action"])
    logging.info(event["list-path"])

    warehouse_connection_json = json.loads(get_secret("wh-infra.auto.tfvars"))

    auth = AuthBroker(warehouse_connection_json)
    token = auth.get_auth_token()

    # connect to database
    # download stuff
    # return pointers to stuff
    if (event["action"] == "list"):
        product_database = ProductDatabase(token, event["list-path"])
        output = {"product-ids": [{"product-id": 1},
                                  {"product-id": 2}, {"product-id": 3}], "list-path": event["list-path"]}
    elif (event["action"] == "select"):
        output = {"product": {"name": "fred"}, "list-path": event["list-path"]}

    return {
        'statusCode': 200,
        'body': output
    }


if __name__ == "__main__":
    logging.info("Starting")
    event = {}
    context = {}
    event["action"] = "list"
    event["list-path"] = "https://catalogue.dev.ausseabed.gov.au/rest"
    lambda_handler(event, context)
