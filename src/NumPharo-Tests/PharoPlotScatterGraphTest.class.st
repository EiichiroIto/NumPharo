"
A PharoPlotScatterGraphTest is a test class for testing the behavior of PharoPlotScatterGraph
"
Class {
	#name : #PharoPlotScatterGraphTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotScatterGraphTest >> newScatter [
	^ PharoPlotScatterGraph new
]

{ #category : #test }
PharoPlotScatterGraphTest >> testDefaultMarkerSize [
	| s |
	s := self newScatter.
	self assert: s defaultMarkerSize isInteger
]

{ #category : #test }
PharoPlotScatterGraphTest >> testIsScatterGraph [
	| f |
	f := self newScatter.
	self assert: f isScatterGraph
]

{ #category : #test }
PharoPlotScatterGraphTest >> testMarkerStyles [
	| s |
	s := self newScatter.
	self assert: s markerStyles isString
]

{ #category : #test }
PharoPlotScatterGraphTest >> testNewData [
	| d |
	d := self newScatter.
	self assert: (d newData isKindOf: PharoPlotScatter)
]

{ #category : #test }
PharoPlotScatterGraphTest >> testNextColor [
	| s |
	s := self newScatter.
	self assert: s nextColor isColor
]

{ #category : #test }
PharoPlotScatterGraphTest >> testNextStyle [
	| s |
	s := self newScatter.
	self assert: s nextStyle isCharacter
]
