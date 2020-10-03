"
A SubPlotMorphTest is a test class for testing the behavior of SubPlotMorph
"
Class {
	#name : #PharoPlotLineGraphTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotLineGraphTest >> newPlot [
	^ PharoPlotLineGraph new
]

{ #category : #test }
PharoPlotLineGraphTest >> testActualXRange [
	| p |
	p := self newPlot.
	self assertCollection: p xRange equals: #(nil nil).
	p xRange: #(0 nil).
	p addXs: #(-1 0 1 2 3) ys: #(1 2 3 4 5) label: #a.
	self assertCollection: p actualXRange equals: (0 to: 3).
	p xRange: #(nil 2).
	self assertCollection: p actualXRange equals: (-1 to: 2).
	p xRange: #(nil nil).
	self assertCollection: p actualXRange equals: (-1 to: 3)
]

{ #category : #test }
PharoPlotLineGraphTest >> testActualYRange [
	| p |
	p := self newPlot.
	self assertCollection: p yRange equals: #(nil nil).
	p yRange: #(0 nil).
	p addXs: #(1 2 3 4 5) ys: #(-1 0 1 2 3) label: #b.
	self assertCollection: p actualYRange equals: (0 to: 3).
	p yRange: #(nil 2).
	self assertCollection: p actualYRange equals: (-1 to: 2).
	p yRange: #(nil nil).
	self assertCollection: p actualYRange equals: (-1 to: 3).
	p addXs: #(1 2) ys: #(-2 5) label: #c.
	self assertCollection: p actualYRange equals: (-2 to: 5)
]

{ #category : #test }
PharoPlotLineGraphTest >> testHasPoints [
	| p |
	p := self newPlot.
	self deny: p hasPoints.
	p addXs: #(1) ys: #(2) label: 'test'.
	p addXs: #(3 4) ys: #(5 6) label: 'test'.
	self assert: p hasPoints
]

{ #category : #test }
PharoPlotLineGraphTest >> testIsLineGraph [
	| f |
	f := self newPlot.
	self assert: f isLineGraph
]

{ #category : #test }
PharoPlotLineGraphTest >> testXMax [
	| p |
	p := self newPlot.
	self should: [ p xMax ] raise: Error.
	p addXs: #(1) ys: #(2) label: 'test1'.
	self assert: p xMax equals: 1.
	p addXs: #(3 4) ys: #(5 6) label: 'test2'.
	self assert: p xMax equals: 4
]

{ #category : #test }
PharoPlotLineGraphTest >> testXMin [
	| p |
	p := self newPlot.
	self should: [ p xMin ] raise: Error.
	p addXs: #(1) ys: #(2) label: 'test1'.
	self assert: p xMin equals: 1.
	p addXs: #(3 4) ys: #(5 6) label: 'test2'.
	self assert: p xMin equals: 1
]

{ #category : #test }
PharoPlotLineGraphTest >> testYMax [
	| p |
	p := self newPlot.
	self should: [ p yMax ] raise: Error.
	p addXs: #(1) ys: #(2) label: 'test1'.
	self assert: p yMax equals: 2.
	p addXs: #(3 4) ys: #(5 6) label: 'test2'.
	self assert: p yMax equals: 6
]

{ #category : #test }
PharoPlotLineGraphTest >> testYMin [
	| p |
	p := self newPlot.
	self should: [ p yMin ] raise: Error.
	p addXs: #(1) ys: #(2) label: 'test1'.
	self assert: p yMin equals: 2.
	p addXs: #(3 4) ys: #(5 6) label: 'test2'.
	self assert: p yMin equals: 2
]
