Class {
	#name : #GrayScott,
	#superclass : #Object,
	#instVars : [
		'u',
		'v',
		'f',
		'k',
		'grid',
		'square',
		'dx',
		'du',
		'dv',
		'dt'
	],
	#category : #'NumPharo-Demo'
}

{ #category : #examples }
GrayScott class >> example1 [
	| gs gif |
	gs := self new.
	gs
		grid: 256;
		square: 20.
	gs setup.
	gs
		f: 0.04;
		k: 0.06.
	gs
		dx: 0.01;
		dt: 1;
		du: 2e-5;
		dv: 1e-5.
	gif := PharoRecorder new openFileNamed: 'grayScott1.gif'.
	gif extent: 512 @ 512.
	500
		timesRepeat: [ gs loop.
			gif writeForm: gs form ].
	gif close
]

{ #category : #examples }
GrayScott class >> example2 [
	| gs gif |
	gs := self new.
	gs
		grid: 256;
		square: 20.
	gs setup.
	gs
		f: 0.035;
		k: 0.065.
	gs
		dx: 0.01;
		dt: 1;
		du: 2e-5;
		dv: 1e-5.
	gif := PharoRecorder new openFileNamed: 'grayScott2.gif'.
	gif frameDelay: 20.
	1000
		timesRepeat: [ gs loop.
			gif writeForm: gs form ].
	gif close
]

{ #category : #examples }
GrayScott class >> example3 [
	| gs gif |
	gs := self new.
	gs
		grid: 256;
		square: 20.
	gs setup.
	gs
		f: 0.012;
		k: 0.05.
	gs
		dx: 0.01;
		dt: 1;
		du: 2e-5;
		dv: 1e-5.
	gif := PharoRecorder new openFileNamed: 'grayScott3.gif'.
	gif frameDelay: 20.
	1000
		timesRepeat: [ gs loop.
			gif writeForm: gs form ].
	gif close
]

{ #category : #examples }
GrayScott class >> example4 [
	| gs gif |
	gs := self new.
	gs
		grid: 256;
		square: 20.
	gs setup.
	gs
		f: 0.022;
		k: 0.051.
	gs
		dx: 0.01;
		dt: 1;
		du: 2e-5;
		dv: 1e-5.
	gif := PharoRecorder new openFileNamed: 'grayScott4.gif'.
	gif frameDelay: 20.
	1000
		timesRepeat: [ gs loop.
			gif writeForm: gs form ].
	gif close
]

{ #category : #accessing }
GrayScott >> dt: aFloat [
	dt := aFloat
]

{ #category : #accessing }
GrayScott >> du: aFloat [
	du := aFloat
]

{ #category : #accessing }
GrayScott >> dv: aFloat [
	dv := aFloat
]

{ #category : #accessing }
GrayScott >> dx: aFloat [
	dx := aFloat
]

{ #category : #accessing }
GrayScott >> f [
	^ f
]

{ #category : #accessing }
GrayScott >> f: aFloat [
	f := aFloat
]

{ #category : #api }
GrayScott >> form [
	^ self formOf: u
]

{ #category : #private }
GrayScott >> formOf: aNDArray [
	| bitmap |
	bitmap := Bitmap newFrom: (aNDArray asFlatArray collect: [ :each | (Color gray: each) pixelValueForDepth: 32 ]).
	^ Form extent: aNDArray extent depth: 32 bits: bitmap
]

{ #category : #accessing }
GrayScott >> grid [
	^ grid
]

{ #category : #accessing }
GrayScott >> grid: anInteger [
	grid := anInteger
]

{ #category : #accessing }
GrayScott >> k [
	^ k
]

{ #category : #accessing }
GrayScott >> k: aFloat [
	k := aFloat
]

{ #category : #private }
GrayScott >> laplacian: aNDArray withDx: aFloat [
	| laplacian |
	laplacian := (aNDArray roll: 1 axes: 1) + (aNDArray roll: -1 axes: 1)
		+ (aNDArray roll: 1 axes: 2) + (aNDArray roll: -1 axes: 2)
		- (4 * aNDArray).
	^ laplacian / (aFloat * aFloat)
]

{ #category : #api }
GrayScott >> loop [
	| laplacianU laplacianV dudt dvdt |
	8
		timesRepeat: [ laplacianU := self laplacian: u withDx: dx.
			laplacianV := self laplacian: v withDx: dx.
			dudt := du * laplacianU - (u * v * v) + (f * (1.0 - u)).
			dvdt := dv * laplacianV + (u * v * v) - ((f + k) * v).
			u := u + (dt * dudt).
			v := v + (dt * dvdt) ]
]

{ #category : #api }
GrayScott >> setup [
	| shape |
	shape := Array with: grid with: grid.
	u := NDArray ones: shape.
	v := NDArray zeros: shape.
	u
		atAll:
			{(grid // 2 - (square // 2) to: grid // 2 + (square // 2)).
			(grid // 2 - (square // 2) to: grid // 2 + (square // 2))} comprehension
		put: 0.5.
	v
		atAll:
			{(grid // 2 - (square // 2) to: grid // 2 + (square // 2)).
			(grid // 2 - (square // 2) to: grid // 2 + (square // 2))} comprehension
		put: 0.25.
	u := (u + ((NDArray random: shape) * 0.1)) minimum: 1.
	v := (v + ((NDArray random: shape) * 0.1)) minimum: 1
]

{ #category : #accessing }
GrayScott >> square [
	^ square
]

{ #category : #accessing }
GrayScott >> square: anInteger [
	square := anInteger
]

{ #category : #accessing }
GrayScott >> u [
	^ u
]

{ #category : #accessing }
GrayScott >> v [
	^ v
]
