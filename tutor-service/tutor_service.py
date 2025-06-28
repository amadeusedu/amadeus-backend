from flask import Flask, request, jsonify
import boto3

app = Flask(__name__)

# Initialize AWS clients
s3_client = boto3.client('s3')
sns_client = boto3.client('sns')

# Configuration (replace with actual values or environment variables)
S3_BUCKET = 'amadeus-uploads'
SNS_TOPIC_ARN = 'arn:aws:sns:us-east-1:123456789012:upload-review'

@app.route('/uploads/sign', methods=['POST'])
def sign_upload():
    """
    Generate a pre-signed S3 URL for uploading a file.
    """
    data = request.get_json()
    filename = data.get('filename')
    if not filename:
        return jsonify({'error': 'filename required'}), 400
    try:
        url = s3_client.generate_presigned_url(
            'put_object',
            Params={'Bucket': S3_BUCKET, 'Key': filename},
            ExpiresIn=3600
        )
        return jsonify({'url': url})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/uploads/complete', methods=['POST'])
def complete_upload():
    """
    Complete an upload: store upload record and publish SNS message.
    """
    data = request.get_json()
    upload_id = data.get('uploadId')
    user_id = data.get('userId')
    if not upload_id or not user_id:
        return jsonify({'error': 'uploadId and userId required'}), 400
    # TODO: Store upload record in database (omitted for brevity)
    message = {'uploadId': upload_id, 'userId': user_id, 'status': 'pending'}
    try:
        sns_client.publish(TopicArn=SNS_TOPIC_ARN, Message=str(message))
        return jsonify({'status': 'success', 'message': message})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(port=5001)
