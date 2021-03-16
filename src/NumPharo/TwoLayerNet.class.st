Class {
	#name : #TwoLayerNet,
	#superclass : #Object,
	#instVars : [
		'params',
		'weightInitStd',
		'functions'
	],
	#category : #'NumPharo-Demo'
}

{ #category : #api }
TwoLayerNet >> accuracy: x t: t [
	| y t2 |
	y := self predict: x.
	y := y argMaxAxis: 2.
	t2 := t ndim = 1
		ifTrue: [ t ]
		ifFalse: [ t argMaxAxis: 2 ].
	^ (y = t2) sum / x shape first asFloat
]

{ #category : #initialization }
TwoLayerNet >> initialize [
	self weightInitStd: 0.01
]

{ #category : #api }
TwoLayerNet >> inputSize: anInteger1 hiddenSize: anInteger3 outputSize: anInteger2 [
	params := Dictionary new.
	params
		at: #W1
		put:
			weightInitStd
				*
					(NDArray
						randomNormal:
							{anInteger1.
							anInteger3}).
	params at: #b1 put: (NDArray zeros: anInteger3 dtype: #Float).
	params
		at: #W2
		put:
			weightInitStd
				*
					(NDArray
						randomNormal:
							{anInteger3.
							anInteger2}).
	params at: #b2 put: (NDArray zeros: anInteger2 dtype: #Float)
]

{ #category : #api }
TwoLayerNet >> loss: x t: t [
	| y |
	y := self predict: x.
	^ functions crossEntropyErrorY: y andT: t
]

{ #category : #private }
TwoLayerNet >> numericalGradient: aBlock atX: aNumber [
	| h grad tmp fxh1 fxh2 |
	h := 1e-4.
	grad := NDArray zerosLike: aNumber.
	1 to: aNumber size do: [ :each | 
		tmp := aNumber at: each.
		aNumber at: each put: tmp + h.
		fxh1 := aBlock cull: aNumber.
		aNumber at: each put: tmp - h.
		fxh2 := aBlock cull: aNumber.
		grad at: each put: (fxh1 - fxh2) / (2 * h).
		aNumber at: each put: tmp ].
	^ grad
]

{ #category : #private }
TwoLayerNet >> numericalGradient: aBlock ofBatch: aNDArray [
	| grad |
	aNDArray ndim = 1
		ifTrue: [ ^ self numericalGradient: aBlock atX: aNDArray ].
	grad := NDArray zerosLike: aNDArray.
	1 to: aNDArray len do: [ :index | 
		| x |
		x := aNDArray at: index.
		grad at: index put: (self numericalGradient: aBlock atX: x) ].
	^ grad
]

{ #category : #api }
TwoLayerNet >> numericalGradient: x t: t [
	| lossW grads |
	lossW := [ :a | self loss: x t: t ].
	grads := Dictionary new.
	grads
		at: #W1
		put: (self numericalGradient: lossW ofBatch: (params at: #W1)).
	grads
		at: #b1
		put: (self numericalGradient: lossW ofBatch: (params at: #b1)).
	grads
		at: #W2
		put: (self numericalGradient: lossW ofBatch: (params at: #W2)).
	grads
		at: #b2
		put: (self numericalGradient: lossW ofBatch: (params at: #b2)).
	^ grads
]

{ #category : #accessing }
TwoLayerNet >> paramAt: aSymbol [
	^ params at: aSymbol
]

{ #category : #api }
TwoLayerNet >> predict: x [
	| w1 w2 b1 b2 a1 a2 z1 |
	w1 := params at: #W1.
	w2 := params at: #W2.
	b1 := params at: #b1.
	b2 := params at: #b2.
	a1 := (x dot: w1) + b1.
	z1 := functions sigmoid: a1.
	a2 := (z1 dot: w2) + b2.
	^ functions softMax: a2
]

{ #category : #api }
TwoLayerNet >> readParamsFromFiles [
	params := Dictionary new.
	params
		at: #W1
		put:
			(STON fromStream: (FileSystem workingDirectory / 'W1.ston') readStream).
	params
		at: #W2
		put:
			(STON fromStream: (FileSystem workingDirectory / 'W2.ston') readStream).
	params
		at: #b1
		put:
			(STON fromStream: (FileSystem workingDirectory / 'b1.ston') readStream).
	params
		at: #b2
		put:
			(STON fromStream: (FileSystem workingDirectory / 'b2.ston') readStream)
]

{ #category : #accessing }
TwoLayerNet >> weightInitStd [
	^ weightInitStd
]

{ #category : #accessing }
TwoLayerNet >> weightInitStd: aNumber [
	weightInitStd := aNumber
]
