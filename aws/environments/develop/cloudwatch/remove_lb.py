#!/usr/bin/env python2

import boto3

region_name = 'us-east-1'

elbv2 = boto3.client('elbv2', region_name=region_name)

# Get all load balancers in the region
load_balancers = elbv2.describe_load_balancers()

# Delete each load balancer
for lb in load_balancers['LoadBalancers']:
    if lb['Type'] in ['application', 'network']:
        print(f"Deleting {lb['Type']} load balancer {lb['LoadBalancerName']}...")
        elbv2.delete_load_balancer(LoadBalancerArn=lb['LoadBalancerArn'])

print("All application and network load balancers deleted!")