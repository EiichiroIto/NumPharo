"
A Chapter4FunctionsTest is a test class for testing the behavior of Chapter4Functions
"
Class {
	#name : #Chapter4FunctionsTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
Chapter4FunctionsTest >> newFunctions [
	^ Chapter4Functions new
]

{ #category : #test }
Chapter4FunctionsTest >> testCrossEntropyErrorYAndT [
	| f t y r |
	f := self newFunctions.
	t := NDArray fromArray: #(0 0 1 0 0 0 0 0 0 0).
	y := NDArray fromArray: #(0.1 0.05 0.6 0.0 0.05 0.1 0.0 0.1 0.0 0.0).
	r := f crossEntropyErrorY: y andT: t.
	self assert: r closeTo: 0.51082545.
	y := NDArray fromArray: #(0.1 0.05 0.1 0.0 0.05 0.1 0.0 0.6 0.0 0.0).
	r := f crossEntropyErrorY: y andT: t.
	self assert: r closeTo: 2.30258409
]

{ #category : #test }
Chapter4FunctionsTest >> testSoftMax [
	| a y |
	a := NDArray fromArray: #(0.3 2.9 4.0).
	y := self newFunctions softMax: a.
	self assert: y sum closeTo: 1
]
