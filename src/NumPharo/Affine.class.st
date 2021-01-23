Class {
	#name : #Affine,
	#superclass : #NNLayer,
	#instVars : [
		'w',
		'b',
		'originalShape',
		'dw',
		'db',
		'x'
	],
	#category : #'NumPharo-Demo'
}

{ #category : #accessing }
Affine >> b [
	^ b
]

{ #category : #accessing }
Affine >> b: anObject [
	b := anObject
]

{ #category : #api }
Affine >> backward: dout [
	| dx |
	dx := dout dot: w t.
	dw := x t dot: dout.
	db := dout sumAxis: 1.
	^ dx reShape: originalShape
]

{ #category : #api }
Affine >> forward: aNDArray [
	originalShape := aNDArray shape.
	x := aNDArray reShape: { aNDArray first. -1 }.
	^ (x dot: w) + b
]

{ #category : #accessing }
Affine >> originalShape [
	^ originalShape
]

{ #category : #accessing }
Affine >> originalShape: anObject [
	originalShape := anObject
]

{ #category : #accessing }
Affine >> w [
	^ w
]

{ #category : #accessing }
Affine >> w: anObject [
	w := anObject
]
