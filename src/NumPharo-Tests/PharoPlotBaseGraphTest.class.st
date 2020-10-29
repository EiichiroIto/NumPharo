"
A PharoPlotBaseGraphTest is a test class for testing the behavior of PharoPlotBaseGraph
"
Class {
	#name : #PharoPlotBaseGraphTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests-Plot'
}

{ #category : #private }
PharoPlotBaseGraphTest >> newGraph [
	^ PharoPlotBaseGraph new
]

{ #category : #test }
PharoPlotBaseGraphTest >> testClear [
	| m |
	m := self newGraph.
	self assert: m xRange isArray.
	self assert: m xRange size equals: 2.
	self assert: m yRange isArray.
	self assert: m yRange size equals: 2
]

{ #category : #test }
PharoPlotBaseGraphTest >> testXRange [
	| p |
	p := self newGraph.
	self assertCollection: p xRange equals: #(nil nil).
	p xRange: #(1 2).
	self assertCollection: p xRange equals: #(1 2)
]

{ #category : #test }
PharoPlotBaseGraphTest >> testYRange [
	| p |
	p := self newGraph.
	self assertCollection: p yRange equals: #(nil nil).
	p yRange: #(1 2).
	self assertCollection: p yRange equals: #(1 2)
]
