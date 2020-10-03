Class {
	#name : #PharoPlotScatterGraph,
	#superclass : #PharoPlotGraph,
	#category : #'NumPharo-Plot'
}

{ #category : #private }
PharoPlotScatterGraph >> defaultMarkerSize [
	^ 10
]

{ #category : #testing }
PharoPlotScatterGraph >> isScatterGraph [
	^ true
]

{ #category : #api }
PharoPlotScatterGraph >> markerColor: aColor [
	list last markerColor: aColor
]

{ #category : #api }
PharoPlotScatterGraph >> markerSize: aPoint [
	list last markerSize: aPoint
]

{ #category : #api }
PharoPlotScatterGraph >> markerStyle: aCharacter [
	list last markerStyle: aCharacter
]

{ #category : #private }
PharoPlotScatterGraph >> markerStyles [
	^ 'ox*'
]

{ #category : #private }
PharoPlotScatterGraph >> newData [
	^ PharoPlotScatter new
		markerSize: self defaultMarkerSize;
		markerColor: self nextColor;
		markerStyle: self nextStyle;
		yourself
]

{ #category : #private }
PharoPlotScatterGraph >> nextColor [
	^ self colors atWrap: list size + 1
]

{ #category : #private }
PharoPlotScatterGraph >> nextStyle [
	^ self markerStyles atWrap: list size + 1
]
