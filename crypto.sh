#!/bin/bash

APP_TOKEN="agtmisyf7suzacm88eqy1yva8g1xmh"
USER_TOKEN="ubxxhh1jgxpyi1x1ah8og2bsivt6sx"

CRYPTOS=(
	"ETH"
	"BTC"
	"XRP"
)

BUYPRICES=(
	"700"
	"28000"
	"0.18"
)

function notify {
	wget https://api.pushover.net/1/messages.json --post-data="token=$APP_TOKEN&user=$USER_TOKEN&message=$MESSAGE&title=$TITLE" -qO- > /dev/null 2>&1 &
}

for x in ${!CRYPTOS[@]};
do
	CRYPTO=${CRYPTOS[$x]}
	BUYPRICE=${BUYPRICES[$x]}
	CURRENTPRICE=$(curl -s https://api.coinbase.com/v2/prices/$CRYPTO-EUR/buy | jq -r '.[] | .amount')

	if [ $(bc <<< "$BUYPRICE >= $CURRENTPRICE") -eq 1 ]
		then 
			TITLE="$CRYPTO under buy price"
			MESSAGE="$CRYPTO current price: € $CURRENTPRICE"
			notify
	fi
done

