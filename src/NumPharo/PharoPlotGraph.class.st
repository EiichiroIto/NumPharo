Class {
	#name : #PharoPlotGraph,
	#superclass : #PharoPlotFigure,
	#instVars : [
		'xRange',
		'yRange',
		'showLegend',
		'list'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #private }
PharoPlotGraph >> actualXRange [
	| min max |
	min := self xRange first ifNil: [ self xMin ].
	max := self xRange second ifNil: [ self xMax ].
	^ min to: max
]

{ #category : #private }
PharoPlotGraph >> actualYRange [
	| min max |
	min := self yRange first ifNil: [ self yMin ].
	max := self yRange second ifNil: [ self yMax ].
	^ min to: max
]

{ #category : #private }
PharoPlotGraph >> addData: aDataObject [
	list add: aDataObject
]

{ #category : #api }
PharoPlotGraph >> addXs: aCollection1 ys: aCollection2 label: aString [
	| obj s |
	s := WriteStream on: Array new.
	aCollection1 with: aCollection2 do: [ :x :y | s nextPut: x @ y ].
	obj := self newData.
	obj
		points: s contents;
		label: aString.
	self addData: obj
]

{ #category : #api }
PharoPlotGraph >> clear [
	super clear.
	xRange := Array with: nil with: nil.
	yRange := Array with: nil with: nil.
	showLegend := false.
	list := OrderedCollection new
]

{ #category : #private }
PharoPlotGraph >> colors [
	^ {Color blue.
	Color red.
	Color green.
	Color blue.
	Color brown}
]

{ #category : #drawing }
PharoPlotGraph >> drawAll: aDictionary [
	self drawLabels: aDictionary.
	self drawAxes: aDictionary.
	self hasTitle
		ifTrue: [ self drawTitle: aDictionary ].
	self hasPoints
		ifTrue: [ self drawPlots: aDictionary ].
	self showLegend
		ifTrue: [ self drawLegend: aDictionary ]
]

{ #category : #private }
PharoPlotGraph >> drawData: aData ranges: anArray rectangle: aRectangle on: aCanvas [
	^ aData
		draw: [ :aPoint | 
			| px py |
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
			Array with: px with: py ]
		in: aRectangle
		on: aCanvas
]

{ #category : #drawing }
PharoPlotGraph >> drawLabels: aDictionary [
	self hasXLabel
		ifTrue: [ self drawXLabel: aDictionary ].
	self hasYLabel
		ifTrue: [ self drawYLabel: aDictionary ]
]

{ #category : #drawing }
PharoPlotGraph >> drawLegend: aDictionary [
	| rectangle canvas pos extents legendExtent |
	self list isEmpty
		ifTrue: [ ^ self ].
	extents := self list
		collect: [ :each | each legendExtentFont: self legendFont ].
	legendExtent := (extents max x + 4) @ (extents sum y + 4).
	rectangle := aDictionary at: #rectangle.
	(legendExtent x > rectangle width
		or: [ legendExtent y > rectangle height ])
		ifTrue: [ ^ self ].
	rectangle := (rectangle right - legendExtent x - 4)
		@ (rectangle top + 4) extent: legendExtent.
	canvas := aDictionary at: #canvas.
	canvas
		frameAndFillRectangle: rectangle
		fillColor: self backgroundColor
		borderWidth: 1
		borderColor: self axisColor.
	pos := rectangle topLeft + (2 @ 2).
	self list
		withIndexDo: [ :each :index | 
			each
				drawLegendAt: pos
				font: self legendFont
				color: self labelColor
				on: canvas.
			pos := pos + (0 @ (extents at: index) y) ]
]

{ #category : #drawing }
PharoPlotGraph >> drawPlots: aDictionary [
	| canvas ranges rectangle |
	canvas := aDictionary at: #canvas.
	rectangle := aDictionary at: #rectangle.
	ranges := Array
		with: (aDictionary at: #xRange)
		with: (aDictionary at: #yRange).
	list
		do: [ :each | 
			self
				drawData: each
				ranges: ranges
				rectangle: rectangle
				on: canvas ]
]

{ #category : #testing }
PharoPlotGraph >> hasPoints [
	^ (list collect: [ :each | each hasPoints ])
		inject: false
		into: [ :p :e | p or: e ]
]

{ #category : #accessing }
PharoPlotGraph >> list [
	^ list
]

{ #category : #private }
PharoPlotGraph >> newData [
	^ PharoPlotData new
]

{ #category : #private }
PharoPlotGraph >> screenPoints: anArray1 ranges: anArray2 rectangle: aRectangle [
	^ anArray1
		collect: [ :each | 
			| px py |
			px := self
				positionOf: each x
				inRange: anArray2 first
				from: aRectangle left
				to: aRectangle right.
			py := self
				positionOf: each y
				inRange: anArray2 second
				from: aRectangle bottom
				to: aRectangle top.
			Array with: px with: py ]
]

{ #category : #drawing }
PharoPlotGraph >> setupForm: aForm context: aDictionary [
	| range tlm brm l yScaleWidth |
	aDictionary at: #canvas put: (FormCanvas on: aForm).
	self hasPoints
		ifTrue: [ range := self actualXRange.
			l := self scalesOf: range ]
		ifFalse: [ l := Array new.
			range := 0 to: 0 ].
	range := self expandRange: range.
	aDictionary at: #xRange put: range.
	aDictionary at: #xScales put: l.
	self hasPoints
		ifTrue: [ range := self actualYRange.
			l := self scalesOf: range ]
		ifFalse: [ l := Array new.
			range := 0 to: 0 ].
	range := self expandRange: range.
	aDictionary at: #yRange put: range.
	aDictionary at: #yScales put: l.
	yScaleWidth := self showYAxis
		ifTrue: [ self maxLengthOf: (l collect: #second) ]
		ifFalse: [ 0 ].
	tlm := self topLeftMargin + (yScaleWidth @ 0).
	brm := self bottomRightMargin.
	aDictionary at: #rectangle put: (tlm corner: self extent - brm)
]

{ #category : #accessing }
PharoPlotGraph >> showLegend [
	^ showLegend
]

{ #category : #accessing }
PharoPlotGraph >> showLegend: aBoolean [
	showLegend := aBoolean
]

{ #category : #private }
PharoPlotGraph >> xMax [
	^ (list collect: #xMax) max
]

{ #category : #private }
PharoPlotGraph >> xMin [
	^ (list collect: #xMin) min
]

{ #category : #accessing }
PharoPlotGraph >> xRange [
	^ xRange
]

{ #category : #accessing }
PharoPlotGraph >> xRange: anObject [
	xRange := anObject
]

{ #category : #private }
PharoPlotGraph >> yMax [
	^ (list collect: #yMax) max
]

{ #category : #private }
PharoPlotGraph >> yMin [
	^ (list collect: #yMin) min
]

{ #category : #accessing }
PharoPlotGraph >> yRange [
	^ yRange
]

{ #category : #accessing }
PharoPlotGraph >> yRange: anObject [
	yRange := anObject
]
