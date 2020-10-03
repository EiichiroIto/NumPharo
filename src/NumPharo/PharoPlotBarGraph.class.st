Class {
	#name : #PharoPlotBarGraph,
	#superclass : #PharoPlotGraph,
	#category : #'NumPharo-Plot'
}

{ #category : #api }
PharoPlotBarGraph >> bottom: anArray [
	list last bottom: anArray
]

{ #category : #testing }
PharoPlotBarGraph >> isBarGraph [
	^ true
]

{ #category : #private }
PharoPlotBarGraph >> newData [
	^ PharoPlotBar new
		barStyle: self nextBarStyle;
		yourself
]

{ #category : #private }
PharoPlotBarGraph >> nextBarStyle [
	^ self colors atWrap: list size + 1
]
