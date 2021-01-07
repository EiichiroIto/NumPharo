"
A CartPoleQTest is a test class for testing the behavior of CartPoleQ
"
Class {
	#name : #CartPoleQClientTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
CartPoleQClientTest >> newCartPole [
	^ CartPoleQClient new
]

{ #category : #test }
CartPoleQClientTest >> testActionFor [
	| c a |
	c := self newCartPole.
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
CartPoleQClientTest >> testAlpha [
	| c |
	c := self newCartPole.
	self assert: c alpha isFloat
]

{ #category : #test }
CartPoleQClientTest >> testBins [
	| c |
	c := self newCartPole.
	self assert: c bins isNil.
	c bins: #(1 2 3 4).
	self assertCollection: c bins equals: #(1 2 3 4)
]

{ #category : #test }
CartPoleQClientTest >> testBinsMinMaxNum [
	| c r |
	c := self newCartPole.
	r := c binsMin: 1 max: 5 num: 4.
	self assertCollection: r array equals: #(2 3 4) asFloatArray
]

{ #category : #test }
CartPoleQClientTest >> testDigitize [
	| c |
	c := self newCartPole.
	c setupBins.
	self assert: (c digitize: #(-5 -5 -5 -5)) equals: 1.
	self assert: (c digitize: #(5 5 5 5)) equals: 256.
	self assert: (c digitize: #(-5 -1 -5 -5)) equals: 5.
	self assert: (c digitize: #(-5 -5 -0.1 -5)) equals: 17.
	self assert: (c digitize: #(-5 -5 -5 -0.5)) equals: 65
]

{ #category : #test }
CartPoleQClientTest >> testGamma [
	| c |
	c := self newCartPole.
	self assert: c gamma isFloat
]

{ #category : #test }
CartPoleQClientTest >> testGym [
	| c |
	c := self newCartPole.
	self assert: c gym isNil.
	c gym: OpenAIGymClient new.
	self assert: (c gym isKindOf: OpenAIGymClient)
]

{ #category : #test }
CartPoleQClientTest >> testMaxNumberOfSteps [
	| c |
	c := self newCartPole.
	self assert: c maxNumberOfSteps isInteger
]

{ #category : #test }
CartPoleQClientTest >> testNumActions [
	| c |
	c := self newCartPole.
	self assert: c numActions isInteger
]

{ #category : #test }
CartPoleQClientTest >> testNumObservations [
	| c |
	c := self newCartPole.
	self assert: c numObservations isInteger
]

{ #category : #test }
CartPoleQClientTest >> testQTable [
	| c a |
	c := self newCartPole.
	self assert: c qTable isNil.
	a := NDArray fromArray: #(1 2 3 4).
	c qTable: a.
	self assert: c qTable identicalTo: a
]

{ #category : #test }
CartPoleQClientTest >> testQValueAtStateAction [
	| c a |
	c := self newCartPole.
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
CartPoleQClientTest >> testQValueAtStateActionPut [
	| c a |
	c := self newCartPole.
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
CartPoleQClientTest >> testSetupBins [
	| c |
	c := self newCartPole.
	self assert: c bins isNil.
	c setupBins.
	self assert: c bins isArray.
	self assert: c bins size equals: 4.
	c bins do: [ :each | self assert: each isNDArray ]
]

{ #category : #test }
CartPoleQClientTest >> testSetupQTable [
	| c |
	c := self newCartPole.
	self assert: c qTable isNil.
	c setupQTable.
	self assert: c qTable isNDArray.
	self assertCollection: c qTable shape equals: #(256 2).
	self assert: c qTable dtype equals: #Float
]
