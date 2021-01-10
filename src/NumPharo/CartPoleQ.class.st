Class {
	#name : #CartPoleQ,
	#superclass : #QLearning,
	#traits : 'TCartPole',
	#classTraits : 'TCartPole classTrait',
	#category : #'NumPharo-Gym'
}

{ #category : #examples }
CartPoleQ class >> example1 [
	| s r |
	s := LearningService new engine: CartPoleQ new.
	s start.
	[ r := ZnEasy
		post: 'http://127.0.0.1:5001/new'
		data: (ZnEntity json: '{"actions":2,"observations":4}').
	Transcript
		show: r contents;
		cr.
	r := ZnEasy
		post: 'http://127.0.0.1:5001/action'
		data: (ZnEntity json: '{"reward":1,"done":false,"observation":[-1,-2,0,0]}').
	Transcript
		show: r contents;
		cr.
	r := ZnEasy
		post: 'http://127.0.0.1:5001/action'
		data: (ZnEntity json: '{"reward":1,"done":true,"observation":[-1,-2,0,0]}').
	Transcript
		show: r contents;
		cr ]
		ensure: [ s stop ]
]

{ #category : #constants }
CartPoleQ >> alpha [
	^ 0.2
]

{ #category : #constants }
CartPoleQ >> gamma [
	^ 0.99
]

{ #category : #private }
CartPoleQ >> nextFromObservation: anArray [
	| nextState epsilon nextAction |
	nextState := self digitize: anArray.
	epsilon := 0.5 * (0.99 ** episode).
	nextAction := (epsilon <= (NDArray randomUniformFrom: 0 to: 1))
		ifTrue: [ self actionFor: nextState ]
		ifFalse: [ self defaultAction ].
	^ Array with: nextState with: nextAction
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
