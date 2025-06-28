import boto3
from datetime import datetime, timezone, timedelta

def lambda_handler(event, context):
    # Check latest automated RDS snapshot
    rds = boto3.client('rds')
    snapshots = rds.describe_db_snapshots(
        DBInstanceIdentifier='ops-postgres-db',
        SnapshotType='automated'
    )['DBSnapshots']
    if not snapshots:
        raise Exception("No RDS snapshots found")
    latest = max(snapshots, key=lambda x: x['SnapshotCreateTime'])
    age = datetime.now(timezone.utc) - latest['SnapshotCreateTime']
    if age > timedelta(hours=24):
        raise Exception("Latest RDS snapshot is older than 24 hours")
    return {"status": "OK"}
