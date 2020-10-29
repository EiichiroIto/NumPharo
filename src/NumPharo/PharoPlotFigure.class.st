Class {
	#name : #PharoPlotFigure,
	#superclass : #Object,
	#instVars : [
		'title',
		'xLabel',
		'yLabel',
		'extent',
		'showAxis'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #private }
PharoPlotFigure >> axisColor [
	^ Color gray
]

{ #category : #private }
PharoPlotFigure >> backgroundColor [
	^ Color white
]

{ #category : #drawing }
PharoPlotFigure >> baseForm [
	^ Form extent: self extent depth: self defaultDepth
]

{ #category : #private }
PharoPlotFigure >> bottomRightMargin [
	| b |
	b := self hasXLabel
		ifTrue: [ 1 ]
		ifFalse: [ 0 ].
	b := b
		+
			(self showXAxis
				ifTrue: [ 1 ]
				ifFalse: [ 0 ]).
	^ 4 @ (self labelFont height * b) + 6
]

{ #category : #api }
PharoPlotFigure >> clear [
	xLabel := yLabel := title := nil.
	extent := self defaultExtent.
	showAxis := Array with: true with: true
]

{ #category : #private }
PharoPlotFigure >> defaultDepth [
	^ 32
]

{ #category : #private }
PharoPlotFigure >> defaultExtent [
	^ 400 @ 200
]

{ #category : #drawing }
PharoPlotFigure >> drawAll: aDictionary [
	"self subclassResponsibility"
]

{ #category : #drawing }
PharoPlotFigure >> drawAxes: aDictionary [
	self showXAxis
		ifTrue: [ self drawXAxis: aDictionary.
			self drawXScales: aDictionary ].
	self showYAxis
		ifTrue: [ self drawYAxis: aDictionary.
			self drawYScales: aDictionary ]
]

{ #category : #drawing }
PharoPlotFigure >> drawBackground: aDictionary [
	| canvas |
	canvas := aDictionary at: #canvas.
	canvas fillColor: self backgroundColor
]

{ #category : #drawing }
PharoPlotFigure >> drawTitle: aDictionary [
	| canvas w1 w2 font |
	font := self labelFont.
	canvas := aDictionary at: #canvas.
	w1 := self extent x.
	w2 := font widthOfString: self title.
	w1 > w2
		ifTrue: [ canvas
				drawString: self title
				at: ((w1 - w2) // 2) @ 2
				font: font
				color: self labelColor ]
]

{ #category : #drawing }
PharoPlotFigure >> drawXAxis: aDictionary [
	| canvas rectangle |
	canvas := aDictionary at: #canvas.
	rectangle := aDictionary at: #rectangle.
	canvas
		line: rectangle bottomLeft
		to: rectangle bottomRight + (6 @ 0)
		width: 1
		color: self axisColor
]

{ #category : #drawing }
PharoPlotFigure >> drawXLabel: aDictionary [
	| canvas rectangle w1 w2 font |
	font := self labelFont.
	canvas := aDictionary at: #canvas.
	rectangle := aDictionary at: #rectangle.
	w1 := rectangle width.
	w2 := font widthOfString: self xLabel.
	w1 > w2
		ifTrue: [ canvas
				drawString: self xLabel
				at:
					(rectangle left + ((w1 - w2) // 2))
						@ (self extent y - font height - 2)
				font: font
				color: self labelColor ]
]

{ #category : #drawing }
PharoPlotFigure >> drawXScaleLabel: aString at: aPoint canvas: aCanvas [
	aCanvas
		drawString: aString
		at: (aPoint x - (self labelFont widthOfString: aString)) @ (aPoint y + 2)
		font: self labelFont
		color: self labelColor
]

{ #category : #drawing }
PharoPlotFigure >> drawXScales: aDictionary [
	| range canvas scales x rectangle |
	canvas := aDictionary at: #canvas.
	rectangle := aDictionary at: #rectangle.
	range := aDictionary at: #xRange.
	scales := aDictionary at: #xScales.
	scales
		do: [ :each | 
			x := self
				positionOf: each first
				inRange: range
				from: rectangle left
				to: rectangle right.
			x
				ifNotNil: [ canvas
						line: x @ rectangle bottom
						to: x @ (rectangle bottom - 6)
						color: self axisColor.
					self
						drawXScaleLabel: each second
						at: x @ rectangle bottom
						canvas: canvas ] ]
]

{ #category : #drawing }
PharoPlotFigure >> drawYAxis: aDictionary [
	| canvas rectangle |
	canvas := aDictionary at: #canvas.
	rectangle := aDictionary at: #rectangle.
	canvas
		line: rectangle topLeft - (0 @ 6)
		to: rectangle bottomLeft
		width: 1
		color: self axisColor
]

{ #category : #drawing }
PharoPlotFigure >> drawYLabel: aDictionary [
	| canvas h1 h2 f font rectangle |
	font := self labelFont.
	canvas := aDictionary at: #canvas.
	rectangle := aDictionary at: #rectangle.
	f := self rotatedFormString: self yLabel font: font color: self labelColor.
	h1 := rectangle height.
	h2 := f height.
	h1 > h2
		ifTrue: [ canvas
				translucentImage: f
				at: 0 @ (rectangle top + ((h1 - h2) // 2)) ]
]

{ #category : #drawing }
PharoPlotFigure >> drawYScaleLabel: aString at: aPoint canvas: aCanvas [
	aCanvas
		drawString: aString
		at:
			(aPoint x - (self labelFont widthOfString: aString) - 8)
				@ (aPoint y - (self labelFont height // 2))
		font: self labelFont
		color: self labelColor
]

{ #category : #drawing }
PharoPlotFigure >> drawYScales: aDictionary [
	| range rectangle canvas scales y |
	canvas := aDictionary at: #canvas.
	rectangle := aDictionary at: #rectangle.
	range := aDictionary at: #yRange.
	scales := aDictionary at: #yScales.
	scales
		do: [ :each | 
			y := self
				positionOf: each first
				inRange: range
				from: rectangle bottom
				to: rectangle top.
			y
				ifNotNil: [ canvas
						line: (rectangle left + 6) @ y
						to: rectangle left @ y
						color: self axisColor.
					self
						drawYScaleLabel: each second
						at: rectangle left @ y
						canvas: canvas ] ]
]

{ #category : #private }
PharoPlotFigure >> expandRange: aInterval [
	| w dw |
	w := aInterval extent.
	dw := w * 0.05.
	^ aInterval first - dw to: aInterval first + w + dw
]

{ #category : #accessing }
PharoPlotFigure >> extent [
	^ extent
]

{ #category : #accessing }
PharoPlotFigure >> extent: aPoint [
	extent := aPoint
]

{ #category : #api }
PharoPlotFigure >> form [
	| form dict |
	form := self baseForm.
	dict := Dictionary new.
	self setupForm: form context: dict.
	self drawBackground: dict.
	self drawAll: dict.
	^ form
]

{ #category : #private }
PharoPlotFigure >> gridCount [
	^ 5
]

{ #category : #private }
PharoPlotFigure >> gridSizeOf: aRange [
	| w log10 |
	w := aRange extent abs / self gridCount.
	log10 := (w log: 10) floor.
	^ (w roundTo: (10 raisedTo: log10)) asFloat
]

{ #category : #testing }
PharoPlotFigure >> hasTitle [
	^ title notNil and: [ title notEmpty ]
]

{ #category : #testing }
PharoPlotFigure >> hasXLabel [
	^ xLabel notNil and: [ xLabel notEmpty ]
]

{ #category : #testing }
PharoPlotFigure >> hasYLabel [
	^ yLabel notNil and: [ yLabel notEmpty ]
]

{ #category : #initialization }
PharoPlotFigure >> initialize [
	self clear
]

{ #category : #testing }
PharoPlotFigure >> isBarGraph [
	^ false
]

{ #category : #testing }
PharoPlotFigure >> isImage [
	^ false
]

{ #category : #testing }
PharoPlotFigure >> isLineGraph [
	^ false
]

{ #category : #testing }
PharoPlotFigure >> isQuiverGraph [
	^ false
]

{ #category : #testing }
PharoPlotFigure >> isScatterGraph [
	^ false
]

{ #category : #private }
PharoPlotFigure >> labelColor [
	^ Color gray
]

{ #category : #private }
PharoPlotFigure >> labelFont [
	^ StrikeFont familyName: 'Verdana' size: 10
]

{ #category : #private }
PharoPlotFigure >> legendFont [
	^ StrikeFont familyName: 'Verdana' size: 9
]

{ #category : #private }
PharoPlotFigure >> maxLengthOf: aCollection [
	^ aCollection
		ifEmpty: [ 0 ]
		ifNotEmpty:
			[ (aCollection collect: [ :each | self labelFont widthOfString: each ])
				max ]
]

{ #category : #private }
PharoPlotFigure >> positionOf: aNumber1 inRange: aRange from: aNumber2 to: aNumber3 [
	(aRange rangeIncludes: aNumber1)
		ifFalse: [ ^ nil ].
	aNumber1 < aRange first
		ifTrue: [ ^ aNumber2 ].
	aNumber1 > (aRange extent + aRange first)
		ifTrue: [ ^ aNumber3 ].
	^ (aNumber2
		interpolateTo: aNumber3
		at: (aNumber1 - aRange first) / aRange extent) asFloat
]

{ #category : #private }
PharoPlotFigure >> rotatedFormString: aString font: aFont color: aColor [
	| form canvas |
	form := Form
		extent: (aFont widthOfString: aString) @ aFont height
		depth: self defaultDepth.
	form fillColor: self backgroundColor.
	canvas := FormCanvas on: form.
	canvas
		drawString: aString
		at: 0 @ 0
		font: aFont
		color: aColor.
	^ form rotateBy: -90
]

{ #category : #private }
PharoPlotFigure >> scalesOf: aRange [
	| grid cur s t log10 |
	grid := self gridSizeOf: aRange.
	s := WriteStream on: Array new.
	cur := aRange first // grid * grid.
	cur < aRange first
		ifTrue: [ cur := cur + grid.
			s nextPut: aRange first ].
	[ aRange rangeIncludes: cur ]
		whileTrue: [ s nextPut: cur.
			cur := cur + grid ].
	t := aRange extent + aRange first.
	(cur - grid closeTo: t)
		ifFalse: [ s nextPut: t ].
	log10 := (aRange extent abs log: 10) rounded.
	^ s contents
		collect:
			[ :each | Array with: each
			 with: (each printShowingDecimalPlaces: log10 negated + 1) ]
]

{ #category : #drawing }
PharoPlotFigure >> setupForm: aForm context: aDictionary [
	self subclassResponsibility
]

{ #category : #accessing }
PharoPlotFigure >> showAxis [
	^ showAxis
]

{ #category : #accessing }
PharoPlotFigure >> showAxis: anArray [
	showAxis := anArray
]

{ #category : #testing }
PharoPlotFigure >> showXAxis [
	^ showAxis first
]

{ #category : #testing }
PharoPlotFigure >> showYAxis [
	^ showAxis second
]

{ #category : #accessing }
PharoPlotFigure >> title [
	^ title
]

{ #category : #accessing }
PharoPlotFigure >> title: anObject [
	title := anObject
]

{ #category : #private }
PharoPlotFigure >> topLeftMargin [
	^ ((self hasYLabel
		ifTrue: [ self labelFont height ]
		ifFalse: [ 0 ]) + 8)
		@
			(self hasTitle
				ifTrue: [ self labelFont height ]
				ifFalse: [ 0 ]) + 10
]

{ #category : #private }
PharoPlotFigure >> unitOfRange: aRange from: aNumber2 to: aNumber3 [
	^ (aNumber3 - aNumber2) / aRange extent
]

{ #category : #accessing }
PharoPlotFigure >> xLabel [
	^ xLabel
]

{ #category : #accessing }
PharoPlotFigure >> xLabel: anObject [
	xLabel := anObject
]

{ #category : #accessing }
PharoPlotFigure >> yLabel [
	^ yLabel
]

{ #category : #accessing }
PharoPlotFigure >> yLabel: anObject [
	yLabel := anObject
]
