"
A TNDArrayAccessorTest is a test class for testing the behavior of TNDArrayAccessor
"
Class {
	#name : #TNDArrayAccessorsTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
TNDArrayAccessorsTest >> newArrayFrom: anArray [
	^ NDArray fromArray: anArray dtype: #Float
]

{ #category : #private }
TNDArrayAccessorsTest >> newArrayFrom: anArray dtype: aSymbol [
	^ NDArray fromArray: anArray dtype: aSymbol
]

{ #category : #test }
TNDArrayAccessorsTest >> testAtBooleans [
	| a r i |
	a := self newArrayFrom: #(1 2 3 4 5).
	r := a atBooleans: (NDArray fromArray: {true . false . true . false . false}).
	self assertCollection: r array equals: #(1 3) asFloatArray.
	a := self newArrayFrom: #(#(#(1 2) #(3 4)) #(#(5 6) #(7 8))).
	r := a atBooleans: (NDArray fromArray: {true . false}).
	self assertCollection: r array equals: #(1 2 3 4) asFloatArray.
	self assertCollection: r shape equals: #(1 2 2).
	self assert: r dtype equals: #Float.
	i := a \\ 2 = 0.
	r := a atBooleans: i.
	self assertCollection: r array equals: #(2 4 6 8) asFloatArray.
	self assertCollection: r shape equals: #(4).
	self assert: r dtype equals: #Float.
	a := self newArrayFrom: #(#(1 2 3) #(4 5 6)).
	i := NDArray fromArray: #(#(false true false) #(true true false)).
	r := a atBooleans: i.
	self assertCollection: r array equals: #(2 4 5) asFloatArray
]

{ #category : #test }
TNDArrayAccessorsTest >> testAtBooleans1D [
	| a b r |
	a := self newArrayFrom: #(#(1 2 3) #(4 5 6)).
	b := NDArray fromArray: #(#(false true false) #(true true false)).
	r := a atBooleans1D: b.
	self assertCollection: r array equals: #(2 4 5) asFloatArray.
	self assertCollection: r shape equals: #(3)
]

{ #category : #test }
TNDArrayAccessorsTest >> testAtBooleans1DPut [
	| a b |
	a := NDArray fromArray: #(#(1 2 3) #(4 5 6)).
	b := NDArray fromArray: #(#(false true false) #(true true false)).
	a atBooleans: b put: 9.
	self assertCollection: a array equals: #(1 9 3 9 9 6) asIntegerArray
]

{ #category : #test }
TNDArrayAccessorsTest >> testAtBooleansPut [
	| a b |
	a := NDArray fromArray: #((1 2 3) (4 5 6)).
	b := NDArray fromArray: #(false true).
	a atBooleans: b put: 0.
	self assertCollection: a array equals: #(1 2 3 0 0 0) asIntegerArray.
	a := NDArray fromArray: #((1 2 3) (4 5 6)).
	b := NDArray fromArray: #(true false).
	a atBooleans: b put: 9.
	self assertCollection: a array equals: #(9 9 9 4 5 6) asIntegerArray.
	a := NDArray fromArray: #((1 2 3) (4 5 6)).
	b := NDArray fromArray: #(false true).
	a atBooleans: b put: #(10 20 30).
	self assertCollection: a array equals: #(1 2 3 10 20 30) asIntegerArray.
	b := NDArray fromArray: #(true false true).
	self should: [ a atBooleans: b put: 0 ] raise: Error
]

{ #category : #test }
TNDArrayAccessorsTest >> testAtNumbers [
	| a b r |
	a := self newArrayFrom: #((10 20) (30 40) (50 60)).
	b := self newArrayFrom: #(1 3) dtype: #Integer.
	r := a atNumbers: b.
	self assertCollection: r array equals: #(10 20 50 60) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	b := self newArrayFrom: #((1 2) (1 3) (2 2)) dtype: #Integer.
	r := a atNumbers: b.
	self assertCollection: r array equals: #(10 20 30 40 10 20 50 60 30 40 30 40) asFloatArray.
	self assertCollection: r shape equals: #(3 2 2).
	a := self newArrayFrom: #(10 20 30 40 50).
	b := self newArrayFrom: #(4 1 2) dtype: #Integer.
	r := a atNumbers: b.
	self assertCollection: r array equals: #(40 10 20) asFloatArray
]

{ #category : #test }
TNDArrayAccessorsTest >> testAtNumbersPut [
	| a b |
	a := self newArrayFrom: #((10 20) (30 40) (50 60)).
	b := self newArrayFrom: #(1 3) dtype: #Integer.
	a atNumbers: b put: 99.
	self assertCollection: a array equals: #(99 99 30 40 99 99) asFloatArray.
	a := self newArrayFrom: #((10 20) (30 40) (50 60)).
	a atNumbers: b put: #(99 98).
	self assertCollection: a array equals: #(99 98 30 40 99 98) asFloatArray.
	a := self newArrayFrom: #((10 20) (30 40) (50 60)).
	b := self newArrayFrom: #((1 2) (1 3) (2 2)) dtype: #Integer.
	a atNumbers: b put: 99.
	self assertCollection: a array equals: #(99 99 99 99 99 99) asFloatArray.
	a := self newArrayFrom: #(10 20 30 40 50).
	b := self newArrayFrom: #(4 1 2) dtype: #Integer.
	a atNumbers: b put: 99.
	self assertCollection: a array equals: #(99 99 30 99 50) asFloatArray
]

{ #category : #test }
TNDArrayAccessorsTest >> testAtTuple [
	| a n r |
	a := self newArrayFrom: #((51 55) (14 19) (0 4)).
	n := a atTuple: #(1 2).
	self assert: n equals: 55.
	n := a atTuple: #(2 2).
	self assert: n equals: 19.
	n := a atTuple: #(3 1).
	self assert: n equals: 0.
	n := a atTuple: 1.
	self assertCollection: n array equals: #(51 55) asFloatArray.
	self assertCollection: n shape equals: #(2).
	self assert: n dtype equals: #Float.
	self assert: (n atTuple: 2) equals: 55.
	n := a atTuple: 2.
	self assertCollection: n array equals: #(14 19) asFloatArray.
	self assertCollection: n shape equals: #(2).
	self assert: n dtype equals: #Float.
	n := a atTuple: 3.
	self assertCollection: n array equals: #(0 4) asFloatArray.
	self assertCollection: n shape equals: #(2).
	self assert: n dtype equals: #Float.
	a := self newArrayFrom: #(10 20 30).
	self assert: (a atTuple: 1) equals: 10.
	self assert: (a atTuple: 2) equals: 20.
	self assert: (a atTuple: 3) equals: 30.
	self should: [ a atTuple: 4 ] raise: Error.
	a := self newArrayFrom: #((10 20 30) (40 50 60)).
	n := a atTuple: 1.
	self assertCollection: n array equals: #(10 20 30) asFloatArray.
	self assertCollection: n shape equals: #(3).
	self assert: n dtype equals: #Float.
	n := a atTuple: 2.
	self assertCollection: n array equals: #(40 50 60) asFloatArray.
	self assertCollection: n shape equals: #(3).
	self assert: n dtype equals: #Float.
	a := self newArrayFrom: #(((10 20 30) (30 40 50)) ((40 50 60) (60 70 80))).
	n := a atTuple: #(1 1 1).
	self assert: n equals: 10.
	n := a atTuple: #(2 1 2).
	self assert: n equals: 50.
	n := a atTuple: #(2 2 3).
	self assert: n equals: 80.
	n := a atTuple: 1.
	self assertCollection: n array equals: #(10 20 30 30 40 50) asFloatArray.
	self assertCollection: n shape equals: #(2 3).
	self assert: n dtype equals: #Float.
	n := a atTuple: 2.
	self assertCollection: n array equals: #(40 50 60 60 70 80) asFloatArray.
	self assertCollection: n shape equals: #(2 3).
	self assert: n dtype equals: #Float.
	a := self newArrayFrom: #(((1 2) (2 3) (4 5))).
	self assert: (((a atTuple: 1) atTuple: 3) atTuple: 1) equals: 4.
	self assert: (((a atTuple: 1) atTuple: 3) atTuple: 2) equals: 5.
	a := self newArrayFrom: #(((10 20) (30 40)) ((50 60) (70 80)) ((90 100) (110 120))).
	r := a atTuple: 3.
	self assertCollection: r array equals: #(90 100 110 120) asFloatArray.
	r := a atTuple: #(3 1).
	self assertCollection: r array equals: #(90 100) asFloatArray.
	r := a atTuple: #(3 2 2).
	self assert: r equals: 120
]

{ #category : #test }
TNDArrayAccessorsTest >> testAtTuplePut [
	| a |
	a := self newArrayFrom: #((51 55) (14 19) (0 4)).
	a atTuple: #(1 2) put: 99.
	self assertCollection: a array equals: #(51 99 14 19 0 4) asFloatArray.
	a := self newArrayFrom: #((51 55) (14 19) (0 4)).
	a atTuple: #(2 2) put: 99.
	self assertCollection: a array equals: #(51 55 14 99 0 4) asFloatArray.
	a := self newArrayFrom: #((51 55) (14 19) (0 4)).
	a atTuple: #(3 1) put: 99.
	self assertCollection: a array equals: #(51 55 14 19 99 4) asFloatArray.
	a := self newArrayFrom: #((51 55) (14 19) (0 4)).
	a atTuple: 1 put: 99.
	self assertCollection: a array equals: #(99 99 14 19 0 4) asFloatArray.
	a := self newArrayFrom: #((51 55) (14 19) (0 4)).
	a atTuple: 2 put: 99.
	self assertCollection: a array equals: #(51 55 99 99 0 4) asFloatArray.
	a := self newArrayFrom: #((51 55) (14 19) (0 4)).
	a atTuple: 3 put: 99.
	self assertCollection: a array equals: #(51 55 14 19 99 99) asFloatArray.
	a := self newArrayFrom: #(10 20 30).
	a atTuple: 1 put: 99.
	self assertCollection: a array equals: #(99 20 30) asFloatArray.
	a := self newArrayFrom: #(10 20 30).
	a atTuple: 2 put: 99.
	self assertCollection: a array equals: #(10 99 30) asFloatArray.
	a := self newArrayFrom: #(10 20 30).
	a atTuple: 3 put: 99.
	self assertCollection: a array equals: #(10 20 99) asFloatArray.
	a := self newArrayFrom: #((10 20 30) (40 50 60)).
	a atTuple: 1 put: #(1 2 3).
	self assertCollection: a array equals: #(1 2 3 40 50 60) asFloatArray.
	a := self newArrayFrom: #((10 20 30) (40 50 60)).
	a atTuple: 2 put: #(1 2 3).
	self assertCollection: a array equals: #(10 20 30 1 2 3) asFloatArray.
	a := self newArrayFrom: #(((10 20 30) (30 40 50)) ((40 50 60) (60 70 80))).
	a atTuple: #(1 1 1) put: 99.
	self assertCollection: a array equals: #(99 20 30 30 40 50 40 50 60 60 70 80) asFloatArray.
	a atTuple: #(2 1 2) put: 99.
	self assertCollection: a array equals: #(99 20 30 30 40 50 40 99 60 60 70 80) asFloatArray.
	a atTuple: #(2 2 3) put: 99.
	self assertCollection: a array equals: #(99 20 30 30 40 50 40 99 60 60 70 99) asFloatArray.
	a atTuple: 1 put: 88.
	self assertCollection: a array equals: #(88 88 88 88 88 88 40 99 60 60 70 99) asFloatArray.
	a atTuple: 2 put: #(1 2 3).
	self assertCollection: a array equals: #(88 88 88 88 88 88 1 2 3 1 2 3) asFloatArray
]

{ #category : #test }
TNDArrayAccessorsTest >> testAtTuples [
	| a r |
	a := self newArrayFrom: #(#(10 20) #(30 40) #(50 60)).
	r := a atTuples: #(#(3 1) #(2 1)).
	self assertCollection: r array equals: #(60 10) asFloatArray.
	self assertCollection: r shape equals: #(2).
	r := a atTuples: #(#(1 2 3) #(2)).
	self assertCollection: r array equals: #(20 40 60) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self should: [ a atTuple: #(#(1 2 3) #(1 2)) ] raise: Error.
	a := self
		newArrayFrom: #(#(#(10 20) #(30 40)) #(#(50 60) #(70 80)) #(#(90 100) #(110 120))).
	r := a atTuples: #(#(3 1) #(2 2)).
	self assertCollection: r array equals: #(110 120 30 40) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	r := a atTuples: #(#(3 1) #(2 2) #(1 1)).
	self assertCollection: r array equals: #(110 30) asFloatArray.
	self assertCollection: r shape equals: #(2)
]

{ #category : #test }
TNDArrayAccessorsTest >> testAtTuplesPut [
	| a |
	a := self newArrayFrom: #((10 20) (30 40) (50 60)).
	a atTuples: #((3 1) (2 1)) put: 99.
	self assertCollection: a array equals: #(99 20 30 40 50 99) asFloatArray.
	a := self newArrayFrom: #((10 20) (30 40) (50 60)).
	a atTuples: #(#(1 2 3) #(2)) put: 99.
	self assertCollection: a array equals: #(10 99 30 99 50 99) asFloatArray.
	self should: [ a atTuple: #(#(1 2 3) #(1 2)) put: 99 ] raise: Error.
	a := self newArrayFrom: #(((10 20) (30 40)) ((50 60) (70 80)) ((90 100) (110 120))).
	a atTuples: #((3 1) (2 2)) put: #(99 98).
	self assertCollection: a array equals: #(10 20 99 98 50 60 70 80 90 100 99 98) asFloatArray.
	a := self newArrayFrom: #(((10 20) (30 40)) ((50 60) (70 80)) ((90 100) (110 120))).
	a atTuples: #((3 1) (2 2) (1 1)) put: 99.
	self assertCollection: a array equals: #(10 20 99 40 50 60 70 80 90 100 99 120) asFloatArray
]

{ #category : #test }
TNDArrayAccessorsTest >> testIndexAt [
	| a |
	a := self newArrayFrom: #(10 20 30 40 50).
	self assertCollection: (a indexAt: 3) equals: #(3).
	a := self newArrayFrom: #((10 20) (30 40) (50 60)).
	self assertCollection: (a indexAt: 3) equals: #(2 1).
	a := self newArrayFrom: #(((10 20) (30 40)) ((50 60) (70 80))).
	self assertCollection: (a indexAt: 7) equals: #(2 2 1).
	self assert: (a at: (a indexAt: 1)) equals: 10.
	self assert: (a at: (a indexAt: 2)) equals: 20.
	self assert: (a at: (a indexAt: 3)) equals: 30.
	self assert: (a at: (a indexAt: 4)) equals: 40.
	self assert: (a at: (a indexAt: 5)) equals: 50.
	self assert: (a at: (a indexAt: 6)) equals: 60.
	self assert: (a at: (a indexAt: 7)) equals: 70.
	self assert: (a at: (a indexAt: 8)) equals: 80
]

{ #category : #test }
TNDArrayAccessorsTest >> testWhere [
	| a r |
	a := self newArrayFrom: #(true false true false) dtype: #Boolean.
	r := a where.
	self assert: r isArray.
	self assert: r size equals: 1.
	self assert: (r first isKindOf: NDArray).
	self assertCollection: r first array equals: #(1 3) asIntegerArray.
	self assertCollection: r first shape equals: #(2).
	self assert: r first dtype equals: #Integer.
	a := self newArrayFrom: #((true false false) (false true true)) dtype: #Boolean.
	r := a where.
	self assert: r isArray.
	self assert: r size equals: 2.
	self assert: (r first isKindOf: NDArray).
	self assertCollection: r first array equals: #(1 2 2) asIntegerArray.
	self assertCollection: r first shape equals: #(3).
	self assert: r first dtype equals: #Integer.
	self assert: (r second isKindOf: NDArray).
	self assertCollection: r second array equals: #(1 2 3) asIntegerArray.
	self assertCollection: r second shape equals: #(3).
	self assert: r second dtype equals: #Integer.
	a := self newArrayFrom: #(((false true) (false false)) ((true false) (true true))) dtype: #Boolean.
	r := a where.
	self assert: r isArray.
	self assert: r size equals: 3.
	self assert: (r first isKindOf: NDArray).
	self assertCollection: r first array equals: #(1 2 2 2) asIntegerArray.
	self assertCollection: r first shape equals: #(4).
	self assert: r first dtype equals: #Integer.
	self assert: (r second isKindOf: NDArray).
	self assertCollection: r second array equals: #(1 1 2 2) asIntegerArray.
	self assertCollection: r second shape equals: #(4).
	self assert: r second dtype equals: #Integer.
	self assert: (r third isKindOf: NDArray).
	self assertCollection: r third array equals: #(2 1 1 2) asIntegerArray.
	self assertCollection: r third shape equals: #(4).
	self assert: r third dtype equals: #Integer
]
