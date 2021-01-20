"
A PolicyGradientMethodTest is a test class for testing the behavior of PolicyGradientMethod
"
Class {
	#name : #PolicyGradientMethodTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PolicyGradientMethodTest >> newLearning [
	^ PolicyGradientMethod new
]

{ #category : #test }
PolicyGradientMethodTest >> testBatches [
	| l |
	l := self newLearning.
	self assert: l batches isNil.
	l batches: 123.
	self assert: l batches equals: 123
]
