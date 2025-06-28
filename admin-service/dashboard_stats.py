from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/dashboard/stats', methods=['GET'])
def dashboard_stats():
    """
    Return counts of uploads, reviews, and feature flags.
    """
    # In a real implementation, query the database or services.
    uploads_count = 100  # placeholder count of uploads
    reviews_count = 25   # placeholder count of reviews
    flags_count   = 10   # placeholder count of feature flags
    return jsonify({
        'uploads': uploads_count,
        'reviews': reviews_count,
        'featureFlags': flags_count
    })

if __name__ == '__main__':
    app.run(port=5000)
