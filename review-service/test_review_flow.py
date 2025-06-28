import pytest
from flask import json
import review_service

@pytest.fixture
def client():
    review_service.app.testing = True
    client = review_service.app.test_client()
    # Clear in-memory DB before each test
    review_service.reviews_db.clear()
    return client

def test_sns_receive_and_pending(client):
    message = {'uploadId': '123'}
    resp = client.post('/sns/receive', json=message)
    assert resp.status_code == 200
    data = json.loads(resp.data)
    assert data['status'] == 'review_created'
    review_id = data['reviewId']
    # Verify pending review shows up
    resp2 = client.get('/reviews/pending')
    assert resp2.status_code == 200
    data2 = json.loads(resp2.data)
    assert any(r['uploadId'] == '123' for r in data2['pending'])

def test_approve_and_reject(client):
    # Create pending reviews
    review_service.reviews_db['rev-1'] = {'uploadId': '1', 'status': 'pending'}
    resp = client.patch('/reviews/rev-1/approve')
    assert resp.status_code == 200
    data = json.loads(resp.data)
    assert data['status'] == 'approved'
    # Test reject
    review_service.reviews_db['rev-2'] = {'uploadId': '2', 'status': 'pending'}
    resp2 = client.patch('/reviews/rev-2/reject')
    assert resp2.status_code == 200
    data2 = json.loads(resp2.data)
    assert data2['status'] == 'rejected'

def test_approve_not_found(client):
    resp = client.patch('/reviews/nonexistent/approve')
    assert resp.status_code == 404

def test_reject_not_found(client):
    resp = client.patch('/reviews/nonexistent/reject')
    assert resp.status_code == 404
