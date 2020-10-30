"
A PharoPlotQuiverTest is a test class for testing the behavior of PharoPlotQuiver
"
Class {
	#name : #PharoPlotQuiverTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotQuiverTest >> newData [
	^ PharoPlotQuiver new
]

{ #category : #test }
PharoPlotQuiverTest >> testLineColor [
	| d |
	d := self newData.
	self assert: d lineColor isColor
]

{ #category : #test }
PharoPlotQuiverTest >> testLineWidth [
	| d |
	d := self newData.
	self assert: d lineWidth isInteger
]

{ #category : #test }
PharoPlotQuiverTest >> testScale [
	| d |
	d := self newData.
	self assert: d scale equals: 1.
	d scale: 2.
	self assert: d scale equals: 2
]

{ #category : #test }
PharoPlotQuiverTest >> testVectors [
	| d |
	d := self newData.
	self assert: d vectors isNil.
	d
		vectors:
			{(1 @ 2).
			(3 @ 4)}.
	self
		assertCollection: d vectors
		equals:
			{(1 @ 2).
			(3 @ 4)}
]
