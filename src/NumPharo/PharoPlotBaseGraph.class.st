Class {
	#name : #PharoPlotBaseGraph,
	#superclass : #PharoPlotFigure,
	#instVars : [
		'xRange',
		'yRange'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #private }
PharoPlotBaseGraph >> actualXRange [
	| min max |
	min := self xRange first ifNil: [ self xMin ].
	max := self xRange second ifNil: [ self xMax ].
	^ min to: max
]

{ #category : #private }
PharoPlotBaseGraph >> actualYRange [
	| min max |
	min := self yRange first ifNil: [ self yMin ].
	max := self yRange second ifNil: [ self yMax ].
	^ min to: max
]

{ #category : #api }
PharoPlotBaseGraph >> clear [
	super clear.
	xRange := Array with: nil with: nil.
	yRange := Array with: nil with: nil
]

{ #category : #drawing }
PharoPlotBaseGraph >> drawLabels: aDictionary [
	self hasXLabel
		ifTrue: [ self drawXLabel: aDictionary ].
	self hasYLabel
		ifTrue: [ self drawYLabel: aDictionary ]
]

{ #category : #accessing }
PharoPlotBaseGraph >> xRange [
	^ xRange
]

{ #category : #accessing }
PharoPlotBaseGraph >> xRange: anObject [
	xRange := anObject
]

{ #category : #accessing }
PharoPlotBaseGraph >> yRange [
	^ yRange
]

{ #category : #accessing }
PharoPlotBaseGraph >> yRange: anObject [
	yRange := anObject
]
