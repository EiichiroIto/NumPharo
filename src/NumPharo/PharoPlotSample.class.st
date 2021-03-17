Class {
	#name : #PharoPlotSample,
	#superclass : #Object,
	#category : #'NumPharo-Demo'
}

{ #category : #examples }
PharoPlotSample class >> example1 [
	| x y plt |
	x := NDArray arangeFrom: 0 to: 6 by: 0.1.
	y := x sin.
	plt := PharoPlot new.
	plt extent: 500 @ 200.
	plt plotX: x y: y label: 'sin'.
	plt plotX: x y: x cos label: 'cos'.
	plt title: 'sin & cos'.
	plt xLabel: 'x'.
	plt yLabel: 'y'.
	plt showLegend: true.
	plt show.
	^ plt
]

{ #category : #examples }
PharoPlotSample class >> example10 [
	| x y plt |
	x := NDArray arangeFrom: 1 to: 5 by: 1.
	y := x * 10.
	plt := PharoPlot new.
	plt extent: 300 @ 300.
	plt barX: x y: y label: 'a'.
	plt yLimitFrom: 0 to: nil.
	plt title: 'bar'.
	plt xLabel: 'x'.
	plt yLabel: 'y'.
	plt show.
	^ plt
]

{ #category : #examples }
PharoPlotSample class >> example11 [
	| x y z plt |
	x := NDArray arangeFrom: 1 to: 5 by: 1.
	y := x * 10.
	z := x * 20.
	plt := PharoPlot new.
	plt extent: 300 @ 300.
	plt barX: x y: y label: 'a'.
	plt barX: x y: z label: 'b'.
	plt bottom: y.
	plt yLimitFrom: 0 to: nil.
	plt title: 'bar'.
	plt xLabel: 'x'.
	plt yLabel: 'y'.
	plt show.
	^ plt
]

{ #category : #examples }
PharoPlotSample class >> example12 [
	| x y plt |
	x := NDArray
		linspaceFrom: 0
		to: 2 * Float pi
		num: 100
		withEndPoint: false.
	y := x sin.
	plt := PharoPlot new.
	plt plotX: x y: y label: ''.
	plt show
]

{ #category : #examples }
PharoPlotSample class >> example2 [
	| x y plt |
	x := NDArray arangeFrom: -5 to: 5 by: 0.1.
	y := self stepFunction: x.
	plt := PharoPlot new plotX: x y: y label: 'step'.
	plt yLimitFrom: -0.1 to: 1.1.
	plt showAxisX: true y: false.
	plt show.
	^ plt
]

{ #category : #examples }
PharoPlotSample class >> example3 [
	| x y plt |
	x := NDArray arangeFrom: -4 to: 4 by: 0.1.
	y := self stepFunction: x.
	plt := PharoPlot new plotX: x y: y label: 'step'.
	plt extent: 400 @ 200.
	plt plotX: x y: (self sigmoid: x) label: 'sigmoid'.
	plt plotX: x y: (self relu: x) label: 'relu'.
	plt yLimitFrom: -0.1 to: 1.1.
	plt showLegend: true.
	plt show.
	^ plt
]

{ #category : #examples }
PharoPlotSample class >> example4 [
	| p x y1 y2 |
	p := PharoPlot new.
	p xLabel: 'abc'.
	p yLabel: 'def'.
	p title: 'waiwa'.
	x := NDArray fromArray: #(-1 -0.5 0 0.5) dtype: #Float.
	y1 := NDArray fromArray: #(90 20 30 10) dtype: #Float.
	y2 := NDArray fromArray: #(-15 25 35 25) dtype: #Float.
	p plotX: x y: y1 label: 'a'.
	p plotX: x y: y2 label: 'b'.
	p extent: 400 @ 200.
	p show.
	^ p
]

{ #category : #examples }
PharoPlotSample class >> example5 [
	| p |
	p := PharoPlot new.
	p extent: 200 @ 100.
	p image: PolymorphSystemSettings pharoLogoForm.
	p show.
	^ p
]

{ #category : #examples }
PharoPlotSample class >> example6 [
	| p x y |
	p := PharoPlot new.
	p subPlotRow: 2 col: 1 index: 1.
	p extent: 400 @ 400.
	p image: PolymorphSystemSettings pharoLogoForm.
	p title: 'Pharo logo'.
	p subPlotRow: 2 col: 1 index: 2.
	x := NDArray arangeFrom: 0 to: 6 by: 0.1.
	y := x sin.
	p plotX: x y: y label: 'sin'.
	p plotX: x y: x cos label: 'cos'.
	p title: 'sin & cos'.
	p xLabel: 'x'.
	p yLabel: 'y'.
	p show.
	^ p
]

{ #category : #examples }
PharoPlotSample class >> example7 [
	| p mn |
	mn := MNistData new.
	p := PharoPlot new.
	p extent: 400 @ 400.
	1 to: 20 do: [ :each | 
		p subPlotRow: 4 col: 5 index: each.
		p image: (mn trainingImages at: each) asForm.
		p showAxisX: false y: false.
		p title: (mn trainingLabels at: each) ].
	p show.
	^ p
]

{ #category : #examples }
PharoPlotSample class >> example8 [
	| x y plt |
	x := NDArray linspaceFrom: 0 to: 1 num: 100 withEndPoint: true.
	y := x log.
	plt := PharoPlot new.
	plt extent: 200 @ 200.
	plt plotX: x y: y label: 'log'.
	plt yLimitFrom: -5 to: 0.
	plt title: 'log'.
	plt xLabel: 'x'.
	plt yLabel: 'y'.
	plt show.
	^ plt
]

{ #category : #examples }
PharoPlotSample class >> example9 [
	| x y plt |
	x := NDRandom randomUniform: 100.
	y := NDRandom randomUniform: 100.
	plt := PharoPlot new.
	plt extent: 300 @ 300.
	plt scatterX: x y: y label: 'a'.
	plt title: 'random'.
	plt xLabel: 'x'.
	plt yLabel: 'y'.
	plt markerStyle: $*.
	plt showLegend: true.
	plt show.
	^ plt
]

{ #category : #utilities }
PharoPlotSample class >> relu: x [
	^ x min: x max: 0
]

{ #category : #utilities }
PharoPlotSample class >> sigmoid: x [
	^ 1 / (1 + x negated exp)
]

{ #category : #utilities }
PharoPlotSample class >> stepFunction: x [
	^ (x > 0) withDtype: #Integer
]
