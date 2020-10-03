Class {
	#name : #PharoPlotImageTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotImageTest >> newImage [
	^ PharoPlotImage new
]

{ #category : #test }
PharoPlotImageTest >> testActualXRange [
	| i |
	i := self newImage.
	i image: (Form extent: 10 @ 20 depth: 32).
	self assert: i actualXRange equals: (0 to: 10)
]

{ #category : #test }
PharoPlotImageTest >> testActualYRange [
	| i |
	i := self newImage.
	i image: (Form extent: 10 @ 20 depth: 32).
	self assert: i actualYRange equals: (0 to: 20)
]

{ #category : #test }
PharoPlotImageTest >> testHasImage [
	| i |
	i := self newImage.
	self deny: i hasImage.
	i image: (Form extent: 10 @ 10 depth: 32).
	self assert: i hasImage
]

{ #category : #test }
PharoPlotImageTest >> testImage [
	| i f |
	i := self newImage.
	self assert: i image isNil.
	f := Form extent: 10 @ 10 depth: 32.
	i image: f.
	self assert: i image equals: f
]

{ #category : #test }
PharoPlotImageTest >> testImageExtentAndMagnification [
	| i dict f r |
	i := self newImage.
	dict := Dictionary new.
	dict at: #rectangle put: (10 @ 10 corner: 110 @ 220).
	self assert: (i imageExtentAndMagnification: dict) isNil.
	f := Form extent: 20 @ 30.
	i image: f.
	r := i imageExtentAndMagnification: dict.
	self assert: r second equals: 5.
	self assertCollection: r first equals: 100 @ 150
]

{ #category : #test }
PharoPlotImageTest >> testIsImage [
	| f |
	f := self newImage.
	self assert: f isImage
]

{ #category : #test }
PharoPlotImageTest >> testSetupFormContext [
	| p form dict |
	p := self newImage.
	form := p baseForm.
	dict := Dictionary new.
	p image: (Form extent: 20 @ 30).
	p setupForm: form context: dict.
	self assert: (dict includesKey: #canvas).
	self assert: (dict includesKey: #rectangle).
	self assert: (dict includesKey: #xRange).
	self assert: (dict includesKey: #xScales).
	self assert: (dict includesKey: #yRange).
	self assert: (dict includesKey: #yScales).
	self assert: (dict includesKey: #magnify)
]
