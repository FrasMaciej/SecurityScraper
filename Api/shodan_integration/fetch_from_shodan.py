import json
from datetime import datetime

import boto3
import requests

BASE_SHODAN_URL = "https://api.shodan.io"
API_KEY_PARAM_NAME = "/securityscraper/shodan/apikey"
DEFAULT_SEARCH_QUERY = ""
DEFAULT_URL_PATH = "/shodan/account"
S3_BUCKET_NAME = "S3-shodan-data"


def lambda_handler(event, context):
    """
    AWS Lambda entry point.
    - Expects `query` and `url_path` as query string parameters from API Gateway.
    - Calls `fetch_shodan_data` and saves the result to S3.
    """
    ssm = boto3.client("ssm")
    s3 = boto3.client("s3")

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

    timestamp = datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    s3_key = f"shodan_results/{timestamp}.json"
    try:
        s3.put_object(
            Bucket=S3_BUCKET_NAME,
            Key=s3_key,
            Body=json.dumps(shodan_data, indent=4),
            ContentType="application/json",
        )
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": f"Failed to save data to S3: {str(e)}"}),
        }

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"message": "Data saved to S3", "s3_key": s3_key}),
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
