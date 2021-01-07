Class {
	#name : #CartPoleQTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
CartPoleQTest >> newCartPole [
	^ CartPoleQ new
]

{ #category : #test }
CartPoleQTest >> testAlpha [
	| c |
	c := self newCartPole.
	self assert: c alpha isFloat
]

{ #category : #test }
CartPoleQTest >> testGamma [
	| c |
	c := self newCartPole.
	self assert: c gamma isFloat
]

{ #category : #test }
CartPoleQTest >> testMaxNumberOfSteps [
	| c |
	c := self newCartPole.
	self assert: c maxNumberOfSteps isInteger
]

{ #category : #test }
CartPoleQTest >> testNumActions [
	| c |
	c := self newCartPole.
	self assert: c numActions isInteger
]

{ #category : #test }
CartPoleQTest >> testNumObservations [
	| c |
	c := self newCartPole.
	self assert: c numObservations isInteger
]

{ #category : #test }
CartPoleQTest >> testSetupBins [
	| c |
	c := self newCartPole.
	self assert: c bins isArray.
	self assert: c bins size equals: 4.
	c bins do: [ :each | self assert: each isNDArray ]
]

{ #category : #test }
CartPoleQTest >> testSetupQTable [
	| c |
	c := self newCartPole.
	self assert: c qTable isNDArray.
	self assertCollection: c qTable shape equals: #(256 2).
	self assert: c qTable dtype equals: #Float
]

{ #category : #test }
CartPoleQTest >> testUpdateRewardDone [
	| c r |
	c := self newCartPole.
	r := c update: #(1 2 3 4) reward: 10 done: false.
	
]
