Class {
	#name : #PharoPlotFigureTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotFigureTest >> newFigure [
	^ PharoPlotFigure new
]

{ #category : #test }
PharoPlotFigureTest >> testAxisColor [
	| f |
	f := self newFigure.
	self assert: f axisColor isColor
]

{ #category : #test }
PharoPlotFigureTest >> testBackgroundColor [
	| f |
	f := self newFigure.
	self assert: f backgroundColor isColor
]

{ #category : #test }
PharoPlotFigureTest >> testBaseForm [
	| p f |
	p := self newFigure.
	f := p baseForm.
	self assert: f isForm.
	self assert: f extent equals: p extent
]

{ #category : #test }
PharoPlotFigureTest >> testClear [
	| f |
	f := self newFigure.
	f title: 'abc'.
	f xLabel: 'def'.
	f yLabel: 'ghi'.
	f extent: 10 @ 10.
	self assert: f title equals: 'abc'.
	self assert: f xLabel equals: 'def'.
	self assert: f yLabel equals: 'ghi'.
	self assert: f extent equals: 10 @ 10.
	f clear.
	self assert: f title isNil.
	self assert: f xLabel isNil.
	self assert: f yLabel isNil.
	self assert: f extent equals: f defaultExtent
]

{ #category : #test }
PharoPlotFigureTest >> testDefaultDepth [
	| f |
	f := self newFigure.
	self assert: f defaultDepth equals: 32
]

{ #category : #test }
PharoPlotFigureTest >> testDefaultExtent [
	| f |
	f := self newFigure.
	self assert: f defaultExtent isPoint
]

{ #category : #test }
PharoPlotFigureTest >> testExpandRange [
	| f r |
	f := self newFigure.
	r := f expandRange: (100 to: 200).
	self assert: r equals: (95 to: 205)
]

{ #category : #test }
PharoPlotFigureTest >> testExtent [
	| f |
	f := self newFigure.
	self assert: f extent equals: f defaultExtent.
	f extent: 100 @ 200.
	self assert: f extent equals: 100 @ 200
]

{ #category : #test }
PharoPlotFigureTest >> testGridSizeOf [
	| f r |
	f := self newFigure.
	r := f gridSizeOf: (1 to: 2).
	self assert: r equals: 0.2.
	r := f gridSizeOf: (1 to: 10).
	self assert: r equals: 2.
	r := f gridSizeOf: (100 to: 1000).
	self assert: r equals: 200.
	r := f gridSizeOf: (-1 to: 1).
	self assert: r equals: 0.4
]

{ #category : #test }
PharoPlotFigureTest >> testHasTitle [
	| f |
	f := self newFigure.
	self deny: f hasTitle.
	f title: 'test'.
	self assert: f hasTitle
]

{ #category : #test }
PharoPlotFigureTest >> testHasXLabel [
	| f |
	f := self newFigure.
	self deny: f hasXLabel.
	f xLabel: 'test'.
	self assert: f hasXLabel
]

{ #category : #test }
PharoPlotFigureTest >> testHasYLabel [
	| f |
	f := self newFigure.
	self deny: f hasYLabel.
	f yLabel: 'test'.
	self assert: f hasYLabel
]

{ #category : #test }
PharoPlotFigureTest >> testIsBarGraph [
	| p |
	p := self newFigure.
	self deny: p isBarGraph
]

{ #category : #test }
PharoPlotFigureTest >> testIsImage [
	| f |
	f := self newFigure.
	self deny: f isImage
]

{ #category : #test }
PharoPlotFigureTest >> testIsLineGraph [
	| f |
	f := self newFigure.
	self deny: f isLineGraph
]

{ #category : #test }
PharoPlotFigureTest >> testIsScatterGraph [
	| f |
	f := self newFigure.
	self deny: f isScatterGraph
]

{ #category : #test }
PharoPlotFigureTest >> testLabelColor [
	| f |
	f := self newFigure.
	self assert: f labelColor isColor
]

{ #category : #test }
PharoPlotFigureTest >> testLabelFont [
	| f |
	f := self newFigure.
	self assert: (f labelFont isKindOf: LogicalFont)
]

{ #category : #test }
PharoPlotFigureTest >> testPositionOfInRangeFromTo [
	| p r |
	p := self newFigure.
	r := p positionOf: 1 inRange: (1 to: 5) from: 100 to: 500.
	self assert: r equals: 100.
	r := p positionOf: 5 inRange: (1 to: 5) from: 100 to: 500.
	self assert: r equals: 500.
	r := p positionOf: 0 inRange: (1 to: 5) from: 100 to: 500.
	self assert: r equals: nil.
	r := p positionOf: 6 inRange: (1 to: 5) from: 100 to: 500.
	self assert: r equals: nil.
	r := p positionOf: 3 inRange: (1 to: 5) from: 100 to: 500.
	self assert: r equals: 300
]

{ #category : #test }
PharoPlotFigureTest >> testShowAxis [
	| f |
	f := self newFigure.
	self assertCollection: f showAxis equals: #(true true).
	f showAxis: #(false true).
	self assertCollection: f showAxis equals: #(false true).
	f showAxis: #(true false).
	self assertCollection: f showAxis equals: #(true false)
]

{ #category : #test }
PharoPlotFigureTest >> testShowXAxis [
	| f |
	f := self newFigure.
	self assert: f showXAxis.
	f showAxis: #(false true).
	self deny: f showXAxis
]

{ #category : #test }
PharoPlotFigureTest >> testShowYAxis [
	| f |
	f := self newFigure.
	self assert: f showYAxis.
	f showAxis: #(true false).
	self deny: f showYAxis
]

{ #category : #test }
PharoPlotFigureTest >> testTitle [
	| f |
	f := self newFigure.
	self assert: f title isNil.
	f title: 'test'.
	self assert: f title equals: 'test'
]

{ #category : #test }
PharoPlotFigureTest >> testXLabel [
	| f |
	f := self newFigure.
	self assert: f xLabel isNil.
	f xLabel: 'test'.
	self assert: f xLabel equals: 'test'
]

{ #category : #test }
PharoPlotFigureTest >> testYLabel [
	| f |
	f := self newFigure.
	self assert: f yLabel isNil.
	f yLabel: 'test'.
	self assert: f yLabel equals: 'test'
]
