"
A PharoPlotBarGraphTest is a test class for testing the behavior of PharoPlotBarGraph
"
Class {
	#name : #PharoPlotBarGraphTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotBarGraphTest >> newGraph [
	^ PharoPlotBarGraph new
]

{ #category : #test }
PharoPlotBarGraphTest >> testIsBarGraph [
	| p |
	p := self newGraph.
	self assert: p isBarGraph
]

{ #category : #test }
PharoPlotBarGraphTest >> testNewData [
	| p |
	p := self newGraph.
	self assert: (p newData isKindOf: PharoPlotBar)
]

{ #category : #test }
PharoPlotBarGraphTest >> testNextBarStyle [
	| p |
	p := self newGraph.
	self assert: p nextBarStyle isColor
]
