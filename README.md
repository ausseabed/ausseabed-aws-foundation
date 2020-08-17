
<!-- omit in toc -->
# Contents
- [Introduction](#introduction)
- [Architecture](#architecture)
- [How Tos](#how-tos)
  - [Build Production Infrastructure From scratch](#build-production-infrastructure-from-scratch)
  - [Running the processing pipeline](#running-the-processing-pipeline)
  - [Release a new version of data to the portal](#release-a-new-version-of-data-to-the-portal)

# Introduction
The ausseabed-aws-foundation repository provides Infrastructure as Code (IaC) for the AusSeabed initiative (see [ausseabed](http://ausseabed.gov.au/)). The initiative aims to make bathymetry products available to the public through cloud-based services and web portals. The code in this repository configures infrastructure such as networking, computing resources and container repositories for housing, processing and distributing bathymetry.

# Architecture
The main components of the ausseabed-aws-foundation are:
* AWS backbone infrastructure (VPCs, routing tables and IAM etc)
* [product-catalogue](https://github.com/ausseabed/product-catalogue) infrastructure (networking, route53, etc.) in pcat-infra
* Postgres Database: The database houses the information about bathymetry - in wh-infra
* [warehouse-ogc-webservices](https://github.com/ausseabed/warehouse-ogc-webservices) infrastructure (geoserver) in geoserver-app-deployment
* [product-catalogue](https://github.com/ausseabed/product-catalogue) application (ecs setup etc) in pcat-app-deployment
* [processing-pipeline](https://github.com/ausseabed/processing-pipeline) (networking, workflows and lambdas) in pp-infra

More detail about the application structures is in their respective repos.

# How Tos 

* Updating the Product Catalogue (See [product-catalogue](https://github.com/ausseabed/product-catalogue))
* Updating the Warehouse Image (See [warehouse-ogc-webservices](https://github.com/ausseabed/warehouse-ogc-webservices))
* Updating the Warehouse data version (See [warehouse-ogc-webservices](https://github.com/ausseabed/warehouse-ogc-webservices))

## Build Production Infrastructure From scratch
1. Set up prod-data account (roles for terraform state, ECR, public s3 bucket)
2. Run terragrunt in infra to setup the production environment
3. Set up appropriate secrets (TODO itemise these)
4. Terraform Postgres database, then pcat-infra, then pcat-app-deployment, then geoserver

## Running the processing pipeline
1. Copy latest container images from non-prod to prod
2. Terraform the latest lamdas and step functions from ausseabed-aws-foundation account
3. Run the step function (ga-sb-prod-update-l3-warehouse) from AWS with appropriate inputs. E.g., 
```
{
  "cat-url": "https://catalogue.ausseabed.gov.au/rest",
  "bucket": "ausseabed-public-warehouse-bathymetry",
  "proceed": false
}
```

## Release a new version of data to the portal
1. Ensure the product catalogue has all the records required (check to make sure all the names are consistent etc.)
2. Run the processing pipeline from AWS (this creates distributables)
3. Make public the records in prod-data 
4. Update the snapshot time on the warehouse (causing the warehouse to restart and load the new records)
5. Export the portal records from the product catalogue
