"
A NDPadderTest is a test class for testing the behavior of NDPadder
"
Class {
	#name : #NDPadderTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
NDPadderTest >> newPadder [
	^ NDPadder new
]

{ #category : #test }
NDPadderTest >> testAfter [
	| p |
	p := self newPadder.
	self assert: p after isNil.
	p after: 1.
	self assert: p after equals: 1
]

{ #category : #test }
NDPadderTest >> testBefore [
	| p |
	p := self newPadder.
	self assert: p before isNil.
	p before: 1.
	self assert: p before equals: 1
]

{ #category : #test }
NDPadderTest >> testConstant [
	| a p r |
	p := self newPadder.
	p
		before: 1;
		after: 2.
	a := NDArray fromArray: #(#(1 2 3) #(4 5 6)).
	r := p constant: a.
	self
		assertCollection: r array
		equals:
			#(0 0 0 0 0 0 0 1 2 3 0 0 0 4 5 6 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
				asIntegerArray.
	self assertCollection: r shape equals: #(5 6).
	a := NDArray fromArray: #(#(1 2) #(3 4) #(5 6)).
	r := p constant: a.
	self
		assertCollection: r array
		equals:
			#(0 0 0 0 0 0 1 2 0 0 0 3 4 0 0 0 5 6 0 0 0 0 0 0 0 0 0 0 0 0)
				asIntegerArray.
	self assertCollection: r shape equals: #(6 5).
	a := NDArray fromArray: #(((1) (2)) ((3) (4))).
	r := p constant: a.
	self
		assertCollection: r array
		equals:
			#(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
				asIntegerArray
]

{ #category : #test }
NDPadderTest >> testConstantCopy [
	| p a |
	p := self newPadder.
	p
		before: 1;
		after: 2.
	a := NDArray fromArray: #(1 2 3).
	p setupForPadding: a.
	p constantCopy: a.
	self
		assertCollection: p ndArray array
		equals: #(0 1 2 3 0 0) asIntegerArray.
	a := NDArray fromArray: #((1 2) (3 4) (5 6)).
	p setupForPadding: a.
	p constantCopy: a.
	self
		assertCollection: p ndArray array
		equals: #(0 0 0 0 0 0 1 2 0 0 0 3 4 0 0 0 5 6 0 0 0 0 0 0 0 0 0 0 0 0) asIntegerArray.
	a := NDArray fromArray: #(((1) (2)) ((3) (4)) ((5) (6))).
	p setupForPadding: a.
	p constantCopy: a.
	self
		assertCollection: p ndArray array
		equals: #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 0 0 0 6 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) asIntegerArray
]

{ #category : #test }
NDPadderTest >> testEdge [
	| a p r |
	p := self newPadder.
	p
		before: 1;
		after: 2.
	a := NDArray fromArray: #(1 2 3).
	r := p edge: a.
	self assertCollection: r array equals: #(1 1 2 3 3 3) asIntegerArray.
	self assertCollection: r shape equals: #(6).
	a := NDArray fromArray: #(#(1 2 3) #(4 5 6)).
	r := p edge: a.
	self
		assertCollection: r array
		equals:
			#(1 1 2 3 3 3 1 1 2 3 3 3 4 4 5 6 6 6 4 4 5 6 6 6 4 4 5 6 6 6)
				asIntegerArray.
	self assertCollection: r shape equals: #(5 6).
	a := NDArray fromArray: #(#(1 2) #(3 4) #(5 6)).
	r := p edge: a.
	self
		assertCollection: r array
		equals:
			#(1 1 2 2 2 1 1 2 2 2 3 3 4 4 4 5 5 6 6 6 5 5 6 6 6 5 5 6 6 6)
				asIntegerArray.
	self assertCollection: r shape equals: #(6 5).
	a := NDArray fromArray: #(((1 2) (3 4)) ((5 6) (7 8))).
	r := p edge: a.
	self
		assertCollection: r array
		equals:
			#(1 1 2 2 2 1 1 2 2 2 3 3 4 4 4 3 3 4 4 4 3 3 4 4 4 1 1 2 2 2 1 1 2 2 2 3 3 4 4 4 3 3 4 4 4 3 3 4 4 4 5 5 6 6 6 5 5 6 6 6 7 7 8 8 8 7 7 8 8 8 7 7 8 8 8 5 5 6 6 6 5 5 6 6 6 7 7 8 8 8 7 7 8 8 8 7 7 8 8 8 5 5 6 6 6 5 5 6 6 6 7 7 8 8 8 7 7 8 8 8 7 7 8 8 8)
				asIntegerArray.
	self assertCollection: r shape equals: #(5 5 5).
	a := NDArray fromArray: #(((1) (2)) ((3) (4))).
	r := p edge: a.
	self
		assertCollection: r array
		equals:
			#(1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4)
				asIntegerArray.
	self assertCollection: r shape equals: #(5 5 4)
]

{ #category : #test }
NDPadderTest >> testEdgeEnd [
	| a p |
	a := NDArray ones: #(5 5 5) dtype: #Float.
	p := self newPadder.
	p ndArray: a.
	p before: 1.
	p after: 2.
	self assertCollection: (p edgeEnd: #(1 1 2)) equals: #(2 2 3).
	self assertCollection: (p edgeEnd: #(1 2 2)) equals: #(2 3 3).
	self assertCollection: (p edgeEnd: #(2 1 2)) equals: #(3 2 3).
	self assertCollection: (p edgeEnd: #(2 2 2)) equals: #(3 3 3).
	self assertCollection: (p edgeEnd: #(1 2)) equals: #(2 3 5).
	self assertCollection: (p edgeEnd: #(2 2)) equals: #(3 3 5).
	self assertCollection: (p edgeEnd: #(2)) equals: #(3 5 5)
]

{ #category : #test }
NDPadderTest >> testEdgeEndOfFor [
	| p a r |
	p := self newPadder.
	p before: 1.
	p after: 2.
	a := NDArray fromArray: #(((1 2) (3 4)) ((5 6) (7 8))).
	r := p edgeEndOf: #(1 1 1) for: a.
	self assertCollection: r equals: #(1 1 2).
	r := p edgeEndOf: #(1 2 1) for: a.
	self assertCollection: r equals: #(1 2 2).
	r := p edgeEndOf: #(2 1 1) for: a.
	self assertCollection: r equals: #(2 1 2).
	r := p edgeEndOf: #(2 2 1) for: a.
	self assertCollection: r equals: #(2 2 2).
	r := p edgeEndOf: #(1 1) for: a.
	self assertCollection: r equals: #(1 2).
	r := p edgeEndOf: #(2 1) for: a.
	self assertCollection: r equals: #(2 2).
	r := p edgeEndOf: #(1) for: a.
	self assertCollection: r equals: #(2).
	a := NDArray fromArray: #(((1) (2)) ((3) (4))).
	r := p edgeEndOf: #(1 1 1) for: a.
	self assertCollection: r equals: #(1 1 1).
	r := p edgeEndOf: #(1 2 1) for: a.
	self assertCollection: r equals: #(1 2 1).
	r := p edgeEndOf: #(2 1 1) for: a.
	self assertCollection: r equals: #(2 1 1).
	r := p edgeEndOf: #(2 2 1) for: a.
	self assertCollection: r equals: #(2 2 1).
	r := p edgeEndOf: #(1 1) for: a.
	self assertCollection: r equals: #(1 2).
	r := p edgeEndOf: #(2 1) for: a.
	self assertCollection: r equals: #(2 2)
]

{ #category : #test }
NDPadderTest >> testEdgeStart [
	| a p |
	a := NDArray ones: #(5 5 5) dtype: #Float.
	p := self newPadder.
	p ndArray: a.
	p before: 1.
	p after: 2.
	self assertCollection: (p edgeStart: #(1 1 1)) equals: #(2 2 2).
	self assertCollection: (p edgeStart: #(1 2 1)) equals: #(2 3 2).
	self assertCollection: (p edgeStart: #(2 1 1)) equals: #(3 2 2).
	self assertCollection: (p edgeStart: #(2 2 1)) equals: #(3 3 2).
	self assertCollection: (p edgeStart: #(1 1)) equals: #(2 2 1).
	self assertCollection: (p edgeStart: #(2 1)) equals: #(3 2 1).
	self assertCollection: (p edgeStart: #(1)) equals: #(2 1 1)
]

{ #category : #test }
NDPadderTest >> testNdArray [
	| a p |
	p := self newPadder.
	self assert: p ndArray isNil.
	a := NDArray fromArray: #(1 2 3).
	p ndArray: a.
	self assert: p ndArray identicalTo: a
]

{ #category : #test }
NDPadderTest >> testOmit [
	| a p r |
	p := self newPadder.
	p
		before: 1;
		after: 2.
	a := NDArray
		fromArray:
			#(#(0 0 0 0 0 0) #(0 1 2 3 0 0) #(0 4 5 6 0 0) #(0 0 0 0 0 0) #(0 0 0 0 0 0)).
	r := p omit: a.
	self
		assertCollection: r array
		equals: #(1 2 3 4 5 6) asIntegerArray.
	self assertCollection: r shape equals: #(2 3).
	a := NDArray
		fromArray:
			#(#(0 0 0 0 0) #(0 1 2 0 0) #(0 3 4 0 0) #(0 5 6 0 0) #(0 0 0 0 0) #(0 0 0 0 0)).
	r := p omit: a.
	self assertCollection: r array equals: #(1 2 3 4 5 6) asIntegerArray.
	self assertCollection: r shape equals: #(3 2).
	a := NDArray
		fromArray:
			#(#(#(0 0 0 0) #(0 0 0 0) #(0 0 0 0) #(0 0 0 0) #(0 0 0 0)) #(#(0 0 0 0) #(0 1 0 0) #(0 2 0 0) #(0 0 0 0) #(0 0 0 0)) #(#(0 0 0 0) #(0 3 0 0) #(0 4 0 0) #(0 0 0 0) #(0 0 0 0)) #(#(0 0 0 0) #(0 0 0 0) #(0 0 0 0) #(0 0 0 0) #(0 0 0 0)) #(#(0 0 0 0) #(0 0 0 0) #(0 0 0 0) #(0 0 0 0) #(0 0 0 0))).
	r := p omit: a.
	self assertCollection: r array equals: #(1 2 3 4) asIntegerArray.
	self assertCollection: r shape equals: #(2 2 1)
]

{ #category : #test }
NDPadderTest >> testSetupForOmitting [
	| a p |
	p := self newPadder.
	p before: 1.
	p after: 1.
	a := NDArray fromArray: #((1 2 3) (4 5 4) (7 8 9)).
	p setupForOmitting: a.
	self assertCollection: p ndArray shape equals: #(1 1).
	a := NDArray fromArray: #(1 2 3 4 5 6 7).
	p setupForOmitting: a.
	self assertCollection: p ndArray shape equals: #(5)
]

{ #category : #test }
NDPadderTest >> testSetupForPadding [
	| a p |
	p := self newPadder.
	p before: 1.
	p after: 2.
	a := NDArray fromArray: #((1 2) (3 4)).
	p setupForPadding: a.
	self assertCollection: p ndArray shape equals: #(5 5).
	a := NDArray fromArray: #((1) (2) (3) (4)).
	p setupForPadding: a.
	self assertCollection: p ndArray shape equals: #(7 4)
]

{ #category : #test }
NDPadderTest >> testStartPos [
	| p a |
	p := self newPadder.
	p
		before: 1;
		after: 2.
	a := NDArray fromArray: #(1 2 3).
	p setupForPadding: a.
	self assert: p startPos equals: 2.
	a := NDArray fromArray: #((1 2) (3 4) (5 6)).
	p setupForPadding: a.
	self assert: p startPos equals: 7.
	a := NDArray fromArray: #(((1) (2)) ((3) (4)) ((5) (6))).
	p setupForPadding: a.
	self assert: p startPos equals: 26.
	a := NDArray fromArray: #(((1 2 3) (4 5 6)) ((7 8 9) (10 11 12))).
	p setupForPadding: a.
	self assert: p startPos equals: 38.
]
