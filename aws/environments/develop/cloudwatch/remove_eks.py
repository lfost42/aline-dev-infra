#!/usr/bin/env python2

import boto3

def lambda_handler(event, context):
    eks_name = 'my-cluster'
    region = 'us-east-1'

    eks = boto3.client('eks', region_name=region)
    ec2 = boto3.client('ec2', region_name=region)

    # Get the VPC ID associated with the EKS cluster
    response = eks.describe_cluster(name=eks_name)
    vpc_id = response['cluster']['resourcesVpcConfig']['vpcId']

    # Delete the EKS cluster
    eks.delete_cluster(name=eks_name)

    # Delete the VPC associated with the EKS cluster
    ec2.delete_vpc(VpcId=vpc_id)
    
    return {
        'statusCode': 200,
        'body': 'Deleted EKS cluster: ' + eks_name
    }