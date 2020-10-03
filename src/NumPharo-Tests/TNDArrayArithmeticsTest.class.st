"
A TNDArrayArithmeticsTest is a test class for testing the behavior of TNDArrayArithmetics
"
Class {
	#name : #TNDArrayArithmeticsTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
TNDArrayArithmeticsTest >> newArrayFrom: anArray [
	^ NDArray fromArray: anArray dtype: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testCol [
	| a r |
	a := self newArrayFrom: #((1 2) (3 4) (5 6)).
	r := a col: 1.
	self assertCollection: r array equals: #(1 3 5) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float.
	r := a col: 2.
	self assertCollection: r array equals: #(2 4 6) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float.
	a := self newArrayFrom: #(1 2 3).
	self should: [ a col: 1 ] raise: Error
]

{ #category : #test }
TNDArrayArithmeticsTest >> testDot [
	| a b r |
	a := self newArrayFrom: #(#(1 2) #(3 4)).
	b := self newArrayFrom: #(#(5 6) #(7 8)).
	r := a dot: b.
	self assertCollection: r array equals: #(19 22 43 50) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	self assert: r dtype equals: #Float.
	a := self newArrayFrom: #(#(1 2 3) #(4 5 6)).
	b := self newArrayFrom: #(#(1 2) #(3 4) #(5 6)).
	r := a dot: b.
	self assertCollection: r array equals: #(22 28 49 64) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	self assert: r dtype equals: #Float.
	a := self newArrayFrom: #(#(1 2) #(3 4) #(5 6)).
	b := self newArrayFrom: #(7 8).
	r := a dot: b.
	self assertCollection: r array equals: #(23 53 83) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float.
	a := self newArrayFrom: #(1 2).
	b := self newArrayFrom: #(#(1 3 5) #(2 4 6)).
	r := a dot: b.
	self assertCollection: r array equals: #(5 11 17) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float.
	a := self newArrayFrom: #(#(1 2 3) #(4 5 6)).
	b := self newArrayFrom: #(#(1 2) #(3 4)).
	self should: [ a dot: b ] raise: Error
]

{ #category : #test }
TNDArrayArithmeticsTest >> testMinMax [
	| a r |
	a := self newArrayFrom: #(-1 -2 0 1 3).
	r := a min: 2 max: -1.
	self assertCollection: r array equals: #(-1 -1 0 1 2) asFloatArray.
	self assertCollection: r shape equals: #(5).
	self assertCollection: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testMinus [
	| x y r |
	x := self newArrayFrom: #(1 2 3).
	y := self newArrayFrom: #(2 4 6).
	r := x - y.
	self assertCollection: r array equals: #(-1 -2 -3) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assertCollection: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testPlus [
	| x y r |
	x := self newArrayFrom: #(1 2 3).
	y := self newArrayFrom: #(2 4 6).
	r := x + y.
	self assertCollection: r array equals: #(3 6 9) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assertCollection: r dtype equals: #Float.
	x := self newArrayFrom: #((1 2) (3 4)).
	y := self newArrayFrom: #((3 0) (0 6)).
	r := x + y.
	self assertCollection: r array equals: #(4 2 3 10) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	self assertCollection: r dtype equals: #Float.
	x := self newArrayFrom: #(1.0 2.0 3.0).
	y := self newArrayFrom: #((10.0 20.0 30.0) (40.0 50.0 60.0)).
	r := x + y.
	self assertCollection: r array equals: #(11 22 33 41 52 63) asFloatArray.
	self assertCollection: r shape equals: #(2 3).
	self assertCollection: r dtype equals: #Float.
	r := y + x.
	self assertCollection: r array equals: #(11 22 33 41 52 63) asFloatArray.
	self assertCollection: r shape equals: #(2 3).
	self assertCollection: r dtype equals: #Float.
	y := self newArrayFrom: #(((10.0 20.0 30.0) (40.0 50.0 60.0))).
	r := x + y.
	self assertCollection: r array equals: #(11 22 33 41 52 63) asFloatArray.
	self assertCollection: r shape equals: #(1 2 3).
	self assertCollection: r dtype equals: #Float.
	y := self newArrayFrom: #(9.0 8.0).
	self should: [ x + y ] raise: Error.
	self should: [ y + x ] raise: Error.
	x := NDArray fromArray: #((1 2) (3 4)) dtype: #Integer.
	y := NDArray fromArray: #(10 20) dtype: #Float.
	r := x + y.
	self assertCollection: r array equals: #(11 22 13 24) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testRow [
	| a r |
	a := self newArrayFrom: #((1 2) (3 4) (5 6)).
	r := a row: 1.
	self assertCollection: r array equals: #(1 2) asFloatArray.
	self assertCollection: r shape equals: #(2).
	self assert: r dtype equals: #Float.
	r := a row: 2.
	self assertCollection: r array equals: #(3 4) asFloatArray.
	self assertCollection: r shape equals: #(2).
	self assert: r dtype equals: #Float.
	r := a row: 3.
	self assertCollection: r array equals: #(5 6) asFloatArray.
	self assertCollection: r shape equals: #(2).
	self assert: r dtype equals: #Float.
	a := self newArrayFrom: #(1 2 3).
	self should: [ a row: 1 ] raise: Error
]

{ #category : #test }
TNDArrayArithmeticsTest >> testSlash [
	| x y r |
	x := self newArrayFrom: #(1 2 3).
	y := self newArrayFrom: #(2 4 6).
	r := x / y.
	self assertCollection: r array equals: #(0.5 0.5 0.5) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assertCollection: r dtype equals: #Float.
	r := x / 2.
	self assertCollection: r array equals: #(0.5 1 1.5) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assertCollection: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testStar [
	| x y r |
	x := self newArrayFrom: #(1 2 3).
	y := self newArrayFrom: #(2 4 6).
	r := x * y.
	self assertCollection: r array equals: #(2 8 18) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assertCollection: r dtype equals: #Float.
	x := self newArrayFrom: #((1 2) (3 4)).
	y := self newArrayFrom: #((3 0) (0 6)).
	r := x * y.
	self assertCollection: r array equals: #(3 0 0 24) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	self assertCollection: r dtype equals: #Float.
	r := x * 10.
	self assertCollection: r array equals: #(10 20 30 40) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	self assertCollection: r dtype equals: #Float
]
