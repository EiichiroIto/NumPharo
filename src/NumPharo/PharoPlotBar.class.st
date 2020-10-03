Class {
	#name : #PharoPlotBar,
	#superclass : #PharoPlotData,
	#instVars : [
		'barStyle',
		'bottom'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #accessing }
PharoPlotBar >> barStyle [
	^ barStyle
]

{ #category : #accessing }
PharoPlotBar >> barStyle: anObject [
	barStyle := anObject
]

{ #category : #private }
PharoPlotBar >> barWidthOf: aRectangle [
	^ (aRectangle width / (self numPoints + 1) * self barWidthRatio) truncated
]

{ #category : #private }
PharoPlotBar >> barWidthRatio [
	^ 0.8
]

{ #category : #accessing }
PharoPlotBar >> bottom [
	^ bottom
]

{ #category : #accessing }
PharoPlotBar >> bottom: anArray [
	bottom := anArray
]

{ #category : #api }
PharoPlotBar >> draw: aBlock in: aRectangle on: aCanvas [
	| w |
	w := self barWidthOf: aRectangle.
	self points
		withIndexDo: [ :each :index | 
			| pos pos2 rect |
			pos := aBlock cull: each.
			pos2 := bottom
				ifNil: [ Array with: 0 with: aRectangle bottom ]
				ifNotNil: [ aBlock cull: each x @ (bottom at: index) ].
			((pos includes: nil) or: [ pos2 includes: nil ])
				ifFalse: [ rect := (pos first - (w // 2)) @ pos second
						corner: (pos first + (w // 2)) @ pos2 second.
					aCanvas fillRectangle: rect fillStyle: self barStyle ] ]
]

{ #category : #api }
PharoPlotBar >> drawLegendAt: aPoint font: aFont color: aColor on: aCanvas [
	| rect |
	rect := aPoint extent: self sampleLegendExtent.
	aCanvas fillRectangle: rect fillStyle: self barStyle.
	aCanvas
		drawString: self label
		at: aPoint + ((self sampleLegendExtent + 3) @ 0)
		font: aFont
		color: aColor
]

{ #category : #api }
PharoPlotBar >> legendExtentFont: aFont [
	^ self sampleLegendExtent + (3 @ 0)
		max: (aFont widthOfString: self label) @ aFont height
]

{ #category : #private }
PharoPlotBar >> sampleLegendExtent [
	^ 20 @ 10
]
