Class {
	#name : #AddLayer,
	#superclass : #NNLayer,
	#category : #'NumPharo-Demo'
}

{ #category : #api }
AddLayer >> backward: dout [
	| dx dy |
	dx := dout * 1.
	dy := dout * 1.
	^ {dx.
	dy}
]

{ #category : #api }
AddLayer >> forwardX: x y: y [
	^ x + y
]
