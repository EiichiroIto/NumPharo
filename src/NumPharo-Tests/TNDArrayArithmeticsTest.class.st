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

{ #category : #private }
TNDArrayArithmeticsTest >> newArrayFrom: anArray dtype: aSymbol [
	^ NDArray fromArray: anArray dtype: aSymbol
]

{ #category : #test }
TNDArrayArithmeticsTest >> testArgIndexAxis [
	| a |
	a := self newArrayFrom: #(#(1 2) #(3 4) #(5 6)).
	self assertCollection: (a argIndexAxis: 1) equals: #(1 2).
	self assertCollection: (a argIndexAxis: 2) equals: #(1 3 5).
	a := self
		newArrayFrom: #(#(#(1 2) #(3 4) #(5 6)) #(#(7 6) #(5 4) #(3 2))).
	self assertCollection: (a argIndexAxis: 1) equals: #(1 2 3 4 5 6).
	self assertCollection: (a argIndexAxis: 2) equals: #(1 2 7 8).
	self assertCollection: (a argIndexAxis: 3) equals: #(1 3 5 7 9 11).
	a := self
		newArrayFrom:
			#(#(#(#(0 1 2) #(3 4 5)) #(#(6 7 8) #(9 10 11)) #(#(12 13 14) #(15 16 17))) #(#(#(18 19 20) #(21 22 23)) #(#(24 25 26) #(27 28 29)) #(#(30 31 32) #(33 34 35)))).
	self
		assertCollection: (a argIndexAxis: 1)
		equals: #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18).
	self
		assertCollection: (a argIndexAxis: 2)
		equals: #(1 2 3 4 5 6 19 20 21 22 23 24).
	self
		assertCollection: (a argIndexAxis: 3)
		equals: #(1 2 3 7 8 9 13 14 15 19 20 21 25 26 27 31 32 33).
	self
		assertCollection: (a argIndexAxis: 4)
		equals: #(1 4 7 10 13 16 19 22 25 28 31 34)
]

{ #category : #test }
TNDArrayArithmeticsTest >> testArgMax [
	| a |
	a := self newArrayFrom: #(5 3 1 2 6 2 4).
	self assert: a argMax equals: 5.
	a := self newArrayFrom: #(1 2 3 2 1 2 3).
	self assert: a argMax equals: 3.
	a := self newArrayFrom: #(9 2 3 2 1 2 3).
	self assert: a argMax equals: 1.
	a := self newArrayFrom: #(9 2 3 2 1 2 30).
	self assert: a argMax equals: 7
]

{ #category : #test }
TNDArrayArithmeticsTest >> testArgMaxAxis [
	| a r |
	a := self newArrayFrom: #((1 2) (3 4) (5 6)).
	self assertCollection: a shape equals: #(3 2).
	r := a argMaxAxis: 1.
	self assertCollection: r array equals: #(3 3) asIntegerArray.
	self assertCollection: r shape equals: #(2).
	r := a argMaxAxis: 2.
	self assertCollection: r array equals: #(2 2 2) asIntegerArray.
	self assertCollection: r shape equals: #(3).
	a := self newArrayFrom: #(((1 2) (3 4) (5 6)) ((7 6) (5 4) (3 2))).
	self assertCollection: a shape equals: #(2 3 2).
	r := a argMaxAxis: 1.
	self assertCollection: r array equals: #(2 2 2 1 1 1) asIntegerArray.
	self assertCollection: r shape equals: #(3 2).
	r := a argMaxAxis: 2.
	self assertCollection: r array equals: #(3 3 1 1) asIntegerArray.
	self assertCollection: r shape equals: #(2 2).
	r := a argMaxAxis: 3.
	self assertCollection: r array equals: #(2 2 2 1 1 1) asIntegerArray.
	self assertCollection: r shape equals: #(2 3)
]

{ #category : #test }
TNDArrayArithmeticsTest >> testAverage [
	| n |
	n := self newArrayFrom: #(1 2 3 4 5 6).
	self assert: n average equals: 3.5
]

{ #category : #test }
TNDArrayArithmeticsTest >> testAverageAxis [
	| a r |
	a := self newArrayFrom: #((1 2) (3 4) (5 6)).
	self assertCollection: a shape equals: #(3 2).
	r := a averageAxis: 0.
	self assert: r equals: 3.5.
	r := a averageAxis: 1.
	self assertCollection: r array equals: #(3 4) asFloatArray.
	self assertCollection: r shape equals: #(2).
	r := a averageAxis: 2.
	self assertCollection: r array equals: #(1.5 3.5 5.5) asFloatArray.
	self assertCollection: r shape equals: #(3)
]

{ #category : #test }
TNDArrayArithmeticsTest >> testBackslashBackslash [
	| a r |
	a := self newArrayFrom: #(1 2 3 4 5 6 7).
	r := a \\ 3.
	self assertCollection: r array equals: #(1 2 0 1 2 0 1) asFloatArray.
	self assertCollection: r shape equals: #(7).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testCol2DArrayDtype [
	| a r |
	a := self newArrayFrom: #((1 2) (3 4) (5 6)).
	r := a col2DArray: 1 dtype: #Float.
	self assertCollection: r equals: #(1 3 5) asFloatArray.
	r := a col2DArray: 2 dtype: #Float.
	self assertCollection: r equals: #(2 4 6) asFloatArray.
	self should: [ a col2DArray: 3 dtype: #Float ] raise: Error
]

{ #category : #test }
TNDArrayArithmeticsTest >> testCos [
	| a r |
	a := self newArrayFrom: {0. Float pi / 2. Float pi}.
	r := a cos.
	self assert: r array first closeTo: 1.
	self assert: r array second closeTo: 0.
	self assert: r array third closeTo: -1.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testDigitizeRight [
	| a bins r |
	a := self newArrayFrom: #(0.2 6.4 3.0 1.6).
	bins := self newArrayFrom: #(0.0 1.0 2.5 4.0 10.0).
	r := a digitize: bins right: false.
	self assertCollection: r array equals: #(2 5 4 3) asIntegerArray.
	a := self newArrayFrom: #(1.2 10.0 12.4 15.5 20.0).
	bins := self newArrayFrom: #(0 5 10 15 20).
	r := a digitize: bins right: false.
	self assertCollection: r array equals: #(2 4 4 5 6) asIntegerArray.
	r := a digitize: bins right: true.
	self assertCollection: r array equals: #(2 3 4 5 5) asIntegerArray.
	a := self newArrayFrom: #(20 77 23 -50 -18 -80 -17 45 66 83).
	bins := self newArrayFrom: #(-50 -10 0 10 50).
	r := a digitize: bins right: false.
	self
		assertCollection: r array
		equals: #(5 6 5 2 2 1 2 5 6 6) asIntegerArray
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
TNDArrayArithmeticsTest >> testEqualsSign [
	| a b r |
	a := self newArrayFrom: #(1 2 3).
	b := self newArrayFrom: #(3 2 1).
	r := a = b.
	self assertCollection: r array equals: #(false true false).
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Boolean
]

{ #category : #test }
TNDArrayArithmeticsTest >> testExp [
	| a r |
	a := self newArrayFrom: #(1 2 3).
	r := a exp.
	self assert: r array first closeTo: 2.7182817459106445.
	self assert: r array second closeTo: 7.389056205749512.
	self assert: r array third closeTo: 20.08553695678711.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testGreaterThan [
	| a b r |
	a := self newArrayFrom: #(1 2 3).
	b := self newArrayFrom: #(3 2 1).
	r := a > b.
	self assertCollection: r array equals: #(false false true).
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Boolean
]

{ #category : #test }
TNDArrayArithmeticsTest >> testGreaterThanEqualsSign [
	| a b r |
	a := self newArrayFrom: #(1 2 3).
	b := self newArrayFrom: #(3 2 1).
	r := a >= b.
	self assertCollection: r array equals: #(false true true).
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Boolean
]

{ #category : #test }
TNDArrayArithmeticsTest >> testHstack [
	| a b r |
	a := NDArray arangeFrom: 0 to: 11 by: 1.
	b := NDArray arangeFrom: 0 to: 5 by: 1.
	r := a hstack: b.
	self
		assertCollection: r array
		equals: #(0 1 2 3 4 5 6 7 8 9 10 11 0 1 2 3 4 5) asIntegerArray.
	self assertCollection: r shape equals: #(18).
	a := a withShape: #(2 2 3).
	b := b withShape: #(2 1 3).
	r := a hstack: b.
	self
		assertCollection: r array
		equals: #(0 1 2 3 4 5 0 1 2 6 7 8 9 10 11 3 4 5) asIntegerArray.
	self assertCollection: r shape equals: #(2 3 3).
	a := self newArrayFrom: #(1 2 3).
	b := self newArrayFrom: #(2 3 4).
	r := a hstack: b.
	self assertCollection: r array equals: #(1 2 3 2 3 4) asFloatArray.
	self assertCollection: r shape equals: #(6).
	a := self newArrayFrom: #((1) (2) (3)).
	b := self newArrayFrom: #((2) (3) (4)).
	r := a hstack: b.
	self assertCollection: r array equals: #(1 2 2 3 3 4) asFloatArray.
	self assertCollection: r shape equals: #(3 2)

]

{ #category : #test }
TNDArrayArithmeticsTest >> testItemSizeAxis [
	| a |
	a := NDArray ones: #(2 4 1 3 2) dtype: #Integer.
	self assert: (a itemSizeAxis: 3) equals: 6.
	self assert: (a itemSizeAxis: 1) equals: 24.
	self assert: (a itemSizeAxis: 5) equals: 1
]

{ #category : #test }
TNDArrayArithmeticsTest >> testLessThan [
	| a b r |
	a := self newArrayFrom: #(1 2 3).
	b := self newArrayFrom: #(3 2 1).
	r := a < b.
	self assertCollection: r array equals: #(true false false).
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Boolean
]

{ #category : #test }
TNDArrayArithmeticsTest >> testLessThanEqualsSign [
	| a b r |
	a := self newArrayFrom: #(1 2 3).
	b := self newArrayFrom: #(3 2 1).
	r := a <= b.
	self assertCollection: r array equals: #(true true false).
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Boolean
]

{ #category : #test }
TNDArrayArithmeticsTest >> testLn [
	| a r |
	a := self newArrayFrom: {1. Float e. Float e * Float e}.
	r := a ln.
	self assert: r array first closeTo: 0.
	self assert: r array second closeTo: 1.
	self assert: r array third closeTo: 2.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testLog [
	| a r |
	a := self newArrayFrom: {1. 10. 100}.
	r := a log.
	self assert: r array first closeTo: 0.
	self assert: r array second closeTo: 1.
	self assert: r array third closeTo: 2.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testMax [
	| a b r |
	a := self newArrayFrom: #(1 2 3).
	r := a max.
	self assert: r equals: 3
]

{ #category : #test }
TNDArrayArithmeticsTest >> testMaxAxis [
	| a r |
	a := self newArrayFrom: #((1 2) (3 4) (5 60)).
	self assertCollection: a shape equals: #(3 2).
	r := a maxAxis: 0.
	self assert: r equals: 60.
	r := a maxAxis: 1.
	self assertCollection: r array equals: #(5 60) asFloatArray.
	self assertCollection: r shape equals: #(2).
	r := a maxAxis: 2.
	self assertCollection: r array equals: #(2 4 60) asFloatArray.
	self assertCollection: r shape equals: #(3).
	a := self newArrayFrom: #(((1 2) (3 4) (5 6)) ((7 6) (5 4) (3 2))).
	self assertCollection: a shape equals: #(2 3 2).
	r := a maxAxis: 1.
	self assertCollection: r array equals: #(7 6 5 4 5 6) asFloatArray.
	self assertCollection: r shape equals: #(3 2).
	r := a maxAxis: 2.
	self assertCollection: r array equals: #(5 6 7 6) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	r := a maxAxis: 3.
	self assertCollection: r array equals: #(2 4 6 7 5 3) asFloatArray.
	self assertCollection: r shape equals: #(2 3)
]

{ #category : #test }
TNDArrayArithmeticsTest >> testMaximum [
	| a b r |
	a := self newArrayFrom: #(1 2 3).
	b := self newArrayFrom: #(3 2 1).
	r := a maximum: b.
	self assertCollection: r array equals: #(3 2 3) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testMin [
	| a b r |
	a := self newArrayFrom: #(1 2 3).
	r := a min.
	self assert: r equals: 1
]

{ #category : #test }
TNDArrayArithmeticsTest >> testMinAxis [
	| a r |
	a := self newArrayFrom: #((1 2) (3 4) (5 6)).
	self assertCollection: a shape equals: #(3 2).
	r := a minAxis: 1.
	self assertCollection: r array equals: #(1 2) asFloatArray.
	self assertCollection: r shape equals: #(2).
	r := a minAxis: 2.
	self assertCollection: r array equals: #(1 3 5) asFloatArray.
	self assertCollection: r shape equals: #(3).
	a := self newArrayFrom: #(((1 2) (3 4) (5 6)) ((7 6) (5 4) (3 2))).
	self assertCollection: a shape equals: #(2 3 2).
	r := a minAxis: 1.
	self assertCollection: r array equals: #(1 2 3 4 3 2) asFloatArray.
	self assertCollection: r shape equals: #(3 2).
	r := a minAxis: 2.
	self assertCollection: r array equals: #(1 2 3 2) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	r := a minAxis: 3.
	self assertCollection: r array equals: #(1 3 5 6 4 2) asFloatArray.
	self assertCollection: r shape equals: #(2 3)
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
TNDArrayArithmeticsTest >> testMinimum [
	| a b r |
	a := self newArrayFrom: #(1 2 3).
	b := self newArrayFrom: #(3 2 1).
	r := a minimum: b.
	self assertCollection: r array equals: #(1 2 1) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float
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
TNDArrayArithmeticsTest >> testNegated [
	| a r |
	a := self newArrayFrom: #(1 2 -3).
	r := a negated.
	self assertCollection: r array equals: #(-1 -2 3) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testOmitBeforeAfter [
	| a r |
	a := self newArrayFrom: #(1 2 3 4 5 6).
	r := a omitBefore: 1 after: 2.
	self assertCollection: r array equals: #(2 3 4) asFloatArray.
	self assertCollection: r shape equals: #(3).
	a := self
		newArrayFrom: #(#(1 1 2 3 3) #(1 1 2 3 3) #(4 4 5 6 6) #(7 7 8 9 9) #(7 7 8 9 9)).
	r := a omitBefore: 1 after: 1.
	self assertCollection: r array equals: #(1 2 3 4 5 6 7 8 9) asFloatArray.
	self assertCollection: r shape equals: #(3 3)
]

{ #category : #test }
TNDArrayArithmeticsTest >> testPadBeforeAfter [
	| a r |
	a := self newArrayFrom: #(#(1 2 3) #(4 5 6) #(7 8 9)).
	r := a padBefore: 1 after: 1.
	self
		assertCollection: r array
		equals: #(0 0 0 0 0 0 1 2 3 0 0 4 5 6 0 0 7 8 9 0 0 0 0 0 0) asFloatArray.
	self assertCollection: r shape equals: #(5 5)
]

{ #category : #test }
TNDArrayArithmeticsTest >> testPadEdgeBeforeAfter [
	| a r |
	a := self newArrayFrom: #(#(1 2 3) #(4 5 6) #(7 8 9)).
	r := a padEdgeBefore: 1 after: 1.
	self
		assertCollection: r array
		equals: #(1 1 2 3 3 1 1 2 3 3 4 4 5 6 6 7 7 8 9 9 7 7 8 9 9) asFloatArray.
	self assertCollection: r shape equals: #(5 5)
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
TNDArrayArithmeticsTest >> testPrivRollAxis [
	| a r |
	a := self newArrayFrom: #(0 1 2 3 4 5 6 7 8 9).
	r := a privRoll: 3 axis: 1.
	self
		assertCollection: r array
		equals: #(7 8 9 0 1 2 3 4 5 6) asFloatArray.
	self assertCollection: r shape equals: #(10).
	self assert: r dtype equals: #Float.
	r := a privRoll: -3 axis: 1.
	self
		assertCollection: r array
		equals: #(3 4 5 6 7 8 9 0 1 2) asFloatArray.
	self assertCollection: r shape equals: #(10).
	self assert: r dtype equals: #Float.
	r := a privRoll: 12 axis: 1.
	self
		assertCollection: r array
		equals: #(8 9 0 1 2 3 4 5 6 7) asFloatArray.
	self assertCollection: r shape equals: #(10).
	self assert: r dtype equals: #Float.
	a := self newArrayFrom: #(#(0 1 2 3) #(4 5 6 7) #(8 9 10 11)).
	r := a privRoll: 1 axis: 1.
	self
		assertCollection: r array
		equals: #(8 9 10 11 0 1 2 3 4 5 6 7) asFloatArray.
	self assertCollection: r shape equals: #(3 4).
	self assert: r dtype equals: #Float.
	r := a privRoll: 2 axis: 2.
	self
		assertCollection: r array
		equals: #(2 3 0 1 6 7 4 5 10 11 8 9) asFloatArray.
	self assertCollection: r shape equals: #(3 4).
	self assert: r dtype equals: #Float.
	r := a privRoll: 5 axis: 0.
	self
		assertCollection: r array
		equals: #(7 8 9 10 11 0 1 2 3 4 5 6) asFloatArray.
	self assertCollection: r shape equals: #(3 4).
	self assert: r dtype equals: #Float.
	a := NDArray arangeFrom: 0 to: 23 by: 1.0.
	a reShape: #(2 3 4).
	r := a privRoll: 3 axis: 0.
	self
		assertCollection: r array
		equals:
			#(21 22 23 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)
				asFloatArray.
	self assertCollection: r shape equals: #(2 3 4).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testRoll [
	| a r |
	a := self newArrayFrom: #(0 1 2 3 4 5 6 7 8 9).
	r := a roll: 3.
	self
		assertCollection: r array
		equals: #(7 8 9 0 1 2 3 4 5 6) asFloatArray.
	self assertCollection: r shape equals: #(10).
	self assert: r dtype equals: #Float.
	r := a roll: -3.
	self
		assertCollection: r array
		equals: #(3 4 5 6 7 8 9 0 1 2) asFloatArray.
	self assertCollection: r shape equals: #(10).
	self assert: r dtype equals: #Float.
	r := a roll: 12.
	self
		assertCollection: r array
		equals: #(8 9 0 1 2 3 4 5 6 7) asFloatArray.
	self assertCollection: r shape equals: #(10).
	self assert: r dtype equals: #Float.
	a := self newArrayFrom: #(#(0 1 2 3) #(4 5 6 7) #(8 9 10 11)).
	r := a roll: 2.
	self
		assertCollection: r array
		equals: #(10 11 0 1 2 3 4 5 6 7 8 9) asFloatArray.
	self assertCollection: r shape equals: #(3 4).
	self assert: r dtype equals: #Float.
	r := a roll: 5.
	self
		assertCollection: r array
		equals: #(7 8 9 10 11 0 1 2 3 4 5 6) asFloatArray.
	self assertCollection: r shape equals: #(3 4).
	self assert: r dtype equals: #Float.
	a := NDArray arangeFrom: 0 to: 23 by: 1.0.
	a reShape: #(2 3 4).
	r := a roll: 3.
	self
		assertCollection: r array
		equals:
			#(21 22 23 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)
				asFloatArray.
	self assertCollection: r shape equals: #(2 3 4).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testRollAxes [
	| a r |
	a := self newArrayFrom: #(#(0 1 2 3) #(4 5 6 7) #(8 9 10 11)).
	r := a roll: 1 axes: 1.
	self
		assertCollection: r array
		equals: #(8 9 10 11 0 1 2 3 4 5 6 7) asFloatArray.
	self assertCollection: r shape equals: #(3 4).
	self assert: r dtype equals: #Float.
	r := a roll: 2 axes: 2.
	self
		assertCollection: r array
		equals: #(2 3 0 1 6 7 4 5 10 11 8 9) asFloatArray.
	self assertCollection: r shape equals: #(3 4).
	self assert: r dtype equals: #Float.
	r := a roll: #(1 2) axes: #(1 2).
	self
		assertCollection: r array
		equals: #(10 11 8 9 2 3 0 1 6 7 4 5) asFloatArray.
	self assertCollection: r shape equals: #(3 4).
	self assert: r dtype equals: #Float.
	a := NDArray arangeFrom: 0 to: 23 by: 1.0.
	a reShape: #(2 3 4).
	r := a roll: 2 axes: 3.
	self
		assertCollection: r array
		equals:
			#(2 3 0 1 6 7 4 5 10 11 8 9 14 15 12 13 18 19 16 17 22 23 20 21)
				asFloatArray.
	self assertCollection: r shape equals: #(2 3 4).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testRow2DArrayDtype [
	| a r |
	a := self newArrayFrom: #((1 2) (3 4) (5 6)).
	r := a row2DArray: 1 dtype: #Float.
	self assertCollection: r equals: #(1 2) asFloatArray.
	r := a row2DArray: 2 dtype: #Float.
	self assertCollection: r equals: #(3 4) asFloatArray.
	r := a row2DArray: 3 dtype: #Float.
	self assertCollection: r equals: #(5 6) asFloatArray.
	self should: [ a row2DArray: 4 dtype: #Float ] raise: Error
]

{ #category : #test }
TNDArrayArithmeticsTest >> testShapeForHstack [
	| a b |
	a := self newArrayFrom: #(1 2 3).
	b := self newArrayFrom: #(4 5).
	self assertCollection: (a shapeForHstack: b) equals: #(5).
	self assertCollection: (b shapeForHstack: a) equals: #(5).
	b := self newArrayFrom: #(#(4 5)).
	self assert: (a shapeForHstack: b) isNil.
	self assert: (b shapeForHstack: a) isNil.
	a := self newArrayFrom: #((1 2 3) (4 5 6)).
	b := self newArrayFrom: #((1 2 3 4) (5 6 7 8)).
	self assertCollection: (a shapeForHstack: b) equals: #(2 7).
	self assertCollection: (b shapeForHstack: a) equals: #(2 7).
	a := self newArrayFrom: #((1 2 3) (4 5 6)).
	b := self newArrayFrom: #((1 2) (3 4) (5 6) (7 8)).
	self assert: (a shapeForHstack: b) isNil.
	self assert: (b shapeForHstack: a) isNil.
	a := self newArrayFrom: #((1 2) (3 4)).
	b := self newArrayFrom: #((1 2 3) (4 5 6)).
	self assertCollection: (a shapeForHstack: b) equals: #(2 5).
	self assertCollection: (b shapeForHstack: a) equals: #(2 5).
	a := self newArrayFrom: #((1 2) (3 4)).
	b := self newArrayFrom: #((1 2) (3 4) (5 6)).
	self assert: (a shapeForHstack: b) isNil.
	self assert: (b shapeForHstack: a) isNil.
	a := NDArray ones: #(1 2 3) dtype: #Integer.
	b := NDArray ones: #(1 4 3) dtype: #Integer.
	self assertCollection: (a shapeForHstack: b) equals: #(1 6 3).
	self assertCollection: (b shapeForHstack: a) equals: #(1 6 3).
	a := NDArray ones: #(1 2 3) dtype: #Integer.
	b := NDArray ones: #(2 2 3) dtype: #Integer.
	self assert: (a shapeForHstack: b) isNil.
	self assert: (b shapeForHstack: a) isNil.
	a := NDArray ones: #(2 5 3 2) dtype: #Integer.
	b := NDArray ones: #(2 9 3 2) dtype: #Integer.
	self assertCollection: (a shapeForHstack: b) equals: #(2 14 3 2).
	self assertCollection: (b shapeForHstack: a) equals: #(2 14 3 2).
	a := NDArray ones: #(2 5 3 2) dtype: #Integer.
	b := NDArray ones: #(2 5 9 2) dtype: #Integer.
	self assert: (a shapeForHstack: b) isNil.
	self assert: (b shapeForHstack: a) isNil
]

{ #category : #test }
TNDArrayArithmeticsTest >> testSin [
	| a r |
	a := self newArrayFrom: {0. Float pi / 2. Float pi}.
	r := a sin.
	self assert: r array first closeTo: 0.
	self assert: r array second closeTo: 1.
	self assert: r array third closeTo: 0.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float
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

{ #category : #test }
TNDArrayArithmeticsTest >> testStarStar [
	| x y r |
	x := self newArrayFrom: #(1 2 3).
	r := x ** 2.
	self assertCollection: r array equals: #(1 4 9) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assertCollection: r dtype equals: #Float.
	y := self newArrayFrom: #(3 4 5).
	r := x ** y.
	self assertCollection: r array equals: #(1 16 243) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assertCollection: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testStd [
	| n |
	n := self newArrayFrom: #(1 2 3 4 5 6).
	self assert: n std closeTo: 1.707825127659933
]

{ #category : #test }
TNDArrayArithmeticsTest >> testStdAxis [
	| a r |
	a := self newArrayFrom: #(#(1 2) #(3 4) #(5 6)).
	self assertCollection: a shape equals: #(3 2).
	r := a stdAxis: 0.
	self assert: r closeTo: 1.7078251276599332.
	r := a stdAxis: 1.
	self
		assertCollection: r array
		equals: #(1.6329931618554523 1.6329931618554523) asFloatArray.
	self assertCollection: r shape equals: #(2).
	r := a stdAxis: 2.
	self assertCollection: r array equals: #(0.5 0.5 0.5) asFloatArray.
	self assertCollection: r shape equals: #(3)
]

{ #category : #test }
TNDArrayArithmeticsTest >> testSum [
	| a |
	a := self newArrayFrom: #(1 2 3 4 5).
	self assert: a sum equals: 15.
	a := self newArrayFrom: #((1 2) (3 4) (5 6)).
	self assert: a sum equals: 21.
	a := self newArrayFrom: #(true false true false true) dtype: #Boolean.
	self assert: a sum equals: 3
]

{ #category : #test }
TNDArrayArithmeticsTest >> testSumAxis [
	| a r |
	a := self newArrayFrom: #((1 2 3) (4 5 6)).
	r := a sumAxis: 0.
	self assert: r equals: a sum.
	r := a sumAxis: 1.
	self assertCollection: r array equals: #(5 7 9) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float.
	r := a sumAxis: 2.
	self assertCollection: r array equals: #(6 15) asFloatArray.
	self assertCollection: r shape equals: #(2).
	self assert: r dtype equals: #Float
]

{ #category : #test }
TNDArrayArithmeticsTest >> testT [
	| a r |
	a := self newArrayFrom: #(1 2 3).
	r := a t.
	self assertCollection: r array equals: #(1 2 3) asFloatArray.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Float.
	a := self newArrayFrom: #(#(1 2 3) #(4 5 6)).
	self assertCollection: a shape equals: #(2 3).
	r := a t.
	self assertCollection: r array equals: #(1 4 2 5 3 6) asFloatArray.
	self assertCollection: r shape equals: #(3 2).
	self assert: r dtype equals: #Float.
	a := self
		newArrayFrom:
			#(#(#(1 2 3 4) #(5 6 7 8) #(9 10 11 12)) #(#(13 14 15 16) #(17 18 19 20) #(21 22 23 24))).
	self assertCollection: a shape equals: #(2 3 4).
	r := a t.
	self
		assertCollection: r array
		equals:
			#(1 13 5 17 9 21 2 14 6 18 10 22 3 15 7 19 11 23 4 16 8 20 12 24)
				asFloatArray.
	self assertCollection: r shape equals: #(4 3 2).
	self assert: r dtype equals: #Float.
	a := NDArray arangeFrom: 1 to: 120 by: 1.
	a := a withShape: #(2 3 4 5).
	r := a t.
	self
		assertCollection: r array
		equals:
			#(1 61 21 81 41 101 6 66 26 86 46 106 11 71 31 91 51 111 16 76 36 96 56 116 2 62 22 82 42 102 7 67 27 87 47 107 12 72 32 92 52 112 17 77 37 97 57 117 3 63 23 83 43 103 8 68 28 88 48 108 13 73 33 93 53 113 18 78 38 98 58 118 4 64 24 84 44 104 9 69 29 89 49 109 14 74 34 94 54 114 19 79 39 99 59 119 5 65 25 85 45 105 10 70 30 90 50 110 15 75 35 95 55 115 20 80 40 100 60 120)
				asIntegerArray.
	self assertCollection: r shape equals: #(5 4 3 2).
	self assert: r dtype equals: #Integer
]

{ #category : #test }
TNDArrayArithmeticsTest >> testTildaEqualsSign [
	| a b r |
	a := self newArrayFrom: #(1 2 3).
	b := self newArrayFrom: #(3 2 1).
	r := a ~= b.
	self assertCollection: r array equals: #(true false true).
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Boolean
]

{ #category : #test }
TNDArrayArithmeticsTest >> testTranspose [
	| a r |
	a := NDArray arangeFrom: 0 to: 11 by: 1.
	a := a reShape: #(3 4).
	r := a transpose: #(1 2).
	self assertCollection: r array equals: a array.
	r := a transpose: #(2 1).
	self
		assertCollection: r array
		equals: #(0 4 8 1 5 9 2 6 10 3 7 11) asIntegerArray.
	a := NDArray arangeFrom: 0 to: 23 by: 1.
	a := a reShape: #(4 3 2).
	r := a transpose: #(1 2 3).
	self assertCollection: r array equals: a array.
	r := a transpose: #(2 1 3).
	self
		assertCollection: r array
		equals:
			#(0 1 6 7 12 13 18 19 2 3 8 9 14 15 20 21 4 5 10 11 16 17 22 23)
				asIntegerArray.
	a := self newArrayFrom: #((1 2 3) (4 5 6) (7 8 9)).
	r := a transpose: #(2 1).
	self assertCollection: r array equals: a t array.
	self assertCollection: r shape equals: a t shape
]

{ #category : #test }
TNDArrayArithmeticsTest >> testWrapCopyFromSizeOnAt [
	| a arr |
	a := #(1 2 3 4 5 6 7 8).
	arr := Array new: 4.
	a
		wrapCopyFrom: 2
		size: 4
		on: arr
		at: 1.
	self assertCollection: arr equals: #(2 3 4 5).
	arr := Array new: 4.
	a
		wrapCopyFrom: 6
		size: 4
		on: arr
		at: 1.
	self assertCollection: arr equals: #(6 7 8 1).
	arr := Array new: 4.
	a
		wrapCopyFrom: 8
		size: 4
		on: arr
		at: 1.
	self assertCollection: arr equals: #(8 1 2 3).
	arr := Array new: 4.
	a
		wrapCopyFrom: 9
		size: 4
		on: arr
		at: 1.
	self assertCollection: arr equals: #(1 2 3 4).
	arr := Array new: 4.
	a
		wrapCopyFrom: -1
		size: 4
		on: arr
		at: 1.
	self assertCollection: arr equals: #(7 8 1 2).
	arr := Array new: 6.
	a
		wrapCopyFrom: 2
		size: 4
		on: arr
		at: 2.
	self assertCollection: arr equals: #(nil 2 3 4 5 nil).
	arr := Array new: 6.
	a
		wrapCopyFrom: -1
		size: 4
		on: arr
		at: 2.
	self assertCollection: arr equals: #(nil 7 8 1 2 nil)
]
