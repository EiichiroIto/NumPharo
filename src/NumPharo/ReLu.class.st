Class {
	#name : #ReLu,
	#superclass : #NNLayer,
	#instVars : [
		'mask'
	],
	#category : #'NumPharo-Demo'
}

{ #category : #api }
ReLu >> backward: dout [
	dout at: mask put: 0.
	^ dout
]

{ #category : #api }
ReLu >> forward: x [
	| out |
	mask := x <= 0.
	out := x copy.
	out at: mask put: 0.
	^ out
]
