Class {
	#name : #LearningService,
	#superclass : #Object,
	#instVars : [
		'server',
		'port',
		'engine'
	],
	#category : #'NumPharo-Gym'
}

{ #category : #constants }
LearningService >> defaultPort [
	^ 5001
]

{ #category : #accessing }
LearningService >> engine [
	^ engine
]

{ #category : #accessing }
LearningService >> engine: anObject [
	engine := anObject
]

{ #category : #private }
LearningService >> getActionFrom: aDictionary [
	| observation reward done |
	observation := aDictionary
		at: 'observation'
		ifAbsent: [ ^ self engine defaultAction ].
	reward := aDictionary
		at: 'reward'
		ifAbsent: [ ^ self engine defaultAction ].
	done := aDictionary
		at: 'done'
		ifAbsent: [ ^ self engine defaultAction ].
	^ (engine update: observation reward: reward done: done) - 1
]

{ #category : #'request handling' }
LearningService >> handleGetActionRequest: aRequest [
	| dict ret |
	dict := STON fromString: aRequest entity string.
	ret := self getActionFrom: dict.
	^ ZnResponse ok: (ZnEntity json: (STON toString: ret))
]

{ #category : #'request handling' }
LearningService >> handleNewRequest: aRequest [
	| dict ret |
	dict := STON fromString: aRequest entity string.
	ret := self setupFrom: dict.
	^ ZnResponse ok: (ZnEntity json: (STON toString: ret))
]

{ #category : #'request handling' }
LearningService >> handleRequest: request [
	request uri firstPathSegment = #new
		ifTrue: [ (request method = #POST
				and: [ request hasEntity and: [ request contentType isBinary not ] ])
				ifTrue: [ ^ self handleNewRequest: request ] ].
	request uri firstPathSegment = #action
		ifTrue: [ (request method = #POST
				and: [ request hasEntity and: [ request contentType isBinary not ] ])
				ifTrue: [ ^ self handleGetActionRequest: request ] ].
	^ ZnResponse notFound: request uri
]

{ #category : #testing }
LearningService >> isRunning [
	^ self server notNil and: [ self server isRunning ]
]

{ #category : #accessing }
LearningService >> port [
	^ port ifNil: [ port := self defaultPort ]
]

{ #category : #accessing }
LearningService >> port: anObject [
	port := anObject
]

{ #category : #printing }
LearningService >> printOn: aStream [
	self isRunning
		ifTrue: [ aStream nextPut: $* ].
	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: self port asString;
		nextPut: $)
]

{ #category : #accessing }
LearningService >> server [
	^ server
]

{ #category : #accessing }
LearningService >> server: anObject [
	server := anObject
]

{ #category : #private }
LearningService >> setupFrom: aDictionary [
	| observations actions |
	observations := aDictionary
		at: 'observations'
		ifAbsent: [ Transcript
				show: 'observations not specified';
				cr.
			^ false ].
	actions := aDictionary
		at: 'actions'
		ifAbsent: [ Transcript
				show: 'actions not specified';
				cr.
			^ false ].
	self engine numObservations = observations
		ifFalse: [ Transcript
				show: 'invalid numObservations';
				cr.
			^ false ].
	self engine numActions = actions
		ifFalse: [ Transcript
				show: 'invalid numActions';
				cr.
			^ false ].
	^ true
]

{ #category : #api }
LearningService >> start [
	| s |
	self isRunning
		ifTrue: [ ^ self ].
	s := ZnServer on: self port.
	s
		delegate: self;
		start.
	(s isRunning "and: [ s isListening ]")
		ifFalse: [ s stop.
			self error: 'cannot start service' ].
	self server: s
]

{ #category : #api }
LearningService >> stop [
	self isRunning
		ifFalse: [ ^ self ].
	self server stop.
	self server: nil
]
