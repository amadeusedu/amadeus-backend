import pytest
from flask import json
import tutor_service

@pytest.fixture
def client(monkeypatch):
    # Patch AWS clients to avoid real AWS calls
    class DummyS3:
        def generate_presigned_url(self, ClientMethod, Params=None, ExpiresIn=None):
            return f"https://s3.amazonaws.com/{Params['Bucket']}/{Params['Key']}?presigned"
    class DummySNS:
        def __init__(self):
            self.published = []
        def publish(self, TopicArn=None, Message=None):
            self.published.append((TopicArn, Message))
            return {'MessageId': 'dummy'}
    monkeypatch.setattr(tutor_service, 's3_client', DummyS3())
    dummy_sns = DummySNS()
    monkeypatch.setattr(tutor_service, 'sns_client', dummy_sns)
    tutor_service.app.testing = True
    return tutor_service.app.test_client()

def test_sign_upload_success(client):
    response = client.post('/uploads/sign', json={'filename': 'test.txt'})
    assert response.status_code == 200
    data = json.loads(response.data)
    assert 'url' in data
    assert data['url'].startswith('https://s3.amazonaws.com/')

def test_sign_upload_no_filename(client):
    response = client.post('/uploads/sign', json={})
    assert response.status_code == 400
    data = json.loads(response.data)
    assert 'error' in data

def test_complete_upload_success(client):
    resp = client.post('/uploads/complete', json={'uploadId': '123', 'userId': 'u1'})
    assert resp.status_code == 200
    data = json.loads(resp.data)
    assert data['status'] == 'success'
    assert data['message']['uploadId'] == '123'
    assert data['message']['userId'] == 'u1'

def test_complete_upload_missing_fields(client):
    resp = client.post('/uploads/complete', json={'uploadId': '123'})
    assert resp.status_code == 400
    data = json.loads(resp.data)
    assert 'error' in data
