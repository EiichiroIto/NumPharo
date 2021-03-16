Class {
	#name : #NNLayer,
	#superclass : #Object,
	#instVars : [
		'functions'
	],
	#category : #'NumPharo-Demo'
}

{ #category : #api }
NNLayer >> backward: dout [
	self subclassResponsibility
]

{ #category : #accessing }
NNLayer >> functions [
	^ functions
]

{ #category : #accessing }
NNLayer >> functions: anObject [
	functions := anObject
]
