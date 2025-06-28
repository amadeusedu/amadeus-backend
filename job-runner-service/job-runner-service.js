const express = require('express');
const AWS = require('aws-sdk');

// Configure AWS SDK (in production, use IAM role)
AWS.config.update({ region: process.env.AWS_REGION || 'us-west-2' });

const sqs = new AWS.SQS();
const QUEUE_URL = process.env.JOB_QUEUE_URL || 'https://sqs.us-west-2.amazonaws.com/123456789012/job-runner-queue';

const app = express();
app.use(express.json());

// POST /jobs/schedule - enqueue a new job
app.post('/jobs/schedule', async (req, res) => {
  const jobPayload = { type: 'email_digest', timestamp: Date.now() };
  const params = {
    QueueUrl: QUEUE_URL,
    MessageBody: JSON.stringify(jobPayload)
  };
  try {
    const result = await sqs.sendMessage(params).promise();
    res.status(201).json({ messageId: result.MessageId });
  } catch (err) {
    res.status(500).json({ error: 'Failed to schedule job' });
  }
});

// Background worker function to poll SQS
async function pollQueue() {
  const params = {
    QueueUrl: QUEUE_URL,
    MaxNumberOfMessages: 5,
    WaitTimeSeconds: 10
  };
  try {
    const data = await sqs.receiveMessage(params).promise();
    if (data.Messages) {
      for (let msg of data.Messages) {
        console.log('Processing job:', msg.Body);
        // Dummy task: "send email digest"
        console.log('Sending email digest to users...');
        // After processing, delete the message
        await sqs.deleteMessage({ 
          QueueUrl: QUEUE_URL, 
          ReceiptHandle: msg.ReceiptHandle 
        }).promise();
      }
    }
  } catch (err) {
    console.error('Error polling queue:', err);
  } finally {
    // Continue polling after a short delay
    setTimeout(pollQueue, 5000);
  }
}

// Start the polling loop
pollQueue();

// Start HTTP server for scheduling endpoint
const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`Job Runner service listening on port ${PORT}`);
});
