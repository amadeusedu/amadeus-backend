import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
  vus: 500,              // virtual users to match 500 RPS roughly (1 req per vu per sec)
  duration: '15m',
  thresholds: {
    http_req_failed: ['rate<0.01'],   // <1% errors
    http_req_duration: ['p(95)<500'], // 95% under 500 ms
  },
};

export default function () {
  http.get(__ENV.TEST_URL);
  sleep(1);
}
