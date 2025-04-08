import json
from datetime import datetime, timezone

import boto3
import requests

BASE_SHODAN_URL = "https://api.shodan.io"
API_KEY_PARAM_NAME = "/securityscraper/shodan/apikey"
DEFAULT_SEARCH_QUERY = ""
DEFAULT_URL_PATH = "/api-info"
DYNAMODB_TABLE_NAME = "collector-reports-storage-table"


def lambda_handler(event, context):
    """
    AWS Lambda entry point.
    - Expects `query` and `url_path` as query string parameters from API Gateway.
    - Calls `fetch_shodan_data` and saves the result to DynamoDB.
    """
    ssm = boto3.client("ssm")
    dynamodb = boto3.client("dynamodb")

    try:
        shodan_api_key = get_shodan_api_key(API_KEY_PARAM_NAME, ssm)
    except ValueError as e:
        return {"statusCode": 400, "body": json.dumps({"error": str(e)})}
    except RuntimeError as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}

    query_params = event.get("queryStringParameters", {}) or {}
    search_query = query_params.get("query", DEFAULT_SEARCH_QUERY)
    url_path = query_params.get("url_path", DEFAULT_URL_PATH)

    if not isinstance(search_query, str) or not isinstance(url_path, str):
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Invalid input parameters."}),
        }

    shodan_data = fetch_shodan_data(search_query, url_path, shodan_api_key)

    timestamp = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    try:
        dynamodb.put_item(
            TableName=DYNAMODB_TABLE_NAME,
            Item={
                "PrimaryKey": {"S": timestamp},
                "Data": {"S": json.dumps(shodan_data, indent=4)},
            },
        )
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": f"Failed to save data to DynamoDB: {str(e)}"}),
        }

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "Content-Type",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
        },
        "body": json.dumps(shodan_data, indent=4),
    }


def get_shodan_api_key(name, ssm, with_decryption=True):
    try:
        response = ssm.get_parameter(Name=name, WithDecryption=with_decryption)
        return response["Parameter"]["Value"]
    except ssm.exceptions.ParameterNotFound:
        raise ValueError(f"SSM Parameter '{name}' not found.")
    except Exception as e:
        raise RuntimeError(f"Failed to retrieve SSM parameter: {str(e)}")


def fetch_shodan_data(search_query, url_path, shodan_api_key):
    """
    Fetches data from Shodan API based on the provided search query and URL path.

    :param search_query: The query string for searching Shodan
    :param url_path: The specific API endpoint path (e.g., "/shodan/host/search")
    :return: JSON response from Shodan API or an error message
    """
    try:
        full_url = f"{BASE_SHODAN_URL}{url_path}"
        response = requests.get(
            full_url, params={"key": shodan_api_key, "query": search_query}, timeout=10
        )
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        return {"error": str(e)}
