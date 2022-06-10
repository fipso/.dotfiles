#!/bin/bash
while true; do
	a=$(date | tr -d '\n');
	b=$(jq '[.data[] | "\(.symbol) \(.quote.EUR.price | floor)€"] | join(" ")' /tmp/coins.txt | tr -d '"')
	echo 🕑 $a 💰 $b
	sleep 1
done
