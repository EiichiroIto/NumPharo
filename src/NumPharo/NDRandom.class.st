Class {
	#name : #NDRandom,
	#superclass : #Object,
	#instVars : [
		'rand'
	],
	#classInstVars : [
		'default'
	],
	#category : #'NumPharo-Core'
}

{ #category : #accessing }
NDRandom class >> default [
	^ default ifNil: [ default := self new ]
]

{ #category : #accessing }
NDRandom class >> default: anObject [
	default := anObject
]

{ #category : #api }
NDRandom class >> randomChoice: anInteger from: aCollection [
	^ self default randomChoice: anInteger from: aCollection
]

{ #category : #api }
NDRandom class >> randomNormal: anObject [
	^ self default randomNormal: anObject
]

{ #category : #api }
NDRandom class >> randomNormal: anObject mean: aNumber2 std: aNumber3 [
	^ self default randomNormal: anObject mean: aNumber2 std: aNumber3
]

{ #category : #api }
NDRandom class >> randomUniform: anObject [
	^ self default randomUniform: anObject
]

{ #category : #api }
NDRandom class >> randomUniform: anObject from: anInteger2 to: anInteger3 [
	^ self default randomUniform: anObject from: anInteger2 to: anInteger3
]

{ #category : #api }
NDRandom class >> randomUniformFrom: anInteger to: anInteger2 [
	^ self default randomUniformFrom: anInteger to: anInteger2
]

{ #category : #initialization }
NDRandom >> initialize [
	rand := Random new
]

{ #category : #private }
NDRandom >> normalRandomNumber [
	| r |
	r := 0.0.
	12 timesRepeat: [ r := r + self uniformRandomNumber ].
	^ r - 6
]

{ #category : #accessing }
NDRandom >> rand [
	^ rand
]

{ #category : #accessing }
NDRandom >> rand: anObject [
	rand := anObject
]

{ #category : #api }
NDRandom >> randomChoice: anInteger from: aCollection [
	| list |
	list := aCollection isNumber
		ifTrue: [ 1 to: aCollection ]
		ifFalse: [ aCollection ].
	^ NDArray
		fromArray: (list shuffled copyFrom: 1 to: anInteger)
		dtype: #Integer
]

{ #category : #api }
NDRandom >> randomNormal: anObject [
	^ NDArray shape: anObject generateEach: [ self normalRandomNumber ]
]

{ #category : #api }
NDRandom >> randomNormal: anObject mean: aNumber2 std: aNumber3 [
	^ NDArray
		shape: anObject
		generateEach: [ self normalRandomNumber * aNumber3 + aNumber2 ]
]

{ #category : #api }
NDRandom >> randomUniform: anObject [
	^ NDArray shape: anObject generateEach: [ self uniformRandomNumber ]
]

{ #category : #api }
NDRandom >> randomUniform: anObject from: anInteger2 to: anInteger3 [
	^ NDArray
		shape: anObject
		generateEach:
			[ anInteger2 + ((anInteger3 - anInteger2) * self uniformRandomNumber) ]
]

{ #category : #private }
NDRandom >> randomUniformFrom: anInteger to: anInteger2 [
	^ anInteger + ((anInteger2 - anInteger) * self uniformRandomNumber)
]

{ #category : #private }
NDRandom >> uniformRandomNumber [
	^ rand next
]
