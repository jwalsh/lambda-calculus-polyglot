import boto3
import json
import os

# Retrieve environment variables
aws_region = os.getenv('AWS_REGION', 'us-west-2')
aws_access_key_id = os.getenv('AWS_ACCESS_KEY_ID')
aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY')
aws_session_token = os.getenv('AWS_SESSION_TOKEN')
bedrock_claude_model = os.getenv('BEDROCK_CLAUDE_MODEL',
                                 'anthropic.claude-3-5-sonnet-20240620-v1:0')

# Initialize Bedrock client
bedrock = boto3.client(service_name='bedrock-runtime',
                       region_name=aws_region,
                       aws_access_key_id=aws_access_key_id,
                       aws_secret_access_key=aws_secret_access_key,
                       aws_session_token=aws_session_token)


def generate_text(prompt, max_tokens=256):
    body = json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": max_tokens,
        "messages": [{
            "role": "user",
            "content": prompt
        }]
    })

    try:
        response = bedrock.invoke_model(body=body,
                                        modelId=bedrock_claude_model,
                                        accept='application/json',
                                        contentType='application/json')

        response_body = json.loads(response.get('body').read())
        return response_body['content'][0]['text']
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return None


if __name__ == "__main__":
    prompt = input("Enter your prompt: ")
    result = generate_text(prompt)
    if result:
        print("Generated text:")
        print(result)
