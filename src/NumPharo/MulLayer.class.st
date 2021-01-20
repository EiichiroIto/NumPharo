Class {
	#name : #MulLayer,
	#superclass : #NNLayer,
	#instVars : [
		'x',
		'y'
	],
	#category : #'NumPharo-Demo'
}

{ #category : #api }
MulLayer >> backward: dout [
	| dx dy |
	dx := dout * y.
	dy := dout * x.
	^ {dx.
	dy}
]

{ #category : #api }
MulLayer >> forwardX: anObject y: anObject2 [
	x := anObject.
	y := anObject2.
	^ x * y
]
