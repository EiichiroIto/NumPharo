"
A NDIndexIteratorTest is a test class for testing the behavior of NDIndexIterator
"
Class {
	#name : #NDIndexIteratorTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
NDIndexIteratorTest >> newIter [
	^ NDIndexIterator new
]

{ #category : #test }
NDIndexIteratorTest >> testNextForPad [
	| a i |
	a := NDArray fromArray: #(4 5 6).
	i := self newIter shape: a shape.
	self assert: i nextIndex isNil.
	self assertCollection: i nextForPad equals: #(1).
	self assert: i nextForPad isNil.
	a := NDArray fromArray: #((1 2 3) (4 5 6)).
	i := self newIter shape: a shape.
	self assertCollection: i nextForPad equals: #(1 1).
	self assertCollection: i nextForPad equals: #(2 1).
	self assert: i nextForPad isNil.
	a := NDArray fromArray: #((1 2) (3 4) (5 6)).
	i := self newIter shape: a shape.
	self assertCollection: i nextForPad equals: #(1 1).
	self assertCollection: i nextForPad equals: #(2 1).
	self assertCollection: i nextForPad equals: #(3 1).
	self assert: i nextForPad isNil.
	a := NDArray fromArray: #(((1 2) (3 4) (5 6))).
	i := self newIter shape: a shape.
	self assertCollection: i nextForPad equals: #(1 1 1).
	self assertCollection: i nextForPad equals: #(1 2 1).
	self assertCollection: i nextForPad equals: #(1 3 1).
	self assert: i nextForPad isNil.
	a := NDArray fromArray: #(((1) (2)) ((3) (4)) ((5) (6))).
	i := self newIter shape: a shape.
	self assertCollection: i nextForPad equals: #(1 1 1).
	self assertCollection: i nextForPad equals: #(1 2 1).
	self assertCollection: i nextForPad equals: #(2 1 1).
	self assertCollection: i nextForPad equals: #(2 2 1).
	self assertCollection: i nextForPad equals: #(3 1 1).
	self assertCollection: i nextForPad equals: #(3 2 1).
	self assert: i nextForPad isNil.

]

{ #category : #test }
NDIndexIteratorTest >> testNextForT [
	| a i |
	a := NDArray fromArray: #(4 5 6).
	i := self newIter shape: a shape.
	self assert: i nextIndex isNil.
	self assertCollection: i nextForT equals: #(1).
	self assertCollection: i nextForT equals: #(2).
	self assertCollection: i nextForT equals: #(3).
	self assert: i nextForT isNil.
	a := NDArray fromArray: #((1 2) (3 4)).
	i := self newIter shape: a shape.
	self assert: i nextIndex isNil.
	self assertCollection: i nextForT equals: #(1 1).
	self assertCollection: i nextForT equals: #(2 1).
	self assertCollection: i nextForT equals: #(1 2).
	self assertCollection: i nextForT equals: #(2 2).
	self assert: i nextForT isNil.
	a := NDArray fromArray: #((1 2) (3 4) (5 6)).
	i := self newIter shape: a shape.
	self assert: i nextIndex isNil.
	self assertCollection: i nextForT equals: #(1 1).
	self assertCollection: i nextForT equals: #(2 1).
	self assertCollection: i nextForT equals: #(3 1).
	self assertCollection: i nextForT equals: #(1 2).
	self assertCollection: i nextForT equals: #(2 2).
	self assertCollection: i nextForT equals: #(3 2).
	self assert: i nextForT isNil.
	a := NDArray fromArray: #(((1 2) (3 4)) ((5 6) (7 8))).
	i := self newIter shape: a shape.
	self assert: i nextIndex isNil.
	self assertCollection: i nextForT equals: #(1 1 1).
	self assertCollection: i nextForT equals: #(2 1 1).
	self assertCollection: i nextForT equals: #(1 2 1).
	self assertCollection: i nextForT equals: #(2 2 1).
	self assertCollection: i nextForT equals: #(1 1 2).
	self assertCollection: i nextForT equals: #(2 1 2).
	self assertCollection: i nextForT equals: #(1 2 2).
	self assertCollection: i nextForT equals: #(2 2 2).
	self assert: i nextForT isNil
]

{ #category : #test }
NDIndexIteratorTest >> testNextForTranspose [
	| a i |
	a := NDArray fromArray: #(4 5 6).
	i := self newIter shape: a shape.
	self assert: i nextIndex isNil.
	self assertCollection: i nextForTranspose equals: #(1).
	self assertCollection: i nextForTranspose equals: #(2).
	self assertCollection: i nextForTranspose equals: #(3).
	self assert: i nextForTranspose isNil.
	a := NDArray fromArray: #((1 2) (3 4)).
	i := self newIter shape: a shape.
	self assert: i nextIndex isNil.
	self assertCollection: i nextForTranspose equals: #(1 1).
	self assertCollection: i nextForTranspose equals: #(1 2).
	self assertCollection: i nextForTranspose equals: #(2 1).
	self assertCollection: i nextForTranspose equals: #(2 2).
	self assert: i nextForTranspose isNil.
	a := NDArray fromArray: #((1 2) (3 4) (5 6)).
	i := self newIter shape: a shape.
	self assert: i nextIndex isNil.
	self assertCollection: i nextForTranspose equals: #(1 1).
	self assertCollection: i nextForTranspose equals: #(1 2).
	self assertCollection: i nextForTranspose equals: #(2 1).
	self assertCollection: i nextForTranspose equals: #(2 2).
	self assertCollection: i nextForTranspose equals: #(3 1).
	self assertCollection: i nextForTranspose equals: #(3 2).
	self assert: i nextForTranspose isNil.
	a := NDArray fromArray: #(((1 2) (3 4)) ((5 6) (7 8))).
	i := self newIter shape: a shape.
	self assert: i nextIndex isNil.
	self assertCollection: i nextForTranspose equals: #(1 1 1).
	self assertCollection: i nextForTranspose equals: #(1 1 2).
	self assertCollection: i nextForTranspose equals: #(1 2 1).
	self assertCollection: i nextForTranspose equals: #(1 2 2).
	self assertCollection: i nextForTranspose equals: #(2 1 1).
	self assertCollection: i nextForTranspose equals: #(2 1 2).
	self assertCollection: i nextForTranspose equals: #(2 2 1).
	self assertCollection: i nextForTranspose equals: #(2 2 2).
	self assert: i nextForTranspose isNil
]

{ #category : #test }
NDIndexIteratorTest >> testNextIndex [
	| i |
	i := self newIter.
	self assert: i nextIndex isNil.
	i nextIndex: #(1 2 3).
	self assertCollection: i nextIndex equals: #(1 2 3)
]

{ #category : #test }
NDIndexIteratorTest >> testResetIndex [
	| a i |
	a := NDArray fromArray: #(4 5 6).
	i := self newIter shape: a shape.
	self assertCollection: i resetIndex equals: #(1).
	a := NDArray fromArray: #((1 2) (3 4)).
	i := self newIter shape: a shape.
	self assertCollection: i resetIndex equals: #(1 1).
	a := NDArray fromArray: #(((1 2) (3 4)) ((5 6) (7 8))).
	i := self newIter shape: a shape.
	self assertCollection: i resetIndex equals: #(1 1 1)
]

{ #category : #test }
NDIndexIteratorTest >> testShape [
	| a i |
	i := self newIter.
	self assert: i shape isNil.
	a := NDArray fromArray: #(4 5 6).
	i shape: a shape.
	self assert: i shape identicalTo: a shape
]
