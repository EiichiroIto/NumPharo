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

{ #category : #'instance creation' }
GrayScott class >> amorphous [
	^ self 	f: 0.04 k: 0.06
]

{ #category : #'instance creation' }
GrayScott class >> bubbles [
	^ self f: 0.012 k: 0.05
]

{ #category : #examples }
GrayScott class >> example1 [
	| gif |
	gif := AnimatedGifRecorder new
		openFileNamed: 'grayScott-amorphous.gif'.
	gif extent: 512 @ 512.
	self amorphous
		do: [ :gs | gif writeForm: gs form ]
		times: 1000
		showing: 'amorphous'.
	gif close
]

{ #category : #examples }
GrayScott class >> example2 [
	| gif |
	gif := AnimatedGifRecorder new openFileNamed: 'grayScott-spot.gif'.
	gif extent: 512 @ 512.
	gif frameDelay: 20.
	self spot
		do: [ :gs | gif writeForm: gs form ]
		times: 1000
		showing: 'spot'.
	gif close
]

{ #category : #examples }
GrayScott class >> example3 [
	| gif |
	gif := AnimatedGifRecorder new openFileNamed: 'grayScott-bubbles.gif'.
	gif extent: 512 @ 512.
	self bubbles
		do: [ :gs | gif writeForm: gs form ]
		times: 1000
		showing: 'bubbles'.
	gif close
]

{ #category : #examples }
GrayScott class >> example4 [
	| gif |
	gif := AnimatedGifRecorder new openFileNamed: 'grayScott-stripe.gif'.
	gif extent: 512 @ 512.
	gif frameDelay: 20.
	self stripe
		do: [ :gs | gif writeForm: gs form ]
		times: 1000
		showing: 'stripe'.
	gif close
]

{ #category : #examples }
GrayScott class >> example5 [
	| gif |
	gif := AnimatedGifRecorder new openFileNamed: 'grayScott-waves.gif'.
	gif extent: 512 @ 512.
	gif frameDelay: 20.
	self waves
		do: [ :gs | gif writeForm: gs form ]
		times: 1000
		showing: 'waves'.
	gif close
]

{ #category : #private }
GrayScott class >> f: aFloat k: aFloat2 [
	^ self new
		setDefaultParameters;
		grid: 256;
		square: 20;
		setup;
		f: aFloat;
		k: aFloat2;
		yourself
]

{ #category : #'instance creation' }
GrayScott class >> spot [
	^ self f: 0.035 k: 0.065
]

{ #category : #'instance creation' }
GrayScott class >> stripe [
	^ self f: 0.04 k: 0.06
]

{ #category : #'instance creation' }
GrayScott class >> waves [
	^ self f: 0.025 k: 0.05
]

{ #category : #api }
GrayScott >> do: aBlock times: anInteger showing: aString [
	aString
		displayProgressFrom: 0
		to: anInteger
		during: [ :bar | 
			1 to: anInteger do: [ :each | 
				bar value: each.
				self loop.
				aBlock value: self ] ]
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
	bitmap := Bitmap newFrom: (aNDArray asFlatArray collect: [ :each | (Color gray: (each min: 1 max: 0)) pixelValueForDepth: 32 ]).
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
GrayScott >> setDefaultParameters [
	self
		dx: 0.01;
		dt: 1;
		du: 2e-5;
		dv: 1e-5
]

{ #category : #api }
GrayScott >> setup [
	| shape |
	shape := Array with: grid with: grid.
	u := NDArray ones: shape dtype: #Float.
	v := NDArray zeros: shape dtype: #Float.
	u
		at:
			{(grid // 2 - (square // 2) to: grid // 2 + (square // 2)).
			(grid // 2 - (square // 2) to: grid // 2 + (square // 2))} comprehension
		put: 0.5.
	v
		at:
			{(grid // 2 - (square // 2) to: grid // 2 + (square // 2)).
			(grid // 2 - (square // 2) to: grid // 2 + (square // 2))} comprehension
		put: 0.25.
	u := (u + ((NDRandom randomUniform: shape) * 0.1)) minimum: 1.
	v := (v + ((NDRandom randomUniform: shape) * 0.1)) minimum: 1
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
