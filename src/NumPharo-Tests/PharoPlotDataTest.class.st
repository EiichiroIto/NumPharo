Class {
	#name : #PharoPlotDataTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotDataTest >> newData [
	^ PharoPlotData new
]

{ #category : #test }
PharoPlotDataTest >> testHasPoints [
	| d |
	d := self newData.
	self deny: d hasPoints.
	d points: #().
	self deny: d hasPoints.
	d points: #(1 2 3).
	self assert: d hasPoints
]

{ #category : #test }
PharoPlotDataTest >> testLabel [
	| d |
	d := self newData.
	self assert: d label isNil.
	d label: 'abc'.
	self assert: d label equals: 'abc'
]

{ #category : #test }
PharoPlotDataTest >> testNumPoints [
	| d |
	d := self newData.
	self assert: d numPoints equals: 0.
	d points: #().
	self assert: d numPoints equals: 0.
	d points: #(1 2 3).
	self assert: d numPoints equals: 3
]

{ #category : #test }
PharoPlotDataTest >> testPoints [
	| s |
	s := self newData.
	self assert: s points isNil.
	s points: { 1 @ 2 }.
	self assertCollection: s points equals: { 1 @ 2 }
]

{ #category : #test }
PharoPlotDataTest >> testXMax [
	| s |
	s := self newData.
	self should: [ s xMax ] raise: Error.
	s points: { 1 @ 2. 3 @ 4 }.
	self assert: s xMax equals: 3
]

{ #category : #test }
PharoPlotDataTest >> testXMin [
	| s |
	s := self newData.
	self should: [ s xMin ] raise: Error.
	s points: { 1 @ 2. 3 @ 4 }.
	self assert: s xMin equals: 1
]

{ #category : #test }
PharoPlotDataTest >> testYMax [
	| s |
	s := self newData.
	self should: [ s yMax ] raise: Error.
	s points: { 1 @ 2. 3 @ 4 }.
	self assert: s yMax equals: 4
]

{ #category : #test }
PharoPlotDataTest >> testYMin [
	| s |
	s := self newData.
	self should: [ s yMin ] raise: Error.
	s points: { 1 @ 2. 3 @ 4 }.
	self assert: s yMin equals: 2
]
