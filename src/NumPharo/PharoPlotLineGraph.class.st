Class {
	#name : #PharoPlotLineGraph,
	#superclass : #PharoPlotGraph,
	#category : #'NumPharo-Plot'
}

{ #category : #testing }
PharoPlotLineGraph >> hasPoints [
	^ ((list collect: [ :each | each numPoints < 2 ])
		inject: true
		into: [ :p :e | p and: e ]) not
]

{ #category : #testing }
PharoPlotLineGraph >> isLineGraph [
	^ true
]

{ #category : #private }
PharoPlotLineGraph >> lineStylesFor: aColor [
	^ {(Array with: #(10) with: (Array with: aColor)).
	(Array
		with: #(5 5)
		with: (Array with: aColor with: Color transparent)).
	(Array
		with: #(7 3)
		with: (Array with: aColor with: Color transparent)).
	(Array
		with: #(3 2 3 2)
		with:
			(Array
				with: aColor
				with: Color transparent
				with: aColor
				with: Color transparent))}
]

{ #category : #private }
PharoPlotLineGraph >> newData [
	^ PharoPlotLine new
		lineStyle: self nextLineStyle;
		yourself
]

{ #category : #private }
PharoPlotLineGraph >> nextLineStyle [
	| pos color |
	pos := list size + 1.
	color := self colors atWrap: pos.
	^ (self lineStylesFor: color) atWrap: pos
]
