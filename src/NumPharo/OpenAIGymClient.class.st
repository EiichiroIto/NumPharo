"
OpenAI Gym http client.

It uses https://github.com/openai/gym-http-api server.

run 'python gym_http_server.py' in terminal sesson before use.

see example at class side.

"
Class {
	#name : #OpenAIGymClient,
	#superclass : #Object,
	#instVars : [
		'address',
		'instanceId',
		'response',
		'done'
	],
	#category : #'NumPharo-Gym'
}

{ #category : #examples }
OpenAIGymClient class >> example1 [
	| gym |
	gym := self new address: 'http://127.0.0.1:5000'.
	gym createEnv: 'CartPole-v0'.
	gym startMonitorForce: true resume: false videoCallable: false.
	gym reset.
	[ gym done ]
		whileFalse: [ gym step: gym getActionSpaceSample render: true.
			100 milliSecond wait ].
	gym close
]

{ #category : #accessing }
OpenAIGymClient >> address [
	^ address
]

{ #category : #accessing }
OpenAIGymClient >> address: anObject [
	address := anObject
]

{ #category : #api }
OpenAIGymClient >> close [
	| url |
	url := self address , '/v1/envs/' , self instanceId  , '/close/'.
	self post: url text: ''
]

{ #category : #api }
OpenAIGymClient >> closeMonitor [
	| url |
	url := self address , '/v1/envs/' , self instanceId  , '/monitor/close/'.
	^ self get: url
]

{ #category : #api }
OpenAIGymClient >> createEnv: aString [
	| url raw |
	url := self address , '/v1/envs/'.
	raw := { 'env_id' -> aString } asDictionary.
	self post: url json: (STON toJsonString: raw).
	self instanceId: (self responseData at: 'instance_id')
]

{ #category : #accessing }
OpenAIGymClient >> done [
	^ done ifNil: [ false ]
]

{ #category : #accessing }
OpenAIGymClient >> done: aBoolean [
	done := aBoolean
]

{ #category : #private }
OpenAIGymClient >> get: aString [
	self response: (ZnEasy get: aString)
]

{ #category : #api }
OpenAIGymClient >> getActionSpaceInfo [
	| url |
	url := self address , '/v1/envs/' , self instanceId , '/action_space/'.
	self get: url.
	^ self responseData at: 'info'
]

{ #category : #api }
OpenAIGymClient >> getActionSpaceSample [
	| url |
	url := self address , '/v1/envs/' , self instanceId , '/action_space/sample'.
	self get: url.
	^ self responseData at: 'action'
]

{ #category : #accessing }
OpenAIGymClient >> instanceId [
	^ instanceId
]

{ #category : #accessing }
OpenAIGymClient >> instanceId: aString [
	instanceId := aString
]

{ #category : #private }
OpenAIGymClient >> post: aString json: aString2 [
	self response: (ZnEasy post: aString data: (ZnEntity json: aString2))
]

{ #category : #private }
OpenAIGymClient >> post: aString text: aString2 [
	self response: (ZnEasy post: aString data: (ZnEntity text: aString2))
]

{ #category : #api }
OpenAIGymClient >> reset [
	| url |
	url := self address , '/v1/envs/' , self instanceId  , '/reset/'.
	self post: url text: ''.
	^ self responseData at: 'observation'
]

{ #category : #accessing }
OpenAIGymClient >> response [
	^ response
]

{ #category : #accessing }
OpenAIGymClient >> response: aResponse [
	response := aResponse
]

{ #category : #private }
OpenAIGymClient >> responseData [
	^ 	STON fromString: self response entity string
]

{ #category : #api }
OpenAIGymClient >> shutdown [
	| url |
	url := self address , '/v1/shutdown/'.
	self post: url text: ''
]

{ #category : #api }
OpenAIGymClient >> startMonitorForce: aBoolean1 resume: aBoolean2 videoCallable: aBoolean3 [
	| url raw |
	url := self address , '/v1/envs/' , self instanceId , '/monitor/start/'.
	raw := {('directory' -> ('/tmp/' , self instanceId)).
	('force' -> aBoolean1).
	('resume' -> aBoolean2).
	('video_callable' -> aBoolean3)} asDictionary.
	self post: url json: (STON toJsonString: raw)
]

{ #category : #api }
OpenAIGymClient >> step: anObject render: aBoolean2 [
	| url raw dict observation reward info |
	self done
		ifTrue: [ self error: 'cannot step, already done' ].
	url := self address , '/v1/envs/' , self instanceId , '/step/'.
	raw := {('action' -> anObject).
	('render' -> aBoolean2)} asDictionary.
	self post: url json: (STON toJsonString: raw).
	dict := self responseData.
	observation := dict at: 'observation'.
	reward := dict at: 'reward'.
	self done: (dict at: 'done').
	info := dict at: 'info'.
	^ Array
		with: observation
		with: reward
		with: done
		with: info
]
