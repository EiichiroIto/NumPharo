Class {
	#name : #CartPoleQ,
	#superclass : #QLearning,
	#category : #'NumPharo-Gym'
}

{ #category : #constants }
CartPoleQ >> alpha [
	^ 0.2
]

{ #category : #private }
CartPoleQ >> changeEpisode [
	total add: steps.
	last100 add: steps.
	last100 size > 100
		ifTrue: [ last100 removeFirst ].
	Transcript
		show: 'episode=';
		show: episode;
		show: ' steps=';
		show: steps;
		show: ' average=';
		show: last100 average asFloat;
		cr.
	steps := 0.
	episode := episode + 1
]

{ #category : #private }
CartPoleQ >> defaultAction [
	^ self numActions atRandom
]

{ #category : #constants }
CartPoleQ >> gamma [
	^ 0.99
]

{ #category : #constants }
CartPoleQ >> maxNumberOfSteps [
	^ 200
]

{ #category : #private }
CartPoleQ >> nextFromObservation: anArray [
	| nextState epsilon nextAction |
	nextState := self digitize: anArray.
	epsilon := 0.5 * (0.99 ** episode).
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

{ #category : #private }
CartPoleQ >> setupBins [
	bins :=
			(#(#(-2.4 2.4 4) #(-3.0 3.0 4) #(-0.5 0.5 4) #(-2.0 2.0 4))
				collect: [ :each | self binsMin: each first max: each second num: each third ])
]

{ #category : #private }
CartPoleQ >> setupQTable [
	| size |
	size := Array
		with: self numObservations ** self numObservations
		with: self numActions.
	qTable := (NDArray randomUniform: size from: -1 to: 1)
]

{ #category : #api }
CartPoleQ >> update: anArray reward: anInteger done: aBoolean [
	| reward pair v1 v2 |
	pair := self nextFromObservation: anArray.
	reward := aBoolean
		ifTrue: [ anInteger - 200 ]
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
	^ action - 1
]
