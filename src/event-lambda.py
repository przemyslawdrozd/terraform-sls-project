import boto3
import re

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('example_table')

def lambda_handler(event, context):
    title = event['title']
    description = event['description']

    if not re.match("^[a-zA-Z]+$", title) or not re.match("^[a-zA-Z]+$", description):
        return {'statusCode': 400, 'body': 'Invalid input'}

    table.put_item(
        Item={
            'title': title,
            'description': description
        }
    )

    return {
        'statusCode': 200,
        'body': 'Item added successfully'
    }