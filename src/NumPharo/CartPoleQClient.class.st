Class {
	#name : #CartPoleQClient,
	#superclass : #Object,
	#instVars : [
		'bins',
		'qTable',
		'gym'
	],
	#category : #'NumPharo-Gym'
}

{ #category : #private }
CartPoleQClient class >> createGym [
	| gym |
	gym := OpenAIGymClient new address: 'http://127.0.0.1:5000'.
	gym createEnv: 'CartPole-v0'.
	gym startMonitorForce: true resume: false videoCallable: false.
	^ gym
]

{ #category : #examples }
CartPoleQClient class >> example1 [
	| c total p x y |
	c := self new.
	c setupBins.
	c setupQTable.
	c gym: self createGym.
	total := c training: 2000 render: false.
	c gym close.
	p := PharoPlot new.
	p extent: 1000 @ 200.
	y := NDArray fromArray: total.
	x := NDArray arangeFrom: 1 to: y size by: 1.
	p plotX: x y: y label: ''.
	p show.
	^ c
]

{ #category : #private }
CartPoleQClient >> actionFor: anInteger [
	^ (self qTable at: anInteger) argMax
]

{ #category : #constants }
CartPoleQClient >> alpha [
	^ 0.2
]

{ #category : #accessing }
CartPoleQClient >> bins [
	^ bins
]

{ #category : #accessing }
CartPoleQClient >> bins: anArray [
	bins := anArray
]

{ #category : #private }
CartPoleQClient >> binsMin: aFloat max: aFloat2 num: anInteger [
	| a |
	a := NDArray
		linspaceFrom: aFloat
		to: aFloat2
		num: anInteger + 1
		withEndPoint: true.
	^ a omitBefore: 1 after: 1
]

{ #category : #private }
CartPoleQClient >> digitize: anArray [
	| a |
	a := anArray
		collectWithIndex:
			[ :each :index | each digitize: (self bins at: index) right: false ].
	a := a
		collectWithIndex: [ :each :index | anArray size ** (index - 1) * (each - 1) ].
	^ a sum + 1
]

{ #category : #api }
CartPoleQClient >> executeRender: aBoolean [
	| observation state action count |
	observation := self gym reset.
	state := self digitize: observation.
	action := self actionFor: state.
	count := 0.
	[ self gym done ]
		whileFalse: [ | ret |
			self gym step: action - 1 render: aBoolean.
			ret := self nextFromObservation: self gym observation episode: 1000.
			state := ret first.
			action := ret second.
			count := count + 1 ].
	^ count
]

{ #category : #constants }
CartPoleQClient >> gamma [
	^ 0.99
]

{ #category : #accessing }
CartPoleQClient >> gym [
	^ gym
]

{ #category : #accessing }
CartPoleQClient >> gym: aGym [
	gym := aGym
]

{ #category : #constants }
CartPoleQClient >> maxNumberOfSteps [
	^ 200
]

{ #category : #private }
CartPoleQClient >> nextFromObservation: anArray episode: anInteger2 [
	| nextState epsilon nextAction |
	nextState := self digitize: anArray.
	epsilon := 0.5 * (0.99 ** anInteger2).
	nextAction := (epsilon <= (NDArray randomUniformFrom: 0 to: 1))
		ifTrue: [ self actionFor: nextState ]
		ifFalse: [ (1 to: 2) atRandom ].
	^ Array with: nextState with: nextAction
]

{ #category : #constants }
CartPoleQClient >> numActions [
	^ 2
]

{ #category : #constants }
CartPoleQClient >> numObservations [
	^ 4
]

{ #category : #accessing }
CartPoleQClient >> qTable [
	^ qTable
]

{ #category : #accessing }
CartPoleQClient >> qTable: aNDArray [
	qTable := aNDArray
]

{ #category : #private }
CartPoleQClient >> qValueAtState: anInteger action: anInteger2 [
	^ self qTable
		at:
			{anInteger.
			anInteger2}
]

{ #category : #private }
CartPoleQClient >> qValueAtState: anInteger action: anInteger2 put: aFloat3 [
	self qTable
		at:
			{anInteger.
			anInteger2}
		put: aFloat3
]

{ #category : #private }
CartPoleQClient >> setupBins [
	bins := #(#(-2.4 2.4 4) #(-3.0 3.0 4) #(-0.5 0.5 4) #(-2.0 2.0 4))
		collect:
			[ :each | self binsMin: each first max: each second num: each third ]
]

{ #category : #private }
CartPoleQClient >> setupQTable [
	| size |
	size := Array
		with: self numObservations ** self numObservations
		with: self numActions.
	qTable := NDArray randomUniform: size from: -1 to: 1
]

{ #category : #api }
CartPoleQClient >> training: anInteger render: aBoolean2 [
	| last100 r total |
	last100 := OrderedCollection new.
	total := OrderedCollection new.
	0 to: anInteger do: [ :each | 
		r := self trainingEpisode: each render: aBoolean2.
		total add: r.
		last100 add: r.
		last100 size > 100
			ifTrue: [ last100 removeFirst ].
		last100 average >= 200
			ifTrue: [ ^ total asArray ] ].
	^ total asArray
]

{ #category : #private }
CartPoleQClient >> trainingEpisode: anInteger render: aBoolean2 [
	| observation state action |
	observation := self gym reset.
	state := self digitize: observation.
	action := self actionFor: state.
	1 to: self maxNumberOfSteps do: [ :each | 
		| reward ret v1 v2 |
		self gym step: action - 1 render: aBoolean2.
		reward := self gym reward.
		self gym done
			ifTrue: [ reward := reward - 200 ].
		ret := self
			nextFromObservation: self gym observation
			episode: anInteger.
		v1 := (1 - self alpha) * (self qValueAtState: state action: action).
		v2 := self alpha
			*
				(self gamma * (self qValueAtState: ret first action: ret second)
					+ reward).
		self qValueAtState: state action: action put: v1 + v2.
		state := ret first.
		action := ret second.
		self gym done
			ifTrue: [ ^ each ] ].
	^ self maxNumberOfSteps + 1
]
