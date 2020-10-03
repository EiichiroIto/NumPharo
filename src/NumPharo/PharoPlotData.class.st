Class {
	#name : #PharoPlotData,
	#superclass : #Object,
	#instVars : [
		'points',
		'label'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #api }
PharoPlotData >> draw: aBlock in: aRectangle on: aCanvas [
	self subclassResponsibility
]

{ #category : #api }
PharoPlotData >> drawLegendAt: aPoint font: aFont color: aColor on: aCanvas [
	self subclassResponsibility
]

{ #category : #testing }
PharoPlotData >> hasPoints [
	^ points notNil and: [ points notEmpty ]
]

{ #category : #accessing }
PharoPlotData >> label [
	^ label
]

{ #category : #accessing }
PharoPlotData >> label: anObject [
	label := anObject
]

{ #category : #api }
PharoPlotData >> legendExtentFont: aFont [
	self subclassResponsibility
]

{ #category : #api }
PharoPlotData >> numPoints [
	points
		ifNil: [ ^ 0 ].
	^ points size
]

{ #category : #accessing }
PharoPlotData >> points [
	^ points
]

{ #category : #accessing }
PharoPlotData >> points: anObject [
	points := anObject
]

{ #category : #private }
PharoPlotData >> xMax [
	^ (points collect: #x) max
]

{ #category : #private }
PharoPlotData >> xMin [
	^ (points collect: #x) min
]

{ #category : #private }
PharoPlotData >> yMax [
	^ (points collect: #y) max
]

{ #category : #private }
PharoPlotData >> yMin [
	^ (points collect: #y) min
]
