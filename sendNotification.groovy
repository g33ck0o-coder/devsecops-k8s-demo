def call(String buildStatus = 'STARTED') {
 buildStatus = buildStatus ?: 'SUCCESS'

 def color

 if (buildStatus == 'SUCCESS') {
 	color = '#47EC05'
 	emoji = ':ww:'
 } else if (buildStatus == 'UNSTABLE') {
 	color = '#D5EE0D'
 	emoji: ':deadpool:'
 } else	{
 	color = '#EC2805'
 	emoji = ':hulk:'
 }

// def msg = "${buildStatus}: `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n{env.BUILD_URL}"

attachments = [
[
    "color": color,
	"blocks": [
		[
			"type": "header",
			"text": [
				"type": "plain_text",
				"text": "Deployment - ${deploymentName} Pipeline ${env.emoji}",
				"emoji": true
				]
			],
			[
			  "type": "section",
			  "fields": [
                [
                  "type": "mrkdwn",
                  "text": "Job Name:*\n${env.JOB_NAME}"
                ],
                [
                  "type": "mrkdwn",
                  "text": "Build Number:*\n${env.BUILD_NUMBER}"
                ]
			  ],
			"accessory": [
				"type": "image",
				"image_url": "https://raw.githubusercontent.com/sidd-harth/numeric/main/images/jenkins-slack.png",
				"alt_text": "Slack Icon"
				]
			],
			[
			
				"type": "section",
				"text": [
					"type": "mrkdwn",
					"text": "Failed Stage Name: * '${env.failedStage}'"
				],
			  "accessory": [
					"type": "button",
					"text": [
					  "type": "plain_text",
					  "text": "Jenkins Build URL",
					  "emoji": true
					],
					"value": "click_me_123",
					"url": "${env.BUILD_URL}",
					"action_id": "button-action"
					]
				],
				[
				"type": "divider"
				],
				[
					"type": "section",
					"fields": [ 
						[
							"type": "mrkdwn",
							"text": "*Kubernetes Deployment Name:*\n${deploymentName}"
						],
						[
							"type": "mrkdwn",
							"text": "*Node Port*\n32564"
						]
					],
					"accessory": [
						"type": "image",
						"image_url": "https://raw.githubusercontent.com/sidd-harth/numeric/main/images/k8s-slack.png",
						"alt_text": "Kubernetes Icon"
					],
				],
			]
		]

slackSend(iconEmoji: emoji, attachments: attachments)

}
