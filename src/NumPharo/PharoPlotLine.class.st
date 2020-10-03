Class {
	#name : #PharoPlotLine,
	#superclass : #PharoPlotData,
	#instVars : [
		'lineStyle'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #api }
PharoPlotLine >> draw: aBlock in: aRectangle on: aCanvas [
	| prev |
	prev := Array with: nil with: nil.
	self points
		do: [ :each | 
			| pos |
			pos := aBlock cull: each.
			self line: prev to: pos on: aCanvas.
			prev := pos ]
]

{ #category : #api }
PharoPlotLine >> drawLegendAt: aPoint font: aFont color: aColor on: aCanvas [
	| h pos |
	h := aFont height.
	pos := aPoint + (0 @ (h // 2)).
	self line: pos asArray to: (pos + (20 @ 0)) asArray on: aCanvas.
	aCanvas
		drawString: self label
		at: aPoint + (23 @ 0)
		font: aFont
		color: aColor
]

{ #category : #api }
PharoPlotLine >> legendExtentFont: aFont [
	^ 23 + (aFont widthOfString: self label) @ aFont height
]

{ #category : #api }
PharoPlotLine >> line: from to: to on: aCanvas [
	(from includes: nil)
		ifTrue: [ ^ self ].
	(to includes: nil)
		ifTrue: [ ^ self ].
	aCanvas
		line: from first @ from second
		to: to first @ to second
		width: 1
		colors: lineStyle second
		dashes: lineStyle first
		startingOffset: 0
]

{ #category : #accessing }
PharoPlotLine >> lineStyle [
	^ lineStyle
]

{ #category : #accessing }
PharoPlotLine >> lineStyle: anArray [
	lineStyle := anArray
]
