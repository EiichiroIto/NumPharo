Class {
	#name : #PharoPlot,
	#superclass : #Object,
	#instVars : [
		'current',
		'rows',
		'cols',
		'subPlots',
		'extent'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #private }
PharoPlot >> assureSubPlots [
	current ifNotNil: [ ^ self ].
	self setupSubPlots
]

{ #category : #api }
PharoPlot >> barX: aNdArray1 y: aNdArray2 label: aString [
	self assureSubPlots.
	current isBarGraph
		ifFalse: [ self replaceBy: self newBarGraph ].
	current addXs: aNdArray1 array ys: aNdArray2 array label: aString
]

{ #category : #api }
PharoPlot >> bottom: aNDArray [
	current bottom: aNDArray array
]

{ #category : #private }
PharoPlot >> buildForm [
	| form canvas p f |
	form := Form extent: self extent depth: 32.
	subPlots ifNil: [ ^ form fillColor: Color white ].
	canvas := FormCanvas on: form.
	subPlots
		withIndexDo: [ :each :index | 
			p := self positionAt: index.
			f := (self subPlotAt: index) form.
			canvas drawImage: f at: p ].
	^ form
]

{ #category : #api }
PharoPlot >> clear [
	rows := 1.
	cols := 1.
	subPlots := current := nil
]

{ #category : #accessing }
PharoPlot >> cols [
	^ cols
]

{ #category : #accessing }
PharoPlot >> cols: anInteger [
	cols := anInteger
]

{ #category : #accessing }
PharoPlot >> current [
	^ current
]

{ #category : #private }
PharoPlot >> defaultExtent [
	^ 200 @ 200
]

{ #category : #accessing }
PharoPlot >> extent [
	^ extent
]

{ #category : #accessing }
PharoPlot >> extent: aPoint [
	extent := aPoint.
	self updateSubPlotsExtent
]

{ #category : #api }
PharoPlot >> histValues: anArray bin: anInteger from: aNumber1 to: aNumber2 [
	self shouldBeImplemented
]

{ #category : #api }
PharoPlot >> image: aForm [
	self assureSubPlots.
	current isImage
		ifFalse: [ self replaceBy: self newImage ].
	current image: aForm
]

{ #category : #initialization }
PharoPlot >> initialize [
	self extent: self defaultExtent.
	self clear
]

{ #category : #api }
PharoPlot >> markerColor: aColor [
	current markerColor: aColor
]

{ #category : #api }
PharoPlot >> markerSize: aPoint [
	current markerSize: aPoint
]

{ #category : #api }
PharoPlot >> markerStyle: aCharacter [
	current markerStyle: aCharacter
]

{ #category : #private }
PharoPlot >> newBarGraph [
	^ PharoPlotBarGraph new
]

{ #category : #private }
PharoPlot >> newImage [
	^ PharoPlotImage new
]

{ #category : #private }
PharoPlot >> newLineGraph [
	^ PharoPlotLineGraph new
]

{ #category : #private }
PharoPlot >> newScatterGraph [
	^ PharoPlotScatterGraph new
]

{ #category : #api }
PharoPlot >> plotX: aNdArray1 y: aNdArray2 label: aString [
	self assureSubPlots.
	current isLineGraph
		ifFalse: [ self replaceBy: self newLineGraph ].
	current addXs: aNdArray1 array ys: aNdArray2 array label: aString
]

{ #category : #private }
PharoPlot >> positionAt: anInteger [
	| size x y |
	size := self subPlotExtent.
	x := (anInteger - 1) \\ self cols * size x.
	y := (anInteger - 1) // self cols * size y.
	^ x @ y
]

{ #category : #private }
PharoPlot >> replaceBy: aFigure [
	| index subExtent |
	subExtent := current extent.
	index := subPlots indexOf: current.
	current := aFigure.
	current extent: subExtent.
	subPlots at: index put: current
]

{ #category : #accessing }
PharoPlot >> rows [
	^ rows
]

{ #category : #accessing }
PharoPlot >> rows: anInteger [
	rows := anInteger
]

{ #category : #api }
PharoPlot >> scatterX: aNdArray1 y: aNdArray2 label: aString [
	self assureSubPlots.
	current isScatterGraph
		ifFalse: [ self replaceBy: self newScatterGraph ].
	current addXs: aNdArray1 array ys: aNdArray2 array label: aString
]

{ #category : #private }
PharoPlot >> setupSubPlots [
	subPlots := (1 to: rows * cols) collect: [ :each | self newLineGraph ].
	current := subPlots first.
	self updateSubPlotsExtent
]

{ #category : #api }
PharoPlot >> show [
	^ SpImagePresenter new
		image: self buildForm;
		autoScale: true;
		openWithSpec
]

{ #category : #api }
PharoPlot >> showAxisX: aBoolean1 y: aBoolean2 [
	self assureSubPlots.
	current showAxis: (Array with: aBoolean1 with: aBoolean2)
]

{ #category : #api }
PharoPlot >> showLegend: aBoolean [
	self assureSubPlots.
	current showLegend: aBoolean
]

{ #category : #accessing }
PharoPlot >> subPlotAt: anInteger [
	^ subPlots at: anInteger
]

{ #category : #private }
PharoPlot >> subPlotExtent [
	^ self extent // (cols @ rows)
]

{ #category : #api }
PharoPlot >> subPlotRow: anInteger1 col: anInteger2 index: anInteger3 [
	current
		ifNil: [ rows := anInteger1.
			cols := anInteger2.
			self setupSubPlots ]
		ifNotNil: [ (rows ~= anInteger1 or: [ cols ~= anInteger2 ])
				ifTrue: [ self error ] ].
	current := subPlots at: anInteger3
]

{ #category : #accessing }
PharoPlot >> subPlots [
	^ subPlots
]

{ #category : #api }
PharoPlot >> title: aString [
	self assureSubPlots.
	current title: aString asString
]

{ #category : #private }
PharoPlot >> updateSubPlotsExtent [
	subPlots ifNil: [ ^ self ].
	subPlots do: [ :each | each extent: self subPlotExtent ]
]

{ #category : #api }
PharoPlot >> xLabel: aString [
	self assureSubPlots.
	current xLabel: aString asString
]

{ #category : #api }
PharoPlot >> xLimitFrom: from to: to [
	self assureSubPlots.
	current xRange: (Array with: from with: to)
]

{ #category : #api }
PharoPlot >> yLabel: aString [
	self assureSubPlots.
	current yLabel: aString asString
]

{ #category : #api }
PharoPlot >> yLimitFrom: from to: to [
	self assureSubPlots.
	current yRange: (Array with: from with: to)
]
