Class {
	#name : #PharoPlotScatterTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotScatterTest >> newData [
	^ PharoPlotScatter new
]

{ #category : #test }
PharoPlotScatterTest >> testMarkerColor [
	| s |
	s := self newData.
	self assert: s markerColor isNil.
	s markerColor: Color black.
	self assert: s markerColor equals: Color black
]

{ #category : #test }
PharoPlotScatterTest >> testMarkerForm [
	| s |
	s := self newData.
	s markerSize: 10.
	s markerStyle: $o.
	s markerColor: Color red.
	self assert: s markerForm isForm
]

{ #category : #test }
PharoPlotScatterTest >> testMarkerSize [
	| s |
	s := self newData.
	self assert: s markerSize isNil.
	s markerSize: 10 @ 20.
	self assert: s markerSize equals: 10 @ 20
]

{ #category : #test }
PharoPlotScatterTest >> testMarkerStyle [
	| s |
	s := self newData.
	self assert: s markerStyle isNil.
	s markerStyle: $o.
	self assert: s markerStyle equals: $o
]
