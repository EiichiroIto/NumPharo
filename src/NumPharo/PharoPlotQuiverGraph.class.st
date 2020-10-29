Class {
	#name : #PharoPlotQuiverGraph,
	#superclass : #PharoPlotBaseGraph,
	#instVars : [
		'data'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #api }
PharoPlotQuiverGraph >> addXs: xs ys: ys us: us vs: vs scale: aNumber [
	((xs size = ys size and: [ xs size = us size ])
		and: [ xs size = vs size ])
		ifFalse: [ self error ].
	data
		points: (xs with: ys collect: [ :x :y | x @ y ]);
		vectors: (us with: vs collect: [ :x :y | x @ y ]);
		scale: aNumber
]

{ #category : #api }
PharoPlotQuiverGraph >> clear [
	super clear.
	data := PharoPlotQuiver new
]

{ #category : #drawing }
PharoPlotQuiverGraph >> drawAll: aDictionary [
	self drawLabels: aDictionary.
	self drawAxes: aDictionary.
	self hasTitle
		ifTrue: [ self drawTitle: aDictionary ].
	self hasPoints
		ifTrue: [ self drawPlots: aDictionary ]
]

{ #category : #drawing }
PharoPlotQuiverGraph >> drawData: aData ranges: anArray rectangle: aRectangle on: aCanvas [
	^ aData
		draw: [ :aPoint :aVector | 
			| px py vx vy v |
			px := self
				positionOf: aPoint x
				inRange: anArray first
				from: aRectangle left
				to: aRectangle right.
			py := self
				positionOf: aPoint y
				inRange: anArray second
				from: aRectangle bottom
				to: aRectangle top.
			vx := self
				unitOfRange: anArray first
				from: aRectangle left
				to: aRectangle right.
			vy := self
				unitOfRange: anArray second
				from: aRectangle bottom
				to: aRectangle top.
			v := vx @ vy * aVector.
			Array
				with: px
				with: py
				with: v x
				with: v y ]
		in: aRectangle
		on: aCanvas
]

{ #category : #drawing }
PharoPlotQuiverGraph >> drawPlots: aDictionary [
	| canvas ranges rectangle |
	canvas := aDictionary at: #canvas.
	rectangle := aDictionary at: #rectangle.
	ranges := Array
		with: (aDictionary at: #xRange)
		with: (aDictionary at: #yRange).
	self
		drawData: data
		ranges: ranges
		rectangle: rectangle
		on: canvas
]

{ #category : #testing }
PharoPlotQuiverGraph >> hasPoints [
	^ data hasPoints
]

{ #category : #testing }
PharoPlotQuiverGraph >> isQuiverGraph [
	^ true
]

{ #category : #drawing }
PharoPlotQuiverGraph >> setupForm: aForm context: aDictionary [
	| range tlm brm l yScaleWidth |
	aDictionary at: #canvas put: (FormCanvas on: aForm).
	self hasPoints
		ifTrue: [ range := self actualXRange.
			l := self scalesOf: range ]
		ifFalse: [ l := Array new.
			range := 0 to: 0 ].
	aDictionary at: #xRange put: range.
	aDictionary at: #xScales put: l.
	self hasPoints
		ifTrue: [ range := self actualYRange.
			l := self scalesOf: range ]
		ifFalse: [ l := Array new.
			range := 0 to: 0 ].
	aDictionary at: #yRange put: range.
	aDictionary at: #yScales put: l.
	yScaleWidth := self showYAxis
		ifTrue: [ self maxLengthOf: (l collect: #second) ]
		ifFalse: [ 0 ].
	tlm := self topLeftMargin + (yScaleWidth @ 0).
	brm := self bottomRightMargin.
	aDictionary at: #rectangle put: (tlm corner: self extent - brm)
]

{ #category : #private }
PharoPlotQuiverGraph >> xMax [
	^ data xMax
]

{ #category : #private }
PharoPlotQuiverGraph >> xMin [
	^ data xMin
]

{ #category : #private }
PharoPlotQuiverGraph >> yMax [
	^ data yMax
]

{ #category : #private }
PharoPlotQuiverGraph >> yMin [
	^ data yMin
]
