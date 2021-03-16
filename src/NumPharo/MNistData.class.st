Class {
	#name : #MNistData,
	#superclass : #Object,
	#instVars : [
		'images',
		'labels',
		'normalize',
		'oneHotLabel',
		'flatten'
	],
	#category : #'NumPharo-MNist'
}

{ #category : #private }
MNistData >> convertImageData: anArray [
	| array shape |
	shape := flatten
		ifTrue: [ Array
				with: anArray first first
				with: (NDArray finiteProductOf: anArray first copyWithoutFirst) ]
		ifFalse: [ anArray first ].
	array := normalize
		ifTrue: [ anArray second asFloatArray / 255.0 ]
		ifFalse: [ anArray second copy ].
	^ NDArray array: array shape: shape
]

{ #category : #private }
MNistData >> convertLabelData: anArray [
	| block shape array pos |
	shape := oneHotLabel
		ifTrue: [ Array with: anArray size with: 10 ]
		ifFalse: [ Array with: anArray size ].
	array := ByteArray new: (NDArray finiteProductOf: shape).
	pos := 1.
	block := oneHotLabel
		ifTrue: [ [ :d | 
			self writeOneHotData: d to: array at: pos.
			pos := pos + 10 ] ]
		ifFalse: [ [ :d | 
			array at: pos put: d.
			pos := pos + 1 ] ].
	anArray do: [ :each | block cull: each ].
	^ NDArray array: array shape: shape
]

{ #category : #accessing }
MNistData >> flatten [
	^ flatten
]

{ #category : #accessing }
MNistData >> flatten: anObject [
	flatten := anObject
]

{ #category : #accessing }
MNistData >> images [
	^ images
]

{ #category : #accessing }
MNistData >> images: anObject [
	images := anObject
]

{ #category : #initialization }
MNistData >> initialize [
	normalize := false.
	oneHotLabel := false.
	flatten := false
]

{ #category : #testing }
MNistData >> isReady [
	^ images notNil and: [ labels notNil ]
]

{ #category : #accessing }
MNistData >> labels [
	^ labels
]

{ #category : #accessing }
MNistData >> labels: anObject [
	labels := anObject
]

{ #category : #accessing }
MNistData >> normalize [
	^ normalize
]

{ #category : #accessing }
MNistData >> normalize: anObject [
	normalize := anObject
]

{ #category : #accessing }
MNistData >> oneHotLabel [
	^ oneHotLabel
]

{ #category : #accessing }
MNistData >> oneHotLabel: anObject [
	oneHotLabel := anObject
]

{ #category : #private }
MNistData >> setup [
	| mnist |
	images := Array new: 2.
	labels := Array new: 2.
	mnist := MNistReader load.
	images at: 1 put: (self convertImageData: mnist first first).
	labels at: 1 put: (self convertLabelData: mnist first second).
	images at: 2 put: (self convertImageData: mnist second first).
	labels at: 2 put: (self convertLabelData: mnist second second)
]

{ #category : #api }
MNistData >> testingImages [
	self isReady
		ifFalse: [ self setup ].
	^ images second
]

{ #category : #api }
MNistData >> testingLabels [
	self isReady
		ifFalse: [ self setup ].
	^ labels second
]

{ #category : #api }
MNistData >> trainingImages [
	self isReady
		ifFalse: [ self setup ].
	^ images first
]

{ #category : #api }
MNistData >> trainingLabels [
	self isReady
		ifFalse: [ self setup ].
	^ labels first
]

{ #category : #private }
MNistData >> writeOneHotData: anInteger to: anArray at: anInteger3 [
	0 to: 9 do: [ :each | 
		anArray
			at: anInteger3 + each
			put:
				(each = anInteger
					ifTrue: [ 1 ]
					ifFalse: [ 0 ]) ]
]
