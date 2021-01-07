"
A QLearningTest is a test class for testing the behavior of QLearning
"
Class {
	#name : #QLearningTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
QLearningTest >> newQLearning [
	^ QLearning new
]

{ #category : #test }
QLearningTest >> testAction [
	| c |
	c := self newQLearning.
	self assert: c action isNil.
	c action: 123.
	self assert: c action equals: 123
]

{ #category : #test }
QLearningTest >> testActionFor [
	| c a |
	c := self newQLearning.
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
	c := self newQLearning.
	self assert: c bins isNil.
	c bins: #(1 2 3 4).
	self assertCollection: c bins equals: #(1 2 3 4)
]

{ #category : #test }
QLearningTest >> testBinsMinMaxNum [
	| c r |
	c := self newQLearning.
	r := c binsMin: 1 max: 5 num: 4.
	self assertCollection: r array equals: #(2 3 4) asFloatArray
]

{ #category : #test }
QLearningTest >> testDigitize [
	| c |
	c := self newQLearning.
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
QLearningTest >> testEpisode [
	| c |
	c := self newQLearning.
	self assert: c episode equals: 1.
	c episode: 123.
	self assert: c episode equals: 123
]

{ #category : #test }
QLearningTest >> testLast100 [
	| c |
	c := self newQLearning.
	self assert: c last100 isCollection.
	self assert: c last100 isEmpty.
	c last100: #(1 2 3 4).
	self assertCollection: c last100 equals: #(1 2 3 4)
]

{ #category : #test }
QLearningTest >> testQTable [
	| c a |
	c := self newQLearning.
	self assert: c qTable isNil.
	a := NDArray fromArray: #(1 2 3 4).
	c qTable: a.
	self assert: c qTable identicalTo: a
]

{ #category : #test }
QLearningTest >> testQValueAtStateAction [
	| c a |
	c := self newQLearning.
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
	c := self newQLearning.
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
	c := self newQLearning.
	self assert: c state isNil.
	c state: 123.
	self assert: c state equals: 123
]

{ #category : #test }
QLearningTest >> testSteps [
	| c |
	c := self newQLearning.
	self assert: c steps equals: 0.
	c steps: 123.
	self assert: c steps equals: 123
]

{ #category : #test }
QLearningTest >> testTotal [
	| c |
	c := self newQLearning.
	self assert: c total isCollection.
	self assert: c total isEmpty.
	c total: #(1 2 3 4).
	self assertCollection: c total equals: #(1 2 3 4)
]
