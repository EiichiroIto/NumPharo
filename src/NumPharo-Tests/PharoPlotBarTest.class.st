"
A PharoPlotBarTest is a test class for testing the behavior of PharoPlotBar
"
Class {
	#name : #PharoPlotBarTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotBarTest >> newData [
	^ PharoPlotBar new
]

{ #category : #test }
PharoPlotBarTest >> testBarStyle [
	| d |
	d := self newData.
	self assert: d barStyle isNil.
	d barStyle: Color red.
	self assert: d barStyle equals: Color red
]

{ #category : #test }
PharoPlotBarTest >> testBarWidthOf [
	| d r |
	d := self newData.
	d points: #(1 2 3 4 5).
	r := d barWidthOf: (0 @ 0 extent: 120 @ 20).
	self assert: r equals: 16
]

{ #category : #test }
PharoPlotBarTest >> testBarWidthRatio [
	| d |
	d := self newData.
	self assert: d barWidthRatio isNumber
]

{ #category : #test }
PharoPlotBarTest >> testBottom [
	| d |
	d := self newData.
	self assert: d bottom isNil.
	d bottom: #(1 2 3).
	self assertCollection: d bottom equals: #(1 2 3)
]

{ #category : #test }
PharoPlotBarTest >> testSampleLegendExtent [
	| d |
	d := self newData.
	self assert: d sampleLegendExtent isPoint
]
