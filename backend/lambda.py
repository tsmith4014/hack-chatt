#lambda.py
import json
import boto3
import os

s3 = boto3.client('s3')
bucket_name = os.environ['EMAIL_STORAGE_BUCKET']

def lambda_handler(event, context):
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type'
    }
    
    body = json.loads(event['body'])
    email = body.get('email')
    if email:
        try:
            # Read existing emails from S3
            existing_emails = []
            try:
                response = s3.get_object(Bucket=bucket_name, Key='emails.json')
                existing_emails = json.loads(response['Body'].read().decode('utf-8'))
            except s3.exceptions.NoSuchKey:
                # If the file doesn't exist, initialize with an empty list
                existing_emails = []

            # Add new email to the list
            existing_emails.append(email)

            # Write updated list back to S3
            s3.put_object(Bucket=bucket_name, Key='emails.json', Body=json.dumps(existing_emails))

            return {
                'statusCode': 200,
                'headers': headers,
                'body': json.dumps({'message': 'Signed up successfully!'})
            }
        except Exception as e:
            return {
                'statusCode': 500,
                'headers': headers,
                'body': json.dumps({'message': 'Error signing up.'})
            }
    return {
        'statusCode': 400,
        'headers': headers,
        'body': json.dumps({'message': 'Invalid request.'})
    }
