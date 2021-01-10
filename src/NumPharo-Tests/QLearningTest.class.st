"
A QLearningTest is a test class for testing the behavior of QLearning
"
Class {
	#name : #QLearningTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
QLearningTest >> newLearning [
	^ QLearning new
]

{ #category : #test }
QLearningTest >> testAction [
	| c |
	c := self newLearning.
	self assert: c action isNil.
	c action: 123.
	self assert: c action equals: 123
]

{ #category : #test }
QLearningTest >> testActionFor [
	| c a |
	c := self newLearning.
	a := NDArray zeros: #(256 2) dtype: #Integer.
	c qTable: a.
	a at: #(1 1) put: 10.
	a at: #(1 2) put: 20.
	a at: #(2 1) put: 30.
	a at: #(2 2) put: 20.
	self assert: (c actionFor: 1) equals: 2.
	self assert: (c actionFor: 2) equals: 1
]

{ #category : #test }
QLearningTest >> testBins [
	| c |
	c := self newLearning.
	self assert: c bins isNil.
	c bins: #(1 2 3 4).
	self assertCollection: c bins equals: #(1 2 3 4)
]

{ #category : #test }
QLearningTest >> testBinsMinMaxNum [
	| c r |
	c := self newLearning.
	r := c binsMin: 1 max: 5 num: 4.
	self assertCollection: r array equals: #(2 3 4) asFloatArray
]

{ #category : #test }
QLearningTest >> testChangeEpisode [
	| l |
	l := self newLearning.
	l steps: 10.
	l episode: 20.
	l total: #(1 2 3) asOrderedCollection.
	l recents: #(4 5 6) asOrderedCollection.
	l changeEpisode.
	self assert: l steps equals: 0.
	self assert: l episode equals: 21.
	self
		assertCollection: l total
		equals: #(1 2 3 10) asOrderedCollection.
	self
		assertCollection: l recents
		equals: #(4 5 6 10) asOrderedCollection.
	l steps: 123.
	l recents: (Array new: 100 withAll: 99) asOrderedCollection.
	l changeEpisode.
	self assert: l recents last equals: 123.
	1 to: 99 do: [ :each | self assert: (l recents at: each) equals: 99 ]
]

{ #category : #test }
QLearningTest >> testDigitize [
	| c |
	c := self newLearning.
	c
		bins:
			(#(#(-2.4 2.4 4) #(-3.0 3.0 4) #(-0.5 0.5 4) #(-2.0 2.0 4))
				collect: [ :each | c binsMin: each first max: each second num: each third ]).
	self assert: (c digitize: #(-5 -5 -5 -5)) equals: 1.
	self assert: (c digitize: #(5 5 5 5)) equals: 256.
	self assert: (c digitize: #(-5 -1 -5 -5)) equals: 5.
	self assert: (c digitize: #(-5 -5 -0.1 -5)) equals: 17.
	self assert: (c digitize: #(-5 -5 -5 -0.5)) equals: 65
]

{ #category : #test }
QLearningTest >> testQTable [
	| c a |
	c := self newLearning.
	self assert: c qTable isNil.
	a := NDArray fromArray: #(1 2 3 4).
	c qTable: a.
	self assert: c qTable identicalTo: a
]

{ #category : #test }
QLearningTest >> testQValueAtStateAction [
	| c a |
	c := self newLearning.
	a := NDArray zeros: #(256 2) dtype: #Integer.
	c qTable: a.
	a at: #(1 1) put: 10.
	a at: #(1 2) put: 20.
	a at: #(2 1) put: 30.
	a at: #(2 2) put: 20.
	self assert: (c qValueAtState: 1 action: 1) equals: 10.
	self assert: (c qValueAtState: 1 action: 2) equals: 20.
	self assert: (c qValueAtState: 2 action: 1) equals: 30.
	self assert: (c qValueAtState: 2 action: 2) equals: 20
]

{ #category : #test }
QLearningTest >> testQValueAtStateActionPut [
	| c a |
	c := self newLearning.
	a := NDArray zeros: #(256 2) dtype: #Integer.
	c qTable: a.
	c qValueAtState: 1 action: 1 put: 10.
	c qValueAtState: 1 action: 2 put: 20.
	c qValueAtState: 2 action: 1 put: 30.
	c qValueAtState: 2 action: 2 put: 20.
	self assert: (a at: #(1 1)) equals: 10.
	self assert: (a at: #(1 2)) equals: 20.
	self assert: (a at: #(2 1)) equals: 30.
	self assert: (a at: #(2 2)) equals: 20
]

{ #category : #test }
QLearningTest >> testState [
	| c |
	c := self newLearning.
	self assert: c state isNil.
	c state: 123.
	self assert: c state equals: 123
]
