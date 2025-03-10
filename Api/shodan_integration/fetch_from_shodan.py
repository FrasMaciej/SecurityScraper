import json
import requests
import os
import boto3

BASE_SHODAN_URL = 'https://api.shodan.io'
API_KEY_PARAM_NAME = '/securityscraper/shodan/apikey'
DEFAULT_SEARCH_QUERY = 'port:23'
DEFAULT_URL_PATH = '/shodan/host/search'

def lambda_handler(event, context):
    '''
    AWS Lambda entry point.
    - Expects `query` and `url_path` as query string parameters from API Gateway.
    - Calls `fetch_shodan_data` and returns the result.
    '''
    ssm = boto3.client('ssm')
    shodan_api_key = get_shodan_api_key(API_KEY_PARAM_NAME, ssm)

    query_params = event.get('queryStringParameters', {}) or {}
    
    search_query = query_params.get('query', DEFAULT_SEARCH_QUERY)  
    url_path = query_params.get('url_path', DEFAULT_URL_PATH)  

    shodan_data = fetch_shodan_data(search_query, url_path, shodan_api_key)

    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps(shodan_data, indent=4)
    }

def get_shodan_api_key(name, ssm, with_decryption=True):
    response = ssm.get_parameter(Name=name, WithDecryption=with_decryption)
    return response['Parameter']['Value']

def fetch_shodan_data(search_query, url_path, shodan_api_key):
    '''
    Fetches data from Shodan API based on the provided search query and URL path.
    
    :param search_query: The query string for searching Shodan
    :param url_path: The specific API endpoint path (e.g., "/shodan/host/search")
    :return: JSON response from Shodan API or an error message
    '''
    try:
        full_url = f'{BASE_SHODAN_URL}{url_path}'
        response = requests.get(full_url, params={'key': shodan_api_key, 'query': search_query})
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        return {'error': str(e)}