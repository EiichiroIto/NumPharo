"
A PharoPlotLineTest is a test class for testing the behavior of PharoPlotLine
"
Class {
	#name : #PharoPlotLineTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotLineTest >> newData [
	^ PharoPlotLine new
]

{ #category : #test }
PharoPlotLineTest >> testLineStyle [
	| d a |
	d := self newData.
	self assert: d lineStyle isNil.
	a := Array with: Color red with: #().
	d lineStyle: a.
	self assert: d lineStyle equals: a
]
