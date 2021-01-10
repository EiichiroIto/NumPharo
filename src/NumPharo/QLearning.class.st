Class {
	#name : #QLearning,
	#superclass : #RLearning,
	#instVars : [
		'qTable',
		'bins',
		'action',
		'state'
	],
	#category : #'NumPharo-Gym'
}

{ #category : #accessing }
QLearning >> action [
	^ action
]

{ #category : #accessing }
QLearning >> action: anObject [
	action := anObject
]

{ #category : #private }
QLearning >> actionFor: anInteger [
	^ (qTable at: anInteger) argMax
]

{ #category : #accessing }
QLearning >> bins [
	^ bins
]

{ #category : #accessing }
QLearning >> bins: anObject [
	bins := anObject
]

{ #category : #private }
QLearning >> binsMin: aFloat max: aFloat2 num: anInteger [
	| a |
	a := NDArray
		linspaceFrom: aFloat
		to: aFloat2
		num: anInteger + 1
		withEndPoint: true.
	^ a omitBefore: 1 after: 1
]

{ #category : #private }
QLearning >> changeEpisode [
	self addSteps.
	self showInfo.
	steps := 0.
	episode := episode + 1
]

{ #category : #private }
QLearning >> digitize: anArray [
	| a |
	a := anArray
		collectWithIndex:
			[ :each :index | each digitize: (bins at: index) right: false ].
	a := a
		collectWithIndex: [ :each :index | anArray size ** (index - 1) * (each - 1) ].
	^ a sum + 1
]

{ #category : #initialization }
QLearning >> initialize [
	super initialize.
	self setupBins.
	self setupQTable
]

{ #category : #accessing }
QLearning >> qTable [
	^ qTable
]

{ #category : #accessing }
QLearning >> qTable: anObject [
	qTable := anObject
]

{ #category : #private }
QLearning >> qValueAtState: anInteger action: anInteger2 [
	^ qTable
		at:
			{anInteger.
			anInteger2}
]

{ #category : #private }
QLearning >> qValueAtState: anInteger action: anInteger2 put: aFloat3 [
	qTable
		at:
			{anInteger.
			anInteger2}
		put: aFloat3
]

{ #category : #private }
QLearning >> setupBins [
	""
]

{ #category : #private }
QLearning >> setupQTable [
	""
]

{ #category : #private }
QLearning >> showInfo [
	Transcript
		show: 'episode=';
		show: episode;
		show: ' steps=';
		show: steps;
		show: ' average=';
		show: recents average asFloat;
		cr
]

{ #category : #accessing }
QLearning >> state [
	^ state
]

{ #category : #accessing }
QLearning >> state: anObject [
	state := anObject
]

{ #category : #api }
QLearning >> update: anArray reward: anInteger done: aBoolean [
	| reward pair v1 v2 |
	pair := self nextFromObservation: anArray.
	reward := aBoolean
		ifTrue: [ anInteger - self maxNumberOfSteps ]
		ifFalse: [ anInteger ].
	(state notNil and: [ action notNil ])
		ifTrue: [ v1 := (1 - self alpha)
				* (self qValueAtState: state action: action).
			v2 := self alpha
				*
					(self gamma * (self qValueAtState: pair first action: pair second)
						+ reward).
			self qValueAtState: state action: action put: v1 + v2 ].
	state := pair first.
	action := pair second.
	steps := steps + 1.
	aBoolean
		ifTrue: [ self changeEpisode ].
	^ action
]
