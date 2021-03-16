Class {
	#name : #TwoLayerNet2,
	#superclass : #TwoLayerNet,
	#instVars : [
		'layers',
		'lastLayer'
	],
	#category : #'NumPharo-Demo'
}

{ #category : #api }
TwoLayerNet2 >> gradient: x t: t [
	| dout grads |
	self loss: x t: t.
	dout := 1.
	dout := lastLayer backward: dout.
	dout := layers asOrderedCollection reversed inject: dout into: [ :p :e | e backward: p ].
	grads := Dictionary new.
	grads at: #W1 put: (layers at: #Affine1) dw.
	grads at: #b1 put: (layers at: #Affine1) db.
	grads at: #W2 put: (layers at: #Affine2) dw.
	grads at: #b2 put: (layers at: #Affine2) db.
	^ grads
]

{ #category : #api }
TwoLayerNet2 >> inputSize2: anInteger1 hiddenSize: anInteger3 outputSize: anInteger2 [
	self readParamsFromFiles.
	layers := OrderedDictionary new.
	layers
		at: #Affine1
		put:
			(Affine new
				w: (params at: #W1);
				b: (params at: #b1);
				yourself).
	layers at: #Relu1 put: ReLu new.
	layers
		at: #Affine2
		put:
			(Affine new
				w: (params at: #W2);
				b: (params at: #b2);
				yourself).
	lastLayer := SoftmaxWithLoss new
		functions: Chapter5Functions new;
		yourself
]

{ #category : #api }
TwoLayerNet2 >> inputSize: anInteger1 hiddenSize: anInteger3 outputSize: anInteger2 [
	super
		inputSize: anInteger1
		hiddenSize: anInteger3
		outputSize: anInteger2.
	layers := OrderedDictionary new.
	layers
		at: #Affine1
		put:
			(Affine new
				w: (params at: #W1);
				b: (params at: #b1);
				yourself).
	layers at: #Relu1 put: ReLu new.
	layers
		at: #Affine2
		put:
			(Affine new
				w: (params at: #W2);
				b: (params at: #b2);
				yourself).
	lastLayer := SoftmaxWithLoss new
		functions: Chapter5Functions new;
		yourself
]

{ #category : #accessing }
TwoLayerNet2 >> lastLayer [
	^ lastLayer
]

{ #category : #accessing }
TwoLayerNet2 >> lastLayer: anObject [
	lastLayer := anObject
]

{ #category : #accessing }
TwoLayerNet2 >> layers [
	^ layers
]

{ #category : #accessing }
TwoLayerNet2 >> layers: anObject [
	layers := anObject
]

{ #category : #api }
TwoLayerNet2 >> loss: x t: t [
	| y |
	y := self predict: x.
	^ lastLayer forward: y t: t
]

{ #category : #api }
TwoLayerNet2 >> numericalGradient: aBlock ofBatch: aNDArray [
	| h grad it idx tmpVal fxh1 fxh2 |
	h := 1e-4.
	grad := NDArray zerosLike: aNDArray.
	it := NDIndexIterator new
		shape: aNDArray shape;
		yourself.
	[ idx := it nextForTranspose.
	idx notNil ]
		whileTrue: [ tmpVal := aNDArray at: idx.
			aNDArray at: idx put: tmpVal + h.
			fxh1 := aBlock cull: 0.
			aNDArray at: idx put: tmpVal - h.
			fxh2 := aBlock cull: 0.
			grad at: idx put: (fxh1 - fxh2) / (2.0 * h).
			aNDArray at: idx put: tmpVal ].
	^ grad
]

{ #category : #api }
TwoLayerNet2 >> predict: x [
	^ layers inject: x into: [ :prev :each | each forward: prev ]
]
