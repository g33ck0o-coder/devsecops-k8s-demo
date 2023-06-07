#!/bin/bash

#integration-test.sh

sleep 5s

PORT=$(kubectl -n default get svc ${serviceName} -o json | jq .spec.ports[].nodePort)

echo $PORT
echo localhost:$PORT$applicationURI

if [[ ! -z "$PORT" ]];
then
	response=$(curl -s localhost:$PORT$applicationURI)
	http_code=$(curl -s -o /dev/null -w "%{http_code}" localhost:$PORT$applicationURI)

	if [[ "$response" == 100 ]];
	then
		echo "Increment Test Pased"
	else
		echo "Increment Test Failed"
		exit 1;
	fi;

	if [[ "http_code" == 200 ]];
	then
		echo "HTTP Status Code Test Passed"
	else
		echo "HTTP Status Code is not 200"
		exit 1;
	fi;

else
	echo "The service doesn't have a NodePort value"
	exit 1;
fi;