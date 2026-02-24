curl -s https://www.ai-fitness.de/connect/v1/studio/1288400590/utilization | jq '.items[] | select(.isCurrent == true) | .percentage'
