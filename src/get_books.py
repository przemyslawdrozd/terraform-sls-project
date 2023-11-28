import boto3
import re
import os
import json
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('books_table')

books_table_name = os.getenv('BOOKS_TABLE_NAME')


def lambda_handler(event, context):
    logger.info('This is an INFO log')
    logger.info(f'event {event}')

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(books_table_name)

    try:
        response = table.get_item(
            Key={
                'title': 'pirate'
            }
        )
        logger.info(f"db res {response}")
    except Exception as e:
        logger.error(e)
        return {
            'statusCode': 500,
            'body': 'Error while getting item'
        }
    
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps(response.get('Item'))
    }