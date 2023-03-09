#!/usr/bin/env python2

import boto3

def lambda_handler(event, context):
    alarm_name = event['detail']['alarmName']
    alarm_state = event['detail']['state']['value']
    instance_id = event['detail']['dimensions']['InstanceId'][0]

    if alarm_state == 'ALARM':
        ec2 = boto3.client('ec2')
        ec2.stop_instances(InstanceIds=[instance_id])
        print('Stopped instance: ' + instance_id)
    else:
        print('Alarm ' + alarm_name + ' in state: ' + alarm_state)
