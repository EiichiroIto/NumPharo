"
A NDRandomTest is a test class for testing the behavior of NDRandom
"
Class {
	#name : #NDRandomTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
NDRandomTest >> newRandom [
	^ NDRandom new
]

{ #category : #test }
NDRandomTest >> testInitialize [
	| r |
	r := self newRandom.
	self assert: r rand class equals: Random
]

{ #category : #test }
NDRandomTest >> testNormalRandomNumber [
	| r sum |
	r := self newRandom.
	sum := 0.
	1000 timesRepeat: [ sum := sum + r normalRandomNumber ].
	sum := sum / 1000.
	self assert: (sum between: -0.1 and: 0.1)
]

{ #category : #test }
NDRandomTest >> testRand [
	| r x |
	r := self newRandom.
	self assert: r rand class equals: Random.
	x := Random new.
	r rand: x.
	self assert: r rand identicalTo: x
]

{ #category : #test }
NDRandomTest >> testRandomChoiceFrom [
	| r a |
	r := self newRandom.
	a := r randomChoice: 10 from: (100 to: 200).
	self assert: a array size equals: 10.
	self assert: a array asSet size equals: 10.
	self assert: a dtype equals: #Integer.
	self assert: (a array allSatisfy: [ :each | each between: 100 and: 200 ]).
	a := r randomChoice: 5 from: 50.
	self assert: a array size equals: 5.
	self assert: a array asSet size equals: 5.
	self assert: a dtype equals: #Integer.
	self assert: (a array allSatisfy: [ :each | each between: 1 and: 50 ])
]

{ #category : #test }
NDRandomTest >> testRandomNormal [
	| r a |
	r := self newRandom.
	a := r randomNormal: 10000.
	self assert: a average abs < 0.1.
	self assert: (a std - 1) abs < 0.1
]

{ #category : #test }
NDRandomTest >> testRandomNormalMeanStd [
	| r a |
	r := self newRandom.
	a := r randomNormal: 10000 mean: 5 std: 2.
	self assert: (a average - 5) abs < 0.1.
	self assert: (a std - 2) abs < 0.1
]

{ #category : #test }
NDRandomTest >> testRandomUniform [
	| r a |
	r := self newRandom.
	100
		timesRepeat: [ a := r randomUniform: 10.
			self assert: ((a >= 0) array allSatisfy: [ :each | each ]).
			self assert: ((a < 1) array allSatisfy: [ :each | each ]) ]
]

{ #category : #test }
NDRandomTest >> testRandomUniformFromTo [
	| r a |
	r := self newRandom.
	100
		timesRepeat: [ a := r randomUniform: 10 from: 5 to: 8.
			self assert: ((a >= 5) array allSatisfy: [ :each | each ]).
			self assert: ((a < 8) array allSatisfy: [ :each | each ]) ]
]

{ #category : #test }
NDRandomTest >> testUniformRandomNumber [
	| r |
	r := self newRandom.
	1000
		timesRepeat: [ self assert: (r uniformRandomNumber between: 0 and: 1) ]
]
