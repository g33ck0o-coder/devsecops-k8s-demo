#!/bin/bash

PORT=$(kubectl -n default get svc $(serviceName) -o json | jq .spec.ports[].nodePort)

# first run this
chmod 777 $(pwd)
echo $(id -u):$(id -g)
docker run -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-weekly zap-api-scan.py -t localhost:$PORT/v3/api-docs -f openapi -r zap_report.html

#HTML Report
sudo mkdir -o owasp-zap-report
sudo mv zap_report.html owasp-zap-report

exit_code=$?

echo "Exit Code : $exit_code"

if [[ ${exit_code} -ne 0 ]]; then
	echo "OWASP ZAP Report has either Low/Medium/High Risk. Please check HTML Report"
	exit 1;
else
	echo "OWASP ZAP did not report any Risk"
fi;