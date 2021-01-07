Class {
	#name : #QLearning,
	#superclass : #Object,
	#instVars : [
		'qTable',
		'action',
		'total',
		'bins',
		'episode',
		'last100',
		'state',
		'steps'
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
QLearning >> digitize: anArray [
	| a |
	a := anArray
		collectWithIndex:
			[ :each :index | each digitize: (bins at: index) right: false ].
	a := a
		collectWithIndex: [ :each :index | anArray size ** (index - 1) * (each - 1) ].
	^ a sum + 1
]

{ #category : #accessing }
QLearning >> episode [
	^ episode
]

{ #category : #accessing }
QLearning >> episode: anObject [
	episode := anObject
]

{ #category : #initialization }
QLearning >> initialize [
	episode := 1.
	steps := 0.
	total := OrderedCollection new.
	last100 := OrderedCollection new.
	self setupBins.
	self setupQTable
]

{ #category : #accessing }
QLearning >> last100 [
	^ last100
]

{ #category : #accessing }
QLearning >> last100: anObject [
	last100 := anObject
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

{ #category : #accessing }
QLearning >> state [
	^ state
]

{ #category : #accessing }
QLearning >> state: anObject [
	state := anObject
]

{ #category : #accessing }
QLearning >> steps [
	^ steps
]

{ #category : #accessing }
QLearning >> steps: anObject [
	steps := anObject
]

{ #category : #accessing }
QLearning >> total [
	^ total
]

{ #category : #accessing }
QLearning >> total: anObject [
	total := anObject
]

{ #category : #api }
QLearning >> update: anArray reward: anInteger done: aBoolean [
	self subclassResponsibility
]
