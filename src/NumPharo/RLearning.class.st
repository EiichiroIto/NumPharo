Class {
	#name : #RLearning,
	#superclass : #Object,
	#instVars : [
		'episode',
		'steps',
		'total',
		'recents',
		'numRecents'
	],
	#category : #'NumPharo-Gym'
}

{ #category : #private }
RLearning >> addSteps [
	total add: steps.
	recents add: steps.
	recents size > self numRecents
		ifTrue: [ recents removeFirst ]
]

{ #category : #private }
RLearning >> defaultAction [
	^ self numActions atRandom
]

{ #category : #constants }
RLearning >> defaultNumRecents [
	^ 100
]

{ #category : #accessing }
RLearning >> episode [
	^ episode
]

{ #category : #accessing }
RLearning >> episode: anObject [
	episode := anObject
]

{ #category : #initialization }
RLearning >> initialize [
	episode := 1.
	steps := 0.
	total := OrderedCollection new.
	recents := OrderedCollection new
]

{ #category : #constants }
RLearning >> maxNumberOfSteps [
	^ self subclassResponsibility
]

{ #category : #constants }
RLearning >> numActions [
	self subclassResponsibility
]

{ #category : #constants }
RLearning >> numObservations [
	self subclassResponsibility
]

{ #category : #accessing }
RLearning >> numRecents [
	^ numRecents ifNil: [ self defaultNumRecents ]
]

{ #category : #accessing }
RLearning >> numRecents: anInteger [
	numRecents := anInteger
]

{ #category : #accessing }
RLearning >> recents [
	^ recents
]

{ #category : #accessing }
RLearning >> recents: anObject [
	recents := anObject
]

{ #category : #api }
RLearning >> saveSTONFileNamed: aString [
	| filename |
	filename := (aString endsWith: '.ston')
		ifTrue: [ aString ]
		ifFalse: [ aString , '.ston' ].
	FileSystem workingDirectory / filename
		writeStreamDo: [ :stream | stream nextPutAll: (STON toString: self) ]
]

{ #category : #api }
RLearning >> saveStepsFileNamed: aString [
	| form filename |
	filename := (aString endsWith: '.ston')
		ifTrue: [ aString ]
		ifFalse: [ aString , '.ston' ].
	form := PharoPlot new
		extent: self total @ self maxNumberOfSteps;
		plot: self total asNDArray label: self class name;
		buildForm.
	PNGReadWriter putForm: form onFileNamed: filename
]

{ #category : #accessing }
RLearning >> steps [
	^ steps
]

{ #category : #accessing }
RLearning >> steps: anObject [
	steps := anObject
]

{ #category : #accessing }
RLearning >> total [
	^ total
]

{ #category : #accessing }
RLearning >> total: anObject [
	total := anObject
]

{ #category : #api }
RLearning >> update: anArray reward: anInteger done: aBoolean [
	self subclassResponsibility
]
