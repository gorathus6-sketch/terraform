import requests
import os

# SOC ANALYST PYTHON TEMPLATE

def check_ip_reputation(ip_address):
  # use environmental variables for security
  api_key = ‘YOUR_API_KEY_HERE’
  url = ‘https://api.abuseipdb.com/api/v2/check’

  headers = {
    ‘Accept’: ‘application/json’,
    ‘Key’: api_key
  }

  params = {
    ‘ipAddress’: ip_address,
    ‘maxAgeInDay’: ‘90’
  }

  try:
    response = requests.get(url, headers=headers, params=params)
    response.raise_for_status() # check for HTTP errors

    # parse for the JSON response
    data = response.json()[‘data’]

    print(f”Results for {ip_address}:”)
    print(f” – Abuse confidence score: {data[‘abuseConfidenceScore’]}%”)
    print(f” – Country: {data[‘countryCode’]}”)
    print(f” – Usage Type: {data[‘usageType’]}”)

    if data[‘abuseConfidenceScore’] > 50:
      print(“(!) ALERT: High reputation risk detected.”)

  except Exception as e:
    print(f”Error querying API: {e}”)

# Example usage
if __name__ = “__main__”:
  target_ip = “127.0.0.1.” # replace with actual IP addr to test
  check_ip_reputation(target_ip)
