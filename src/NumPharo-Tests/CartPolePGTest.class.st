"
A CartPoleNNTest is a test class for testing the behavior of CartPoleNN
"
Class {
	#name : #CartPolePGTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
CartPolePGTest >> newLearning [
	^ CartPolePG new
]

{ #category : #test }
CartPolePGTest >> testActionFor [
	| l a r |
	l := self newLearning.
	a := NDArray fromArray: #(1 2 3 4).
	r := l actionFor: a.
	self assert: r isNumber
]

{ #category : #test }
CartPolePGTest >> testCalculate [
	| l a r |
	l := self newLearning.
	a := NDArray fromArray: #(1 2 3 4).
	l wTry: (NDArray fromArray: #(10 20 30 40)).
	r := l calculate: a.
	self assert: r isNumber.
	self assert: r equals: 10 + 40 + 90 + 160
]

{ #category : #test }
CartPolePGTest >> testChangeEpisode [
	| l |
	l := self newLearning.
	l batches: 8.
	l episode: 5.
	l changeEpisode.
	self assert: l batches equals: 1.
	self assert: l episode equals: 6
]

{ #category : #test }
CartPolePGTest >> testEta [
	| l |
	l := self newLearning.
	self assert: l eta isFloat
]

{ #category : #test }
CartPolePGTest >> testN [
	| l a |
	l := self newLearning.
	self assert: l n isNDArray.
	a := NDRandom randomNormal: 10.
	l n: a.
	self assert: l n identicalTo: a
]

{ #category : #test }
CartPolePGTest >> testNumBatches [
	| l |
	l := self newLearning.
	self assert: l numBatches isInteger
]

{ #category : #test }
CartPolePGTest >> testRewards [
	| l a |
	l := self newLearning.
	self assert: l rewards isArray.
	a := #(1 2 3).
	l rewards: a.
	self assert: l rewards identicalTo: a
]

{ #category : #test }
CartPolePGTest >> testSetupBatch [
	| l |
	l := self newLearning.
	l n: nil.
	l batches: nil.
	l setupBatch.
	self assert: l n isNDArray.
	self assertCollection: l n shape equals: #(10 4).
	self assert: l batches equals: 1
]

{ #category : #test }
CartPolePGTest >> testSetupN [
	| l |
	l := self newLearning.
	l n: nil.
	l setupN.
	self assert: l n isNDArray.
	self assertCollection: l n shape equals: #(10 4)
]

{ #category : #test }
CartPolePGTest >> testSetupRewards [
	| l |
	l := self newLearning.
	l rewards: nil.
	l setupRewards.
	self assert: l rewards isArray.
	self assert: l rewards size equals: 10.
	l rewards do: [ :each | self assert: each equals: 0 ]
]

{ #category : #test }
CartPolePGTest >> testSetupW [
	| l |
	l := self newLearning.
	l w: nil.
	l setupW.
	self assert: l w isNDArray.
	self assertCollection: l w shape equals: #(4)
]

{ #category : #test }
CartPolePGTest >> testSetupWTry [
	| l |
	l := self newLearning.
	l wTry: nil.
	l setupWTry.
	self assert: l wTry isNDArray.
	self assertCollection: l wTry shape equals: #(4)
]

{ #category : #test }
CartPolePGTest >> testSigma [
	| l |
	l := self newLearning.
	self assert: l sigma isFloat
]

{ #category : #test }
CartPolePGTest >> testUpdateRewardDone [
	| l r |
	l := self newLearning.
	l steps: 5.
	r := l update: #(1 2 3 4) reward: 10 done: false.
	self assert: r isNumber.
	self assert: l steps equals: 6.
	self assert: (l rewards at: 2) equals: 0.
	self assert: (l rewards at: 3) equals: 0.
	l batches: 2.
	r := l update: #(1 2 3 4) reward: 10 done: true.
	self assert: r isNumber.
	self assert: l steps equals: 0.
	self assert: l batches equals: 3.
	self assert: (l rewards at: 2) ~= 0.
	l steps: l maxNumberOfSteps - 1.
	l batches: 3.
	r := l update: #(1 2 3 4) reward: 10 done: false.
	self assert: r isNumber.
	self assert: l steps equals: 0.
	self assert: l batches equals: 4.
	self assert: (l rewards at: 3) ~= 0.
	l steps: l maxNumberOfSteps - 1.
	l batches: 10.
	l episode: 5.
	r := l update: #(1 2 3 4) reward: 10 done: false.
	self assert: r isNumber.
	self assert: l steps equals: 0.
	self assert: l batches equals: 1.
	self assert: l episode equals: 6.
	
]

{ #category : #test }
CartPolePGTest >> testW [
	| l a |
	l := self newLearning.
	self assert: l w isNDArray.
	a := NDRandom randomNormal: 10.
	l w: a.
	self assert: l w identicalTo: a
]

{ #category : #test }
CartPolePGTest >> testWTry [
	| l a |
	l := self newLearning.
	self assert: l wTry isNDArray.
	a := NDRandom randomNormal: 10.
	l wTry: a.
	self assert: l wTry identicalTo: a
]
