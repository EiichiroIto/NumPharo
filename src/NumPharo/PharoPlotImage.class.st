Class {
	#name : #PharoPlotImage,
	#superclass : #PharoPlotFigure,
	#instVars : [
		'image'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #private }
PharoPlotImage >> actualXRange [
	^ 0 to: image width
]

{ #category : #private }
PharoPlotImage >> actualYRange [
	^ 0 to: image height
]

{ #category : #drawing }
PharoPlotImage >> drawAll: aDictionary [
	self hasTitle
		ifTrue: [ self drawTitle: aDictionary ].
	self drawAxes: aDictionary.
	self drawImage: aDictionary
]

{ #category : #drawing }
PharoPlotImage >> drawImage: aDictionary [
	| canvas rectangle magnify f |
	canvas := aDictionary at: #canvas.
	rectangle := aDictionary at: #rectangle.
	magnify := aDictionary at: #magnify.
	f := image magnifyBy: magnify.
	canvas drawImage: f at: (rectangle left + 1 @ (rectangle bottom - f height))
]

{ #category : #testing }
PharoPlotImage >> hasImage [
	^ image notNil
]

{ #category : #accessing }
PharoPlotImage >> image [
	^ image
]

{ #category : #accessing }
PharoPlotImage >> image: aForm [
	image := aForm
]

{ #category : #private }
PharoPlotImage >> imageExtentAndMagnification: aDictionary [
	| rectangle m ex |
	image ifNil: [ ^ nil ].
	rectangle := aDictionary at: #rectangle.
	m := (rectangle extent / image extent) min asFloat.
	ex := (image extent * m) truncated.
	^ {ex.
	m}
]

{ #category : #testing }
PharoPlotImage >> isImage [
	^ true
]

{ #category : #drawing }
PharoPlotImage >> setupForm: aForm context: aDictionary [
	| range list yScaleWidth tlm brm r |
	aDictionary at: #canvas put: (FormCanvas on: aForm).
	range := self hasImage
		ifTrue: [ self actualXRange ]
		ifFalse: [ 0 to: 1 ].
	list := self scalesOf: range.
	aDictionary at: #xRange put: range.
	aDictionary at: #xScales put: list.
	range := self hasImage
		ifTrue: [ self actualYRange ]
		ifFalse: [ 0 to: 1 ].
	list := self scalesOf: range.
	aDictionary at: #yRange put: range.
	aDictionary at: #yScales put: list.
	yScaleWidth := self showYAxis
		ifTrue: [ self maxLengthOf: (list collect: #second) ]
		ifFalse: [ 0 ].
	tlm := self topLeftMargin + (yScaleWidth @ 0).
	brm := self bottomRightMargin.
	aDictionary at: #rectangle put: (tlm corner: self extent - brm).
	r := self imageExtentAndMagnification: aDictionary.
	tlm := tlm max: ((self extent - r first) // 2).
	aDictionary at: #rectangle put: (tlm extent: r first).
	aDictionary at: #magnify put: r second
]
