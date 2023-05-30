#!/bin/bash

echo $imageName #getting Image Name from env variable

docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity LOW,MEDIUM,HIGH --light $imageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.40.0 -q image --exit-code 1 --severity CRITICAL --light $imageName

#Trivy scan result processing
exit_code=$?
echo "Exit Code : $exit_code"

#Check Scan Results
if [[ ${exit_code} == 1 ]]; then
	echo "Image Scanning Failed. Vulnerabilities found"
	exit 1;
else
	echo "Image Scanning Passed. No vulnerabilities found"
fi;
