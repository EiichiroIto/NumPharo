Class {
	#name : #NNLayer,
	#superclass : #Object,
	#category : #'NumPharo-Demo'
}

{ #category : #api }
NNLayer >> backward: dout [
	self subclassResponsibility
]
