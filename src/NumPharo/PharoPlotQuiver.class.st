Class {
	#name : #PharoPlotQuiver,
	#superclass : #PharoPlotData,
	#instVars : [
		'vectors',
		'scale'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #api }
PharoPlotQuiver >> draw: aBlock in: aRectangle on: aCanvas [
	self points
		with: self vectors
		do: [ :p :v | 
			| vec |
			vec := aBlock cull: p cull: v.
			self drawVector: vec on: aCanvas ]
]

{ #category : #private }
PharoPlotQuiver >> drawVector: anArray on: aCanvas [
	| x y u v |
	x := anArray first.
	y := anArray second.
	(x isNil or: [ y isNil ])
		ifTrue: [ ^ self ].
	u := anArray third * self scale.
	v := anArray fourth * self scale.
	(u = 0 or: [ v = 0 ])
		ifTrue: [ ^ self ].
	aCanvas
		fillRectangle: (Rectangle center: x @ y extent: 4 @ 4)
		color: self lineColor.
	aCanvas
		line: x @ y
		to: x @ y + (u @ v)
		width: self lineWidth
		color: self lineColor
]

{ #category : #private }
PharoPlotQuiver >> lineColor [
	^ Color black
]

{ #category : #private }
PharoPlotQuiver >> lineWidth [
	^ 1
]

{ #category : #accessing }
PharoPlotQuiver >> scale [
	^ scale ifNil: [ 1 ]
]

{ #category : #accessing }
PharoPlotQuiver >> scale: aNumber [
	scale := aNumber
]

{ #category : #accessing }
PharoPlotQuiver >> vectors [
	^ vectors
]

{ #category : #accessing }
PharoPlotQuiver >> vectors: anArray [
	vectors := anArray
]
