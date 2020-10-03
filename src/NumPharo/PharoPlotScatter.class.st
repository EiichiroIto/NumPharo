Class {
	#name : #PharoPlotScatter,
	#superclass : #PharoPlotData,
	#instVars : [
		'markerSize',
		'markerStyle',
		'markerColor',
		'form'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #api }
PharoPlotScatter >> draw: aBlock in: aRectangle on: aCanvas [
	self points
		do: [ :each | 
			| pos |
			pos := aBlock cull: each.
			self drawMarkerAt: pos on: aCanvas ]
]

{ #category : #api }
PharoPlotScatter >> drawLegendAt: aPoint font: aFont color: aColor on: aCanvas [
	| h pos |
	h := aFont height.
	pos := aPoint + (self form width // 2 @ (h // 2)).
	self drawMarkerAt: pos asArray on: aCanvas.
	aCanvas
		drawString: self label
		at: aPoint + (self form width + 3 @ 0)
		font: aFont
		color: aColor
]

{ #category : #api }
PharoPlotScatter >> drawMarkerAt: anArray on: aCanvas [
	| f |
	(anArray includes: nil)
		ifTrue: [ ^ self ].
	f := self form.
	aCanvas
		translucentImage: f
		at:
			(anArray first - (f extent x // 2))
				@ (anArray second - (f extent y // 2))
]

{ #category : #accessing }
PharoPlotScatter >> form [
	^ form ifNil: [ form := self markerForm ]
]

{ #category : #api }
PharoPlotScatter >> legendExtentFont: aFont [
	| f |
	f := self form extent.
	^ f x + 3 + (aFont widthOfString: self label) @ (f y max: aFont height)
]

{ #category : #accessing }
PharoPlotScatter >> markerColor [
	^ markerColor
]

{ #category : #accessing }
PharoPlotScatter >> markerColor: anObject [
	markerColor := anObject
]

{ #category : #private }
PharoPlotScatter >> markerForm [
	| size canvas markerForm |
	size := 1 @ 1 * markerSize.
	markerForm := Form extent: size depth: 32.
	markerForm fillColor: Color transparent.
	canvas := FormCanvas on: markerForm.
	markerStyle = $o
		ifTrue: [ canvas frameOval: (0 @ 0 corner: size) color: self markerColor ].
	('x*' includes: markerStyle)
		ifTrue: [ canvas line: 0 @ 0 to: size color: self markerColor.
			canvas line: size x @ 0 to: 0 @ size y color: self markerColor ].
	markerStyle = $*
		ifTrue: [ canvas
				line: 0 @ (size y // 2)
				to: size x @ (size y // 2)
				color: self markerColor ].
	^ markerForm
]

{ #category : #accessing }
PharoPlotScatter >> markerSize [
	^ markerSize
]

{ #category : #accessing }
PharoPlotScatter >> markerSize: aPoint [
	markerSize := aPoint
]

{ #category : #accessing }
PharoPlotScatter >> markerStyle [
	^ markerStyle
]

{ #category : #accessing }
PharoPlotScatter >> markerStyle: aCharacter [
	markerStyle := aCharacter
]
