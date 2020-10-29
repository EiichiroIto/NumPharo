Class {
	#name : #PharoPlotGraphTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotGraphTest >> newPlot [
	^ PharoPlotGraph new
]

{ #category : #test }
PharoPlotGraphTest >> testClear [
	| m |
	m := self newPlot.
	self assert: m xRange isArray.
	self assert: m xRange size equals: 2.
	self assert: m yRange isArray.
	self assert: m yRange size equals: 2.
	self assert: m extent equals: m defaultExtent.
	self assert: m list isCollection.
	self assert: m list isEmpty
]

{ #category : #test }
PharoPlotGraphTest >> testColors [
	| g |
	g := self newPlot.
	self assert: g colors isArray
]

{ #category : #test }
PharoPlotGraphTest >> testHasPoints [
	| s obj |
	s := self newPlot.
	self deny: s hasPoints.
	obj := s newData.
	s addData: obj.
	obj points: { 1 @ 2 }.
	self assert: s hasPoints.
	obj points: #().
	self deny: s hasPoints
]

{ #category : #test }
PharoPlotGraphTest >> testList [
	| p |
	p := self newPlot.
	self assert: p list isCollection.
	self assert: p list isEmpty.
	p addXs: #(1) ys: #(2) label: 'test'.
	self assert: p list size equals: 1
]

{ #category : #test }
PharoPlotGraphTest >> testSetupFormContext [
	| p form dict |
	p := self newPlot.
	form := p baseForm.
	dict := Dictionary new.
	p setupForm: form context: dict.
	self assert: (dict includesKey: #canvas).
	self assert: (dict includesKey: #rectangle).
	self assert: (dict includesKey: #xRange).
	self assert: (dict includesKey: #xScales).
	self assert: (dict includesKey: #yRange).
	self assert: (dict includesKey: #yScales)
]

{ #category : #test }
PharoPlotGraphTest >> testShowLegend [
	| g |
	g := self newPlot.
	self deny: g showLegend.
	g showLegend: true.
	self assert: g showLegend
]
