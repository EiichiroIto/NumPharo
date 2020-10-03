"
A PharoPlotMorphTest is a test class for testing the behavior of PharoPlotMorph
"
Class {
	#name : #PharoPlotTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
PharoPlotTest >> newPlot [
	^ PharoPlot new
]

{ #category : #test }
PharoPlotTest >> testAssureSubPlots [
	| p |
	p := self newPlot.
	self assert: p subPlots isNil.
	self assert: p current isNil.
	p assureSubPlots.
	self assert: p subPlots size equals: 1.
	self assert: p current isLineGraph
]

{ #category : #test }
PharoPlotTest >> testBuildForm [
	| p |
	p := self newPlot.
	self assert: p buildForm isForm.
	p cols: 2.
	p rows: 3.
	p setupSubPlots.
	self assert: p buildForm isForm
]

{ #category : #test }
PharoPlotTest >> testClear [
	| p |
	p := self newPlot.
	self assert: p rows equals: 1.
	self assert: p cols equals: 1.
	self assert: p subPlots isNil.
	self assert: p current isNil
]

{ #category : #test }
PharoPlotTest >> testCols [
	| p |
	p := self newPlot.
	self assert: p cols equals: 1.
	p
		plotX: (NDArray zeros: #(1))
		y: (NDArray zeros: #(1))
		label: 'abc'.
	self assert: p cols equals: 1.
	p cols: 9.
	self assert: p cols equals: 9.
	p := self newPlot.
	p subPlotRow: 5 col: 2 index: 1.
	self assert: p cols equals: 2
]

{ #category : #test }
PharoPlotTest >> testCurrent [
	| p |
	p := self newPlot.
	self assert: p current isNil.
	p
		plotX: (NDArray zeros: #(1))
		y: (NDArray zeros: #(1))
		label: 'abc'.
	self assert: p current notNil
]

{ #category : #test }
PharoPlotTest >> testDefaultExtent [
	| p |
	p := self newPlot.
	self assert: p defaultExtent isPoint
]

{ #category : #test }
PharoPlotTest >> testExtent [
	| p |
	p := self newPlot.
	self assert: p extent equals: p defaultExtent.
	p extent: 10 @ 20.
	self assert: p extent equals: 10 @ 20
]

{ #category : #test }
PharoPlotTest >> testInitialize [
	self testExtent.
	self testClear
]

{ #category : #test }
PharoPlotTest >> testNewImage [
	| p |
	p := self newPlot.
	self assert: (p newImage isKindOf: PharoPlotImage)
]

{ #category : #test }
PharoPlotTest >> testNewLineGraph [
	| p |
	p := self newPlot.
	self assert: (p newLineGraph isKindOf: PharoPlotLineGraph)
]

{ #category : #test }
PharoPlotTest >> testNewScatterGraph [
	| p |
	p := self newPlot.
	self assert: (p newScatterGraph isKindOf: PharoPlotScatterGraph)
]

{ #category : #test }
PharoPlotTest >> testPositionAt [
	| p |
	p := self newPlot.
	p extent: 30 @ 40.
	p cols: 5.
	p rows: 4.
	self assert: (p positionAt: 1) equals: 0 @ 0.
	self assert: (p positionAt: 2) equals: 6 @ 0.
	self assert: (p positionAt: 3) equals: 12 @ 0.
	self assert: (p positionAt: 4) equals: 18 @ 0.
	self assert: (p positionAt: 5) equals: 24 @ 0.
	self assert: (p positionAt: 6) equals: 0 @ 10
]

{ #category : #test }
PharoPlotTest >> testReplaceBy [
	| p |
	p := self newPlot.
	p setupSubPlots.
	self assert: (p subPlotAt: 1) isLineGraph.
	p replaceBy: p newImage.
	self assert: (p subPlotAt: 1) isImage
]

{ #category : #test }
PharoPlotTest >> testRows [
	| p |
	p := self newPlot.
	self assert: p rows equals: 1.
	p
		plotX: (NDArray zeros: #(1))
		y: (NDArray zeros: #(1))
		label: 'abc'.
	self assert: p rows equals: 1.
	p rows: 9.
	self assert: p rows equals: 9.
	p := self newPlot.
	p subPlotRow: 5 col: 2 index: 1.
	self assert: p rows equals: 5
]

{ #category : #test }
PharoPlotTest >> testSetupSubPlots [
	| p |
	p := self newPlot.
	p rows: 5.
	p cols: 3.
	p setupSubPlots.
	self assert: p subPlots size equals: 15.
	p subPlots
		do: [ :each | 
			self assert: each isLineGraph.
			self assert: each extent equals: p subPlotExtent ].
	self assert: p current equals: p subPlots first
]

{ #category : #test }
PharoPlotTest >> testShowAxisXY [
	| p |
	p := self newPlot.
	p assureSubPlots.
	self assert: p current showXAxis.
	self assert: p current showYAxis.
	p showAxisX: true y: false.
	self assert: p current showXAxis.
	self deny: p current showYAxis.
	p showAxisX: false y: true.
	self deny: p current showXAxis.
	self assert: p current showYAxis
]

{ #category : #test }
PharoPlotTest >> testShowLegend [
	| p |
	p := self newPlot.
	p assureSubPlots.
	self deny: p current showLegend.
	p showLegend: true.
	self assert: p current showLegend
]

{ #category : #test }
PharoPlotTest >> testSubPlotAt [
	| p |
	p := self newPlot.
	p cols: 2.
	p rows: 1.
	p setupSubPlots.
	self assert: (p subPlotAt: 1) equals: p subPlots first.
	self assert: (p subPlotAt: 2) equals: p subPlots last.
	self should: [p subPlotAt: 3] raise: Error
]

{ #category : #test }
PharoPlotTest >> testSubPlotExtent [
	| p |
	p := self newPlot.
	p cols: 3.
	p rows: 5.
	p extent: 300 @ 100.
	self assert: p subPlotExtent equals: 100 @ 20.
	p extent: 60 @ 50.
	self assert: p subPlotExtent equals: 20 @ 10
]

{ #category : #test }
PharoPlotTest >> testSubPlotRowColIndex [
	| p |
	p := self newPlot.
	self assert: p rows equals: 1.
	self assert: p cols equals: 1.
	p subPlotRow: 3 col: 4 index: 1.
	self assert: p rows equals: 3.
	self assert: p cols equals: 4.
	self assert: p current equals: (p subPlotAt: 1).
	p subPlotRow: 3 col: 4 index: 5.
	self assert: p rows equals: 3.
	self assert: p cols equals: 4.
	self assert: p current equals: (p subPlotAt: 5).
	self should: [ p subPlotRow: 3 col: 4 index: 100 ] raise: Error.
	self should: [ p subPlotRow: 1 col: 1 index: 1 ] raise: Error
]

{ #category : #test }
PharoPlotTest >> testSubPlots [
	| p |
	p := self newPlot.
	p rows: 5.
	p cols: 3.
	p setupSubPlots.
	self assert: p subPlots size equals: 15
]

{ #category : #test }
PharoPlotTest >> testTitle [
	| p |
	p := self newPlot.
	p subPlotRow: 2 col: 1 index: 1.
	p title: 'abc'.
	p subPlotRow: 2 col: 1 index: 2.
	p title: 'def'.
	self assert: (p subPlotAt: 1) title equals: 'abc'.
	self assert: (p subPlotAt: 2) title equals: 'def'
]

{ #category : #test }
PharoPlotTest >> testXLabel [
	| p |
	p := self newPlot.
	p subPlotRow: 2 col: 1 index: 1.
	p xLabel: 'abc'.
	p subPlotRow: 2 col: 1 index: 2.
	p xLabel: 'def'.
	self assert: (p subPlotAt: 1) xLabel equals: 'abc'.
	self assert: (p subPlotAt: 2) xLabel equals: 'def'
]

{ #category : #test }
PharoPlotTest >> testXLimitFromTo [
	| p |
	p := self newPlot.
	p subPlotRow: 2 col: 1 index: 1.
	p xLimitFrom: 1 to: 2.
	p subPlotRow: 2 col: 1 index: 2.
	p xLimitFrom: 3 to: 4.
	self assertCollection: (p subPlotAt: 1) xRange equals: #(1 2).
	self assertCollection: (p subPlotAt: 2) xRange equals: #(3 4)
]

{ #category : #test }
PharoPlotTest >> testYLabel [
	| p |
	p := self newPlot.
	p subPlotRow: 2 col: 1 index: 1.
	p yLabel: 'abc'.
	p subPlotRow: 2 col: 1 index: 2.
	p yLabel: 'def'.
	self assert: (p subPlotAt: 1) yLabel equals: 'abc'.
	self assert: (p subPlotAt: 2) yLabel equals: 'def'
]

{ #category : #test }
PharoPlotTest >> testYLimitFromTo [
	| p |
	p := self newPlot.
	p subPlotRow: 2 col: 1 index: 1.
	p yLimitFrom: 1 to: 2.
	p subPlotRow: 2 col: 1 index: 2.
	p yLimitFrom: 3 to: 4.
	self assertCollection: (p subPlotAt: 1) yRange equals: #(1 2).
	self assertCollection: (p subPlotAt: 2) yRange equals: #(3 4)
]
