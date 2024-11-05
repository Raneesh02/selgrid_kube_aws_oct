#!/bin/bash

# Ensure a URL is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <selenium-grid-url>"
  exit 1
fi

echo "Check for selenium hub status!"

SELENIUM_URL=$1
RETRY_INTERVAL=5
TIMEOUT=120
START_TIME=$(date +%s)

while true; do
  echo "http://$SELENIUM_URL:4444/wd/hub/status"
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://$SELENIUM_URL:4444/wd/hub/status")
  echo "Status $STATUS"

  if [ "$STATUS" -eq 200 ]; then
    echo "Selenium Hub is ready!"
    exit 0
  fi

  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
    echo "Timed out waiting for Selenium Hub to be ready."
    exit 1
  fi

  echo "Selenium Hub not ready yet. Retrying in $RETRY_INTERVAL seconds..."
  sleep $RETRY_INTERVAL
done