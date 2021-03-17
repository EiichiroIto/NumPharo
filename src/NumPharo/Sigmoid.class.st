Class {
	#name : #Sigmoid,
	#superclass : #NNLayer,
	#instVars : [
		'out'
	],
	#category : #'NumPharo-Demo'
}

{ #category : #api }
Sigmoid >> backward: dout [
	^ dout * (1.0 - out) * out
]

{ #category : #api }
Sigmoid >> forward: x [
	out := functions sigmoid: x.
	^ out
]
