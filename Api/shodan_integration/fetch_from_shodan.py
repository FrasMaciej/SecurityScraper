import json
import requests
import os

SHODAN_API_KEY = os.getenv("SHODAN_API_KEY")  
BASE_SHODAN_URL = "https://api.shodan.io"  

def fetch_shodan_data(search_query, url_path):
    """
    Fetches data from Shodan API based on the provided search query and URL path.
    
    :param search_query: The query string for searching Shodan
    :param url_path: The specific API endpoint path (e.g., "/shodan/host/search")
    :return: JSON response from Shodan API or an error message
    """
    try:
        full_url = f"{BASE_SHODAN_URL}{url_path}" 
        response = requests.get(full_url, params={'key': SHODAN_API_KEY, 'query': search_query})
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        return {"error": str(e)}

def lambda_handler(event, context):
    """
    AWS Lambda entry point.
    
    - Expects `query` and `url_path` as query string parameters from API Gateway.
    - Calls `fetch_shodan_data` and returns the result.
    """
    query_params = event.get("queryStringParameters", {}) or {}
    
    search_query = query_params.get("query", 'title:"Kubernetes Dashboard"')  
    url_path = query_params.get("url_path", "/shodan/host/search")  

    shodan_data = fetch_shodan_data(search_query, url_path)

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(shodan_data, indent=4)
    }
