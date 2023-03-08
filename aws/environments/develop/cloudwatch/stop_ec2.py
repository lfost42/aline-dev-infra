import boto3

region = 'us-east-1'
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    # Get all running instances in the region
    instances = ec2.describe_instances(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
    instance_ids = [instance['InstanceId'] for reservation in instances['Reservations'] for instance in reservation['Instances']]
    
    # Stop all running instances
    ec2.stop_instances(InstanceIds=instance_ids)
    print('stopped your instances: ' + str(instance_ids))