#!/usr/bin/env python2

import boto3

region = 'us-east-1'
rds = boto3.client('rds', region_name=region)

def lambda_handler(event, context):
    response = rds.describe_db_instances()
    for db in response['DBInstances']:
        if db['DBInstanceStatus'] == 'available':
            db_instance_identifier = db['DBInstanceIdentifier']
            print(f"Stopping RDS instance {db_instance_identifier}")
            rds.stop_db_instance(DBInstanceIdentifier=db_instance_identifier)