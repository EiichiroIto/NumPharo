Class {
	#name : #CartPoleQ,
	#superclass : #Object,
	#instVars : [
		'bins',
		'qTable',
		'state',
		'action',
		'episode',
		'steps',
		'total',
		'last100'
	],
	#category : #'NumPharo-Gym'
}

{ #category : #accessing }
CartPoleQ >> action [
	^ action
]

{ #category : #accessing }
CartPoleQ >> action: anObject [
	action := anObject
]

{ #category : #private }
CartPoleQ >> actionFor: anInteger [
	^ (self qTable at: anInteger) argMax
]

{ #category : #constants }
CartPoleQ >> alpha [
	^ 0.2
]

{ #category : #accessing }
CartPoleQ >> bins [
	^ bins
]

{ #category : #accessing }
CartPoleQ >> bins: anObject [
	bins := anObject
]

{ #category : #private }
CartPoleQ >> binsMin: aFloat max: aFloat2 num: anInteger [
	| a |
	a := NDArray
		linspaceFrom: aFloat
		to: aFloat2
		num: anInteger + 1
		withEndPoint: true.
	^ a omitBefore: 1 after: 1
]

{ #category : #private }
CartPoleQ >> changeEpisode [
	self total add: self steps.
	self last100 add: self steps.
	self last100 size > 100
		ifTrue: [ self last100 removeFirst ].
	Transcript
		show: 'episode=';
		show: self episode;
		show: ' steps=';
		show: self steps;
		show: ' average=';
		show: self last100 average asFloat;
		cr.
	self steps: 0.
	self episode: self episode + 1
]

{ #category : #private }
CartPoleQ >> defaultAction [
	^ self numActions atRandom
]

{ #category : #private }
CartPoleQ >> digitize: anArray [
	| a |
	a := anArray
		collectWithIndex:
			[ :each :index | each digitize: (self bins at: index) right: false ].
	a := a
		collectWithIndex: [ :each :index | anArray size ** (index - 1) * (each - 1) ].
	^ a sum + 1
]

{ #category : #accessing }
CartPoleQ >> episode [
	^ episode
]

{ #category : #accessing }
CartPoleQ >> episode: anObject [
	episode := anObject
]

{ #category : #constants }
CartPoleQ >> gamma [
	^ 0.99
]

{ #category : #initialization }
CartPoleQ >> initialize [
	self episode: 1.
	self steps: 0.
	self total: OrderedCollection new.
	self last100: OrderedCollection new.
	self setupBins.
	self setupQTable
]

{ #category : #accessing }
CartPoleQ >> last100 [
	^ last100
]

{ #category : #accessing }
CartPoleQ >> last100: anObject [
	last100 := anObject
]

{ #category : #constants }
CartPoleQ >> maxNumberOfSteps [
	^ 200
]

{ #category : #private }
CartPoleQ >> nextFromObservation: anArray [
	| nextState epsilon nextAction |
	nextState := self digitize: anArray.
	epsilon := 0.5 * (0.99 ** self episode).
	nextAction := (epsilon <= (NDArray randomUniformFrom: 0 to: 1))
		ifTrue: [ self actionFor: nextState ]
		ifFalse: [ (1 to: 2) atRandom ].
	^ Array with: nextState with: nextAction
]

{ #category : #constants }
CartPoleQ >> numActions [
	^ 2
]

{ #category : #constants }
CartPoleQ >> numObservations [
	^ 4
]

{ #category : #accessing }
CartPoleQ >> qTable [
	^ qTable
]

{ #category : #accessing }
CartPoleQ >> qTable: anObject [
	qTable := anObject
]

{ #category : #private }
CartPoleQ >> qValueAtState: anInteger action: anInteger2 [
	^ self qTable
		at:
			{anInteger.
			anInteger2}
]

{ #category : #private }
CartPoleQ >> qValueAtState: anInteger action: anInteger2 put: aFloat3 [
	self qTable
		at:
			{anInteger.
			anInteger2}
		put: aFloat3
]

{ #category : #private }
CartPoleQ >> setupBins [
	self
		bins:
			(#(#(-2.4 2.4 4) #(-3.0 3.0 4) #(-0.5 0.5 4) #(-2.0 2.0 4))
				collect: [ :each | self binsMin: each first max: each second num: each third ])
]

{ #category : #private }
CartPoleQ >> setupQTable [
	| size |
	size := Array
		with: self numObservations ** self numObservations
		with: self numActions.
	self qTable: (NDArray randomUniform: size from: -1 to: 1)
]

{ #category : #accessing }
CartPoleQ >> state [
	^ state
]

{ #category : #accessing }
CartPoleQ >> state: anObject [
	state := anObject
]

{ #category : #accessing }
CartPoleQ >> steps [
	^ steps
]

{ #category : #accessing }
CartPoleQ >> steps: anObject [
	steps := anObject
]

{ #category : #accessing }
CartPoleQ >> total [
	^ total
]

{ #category : #accessing }
CartPoleQ >> total: anObject [
	total := anObject
]

{ #category : #api }
CartPoleQ >> update: anArray reward: anInteger done: aBoolean [
	| reward pair v1 v2 |
	pair := self nextFromObservation: anArray.
	reward := aBoolean
		ifTrue: [ anInteger - 200 ]
		ifFalse: [ anInteger ].
	(self state notNil and: [ self action notNil ])
		ifTrue: [ v1 := (1 - self alpha)
				* (self qValueAtState: self state action: self action).
			v2 := self alpha
				*
					(self gamma * (self qValueAtState: pair first action: pair second)
						+ reward).
			self qValueAtState: self state action: self action put: v1 + v2 ].
	self state: pair first.
	self action: pair second.
	self steps: self steps + 1.
	aBoolean
		ifTrue: [ self changeEpisode ].
	^ self action - 1
]
