from flask import Flask, request, jsonify

app = Flask(__name__)

# In-memory store of reviews (for demonstration)
reviews_db = {}

@app.route('/reviews/pending', methods=['GET'])
def get_pending_reviews():
    # Return list of reviews with status 'pending'
    pending = [r for r in reviews_db.values() if r.get('status') == 'pending']
    return jsonify({'pending': pending})

@app.route('/reviews/<review_id>/approve', methods=['PATCH'])
def approve_review(review_id):
    review = reviews_db.get(review_id)
    if not review:
        return jsonify({'error': 'Review not found'}), 404
    review['status'] = 'approved'
    return jsonify({'status': 'approved', 'review': review})

@app.route('/reviews/<review_id>/reject', methods=['PATCH'])
def reject_review(review_id):
    review = reviews_db.get(review_id)
    if not review:
        return jsonify({'error': 'Review not found'}), 404
    review['status'] = 'rejected'
    return jsonify({'status': 'rejected', 'review': review})

@app.route('/sns/receive', methods=['POST'])
def sns_receive():
    # SNS subscription endpoint to receive messages about new uploads
    message = request.get_json()
    upload_id = message.get('uploadId')
    if not upload_id:
        return jsonify({'error': 'uploadId missing'}), 400
    # Create new pending review record
    review_id = f"rev-{upload_id}"
    reviews_db[review_id] = {'uploadId': upload_id, 'status': 'pending'}
    return jsonify({'status': 'review_created', 'reviewId': review_id})

if __name__ == '__main__':
    app.run(port=5002)
