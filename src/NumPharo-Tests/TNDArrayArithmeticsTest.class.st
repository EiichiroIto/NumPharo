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
	self assertCollection: r array equals: #(3 3).
	self assertCollection: r shape equals: #(2).
	r := a argMaxAxis: 2.
	self assertCollection: r array equals: #(2 2 2).
	self assertCollection: r shape equals: #(3).
	a := self newArrayFrom: #(((1 2) (3 4) (5 6)) ((7 6) (5 4) (3 2))).
	self assertCollection: a shape equals: #(2 3 2).
	r := a argMaxAxis: 1.
	self assertCollection: r array equals: #(2 2 2 1 1 1).
	self assertCollection: r shape equals: #(3 2).
	r := a argMaxAxis: 2.
	self assertCollection: r array equals: #(3 3 1 1).
	self assertCollection: r shape equals: #(2 2).
	r := a argMaxAxis: 3.
	self assertCollection: r array equals: #(2 2 2 1 1 1).
	self assertCollection: r shape equals: #(2 3)
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
TNDArrayArithmeticsTest >> testIndexAt [
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
TNDArrayArithmeticsTest >> testItemSizeAxis [
	| a |
	a := NDArray ones: #(2 4 1 3 2).
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
	a := self newArrayFrom: #((1 2) (3 4) (5 6)).
	self assertCollection: a shape equals: #(3 2).
	r := a maxAxis: 1.
	self assertCollection: r array equals: #(5 6).
	self assertCollection: r shape equals: #(2).
	r := a maxAxis: 2.
	self assertCollection: r array equals: #(2 4 6).
	self assertCollection: r shape equals: #(3).
	a := self newArrayFrom: #(((1 2) (3 4) (5 6)) ((7 6) (5 4) (3 2))).
	self assertCollection: a shape equals: #(2 3 2).
	r := a maxAxis: 1.
	self assertCollection: r array equals: #(7 6 5 4 5 6).
	self assertCollection: r shape equals: #(3 2).
	r := a maxAxis: 2.
	self assertCollection: r array equals: #(5 6 7 6).
	self assertCollection: r shape equals: #(2 2).
	r := a maxAxis: 3.
	self assertCollection: r array equals: #(2 4 6 7 5 3).
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
	self assertCollection: r array equals: #(1 2).
	self assertCollection: r shape equals: #(2).
	r := a minAxis: 2.
	self assertCollection: r array equals: #(1 3 5).
	self assertCollection: r shape equals: #(3).
	a := self newArrayFrom: #(((1 2) (3 4) (5 6)) ((7 6) (5 4) (3 2))).
	self assertCollection: a shape equals: #(2 3 2).
	r := a minAxis: 1.
	self assertCollection: r array equals: #(1 2 3 4 3 2).
	self assertCollection: r shape equals: #(3 2).
	r := a minAxis: 2.
	self assertCollection: r array equals: #(1 2 3 2).
	self assertCollection: r shape equals: #(2 2).
	r := a minAxis: 3.
	self assertCollection: r array equals: #(1 3 5 6 4 2).
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
	a := NDArray arangeFrom: 0 to: 23 by: 1.
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
	a := NDArray arangeFrom: 0 to: 23 by: 1.
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
	a := NDArray arangeFrom: 0 to: 23 by: 1.
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
TNDArrayArithmeticsTest >> testWhere [
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

{ #category : #test }
TNDArrayArithmeticsTest >> testWrapCopyFromSize [
	| a |
	a := self newArrayFrom: #(1 2 3 4 5 6 7 8).
	self
		assertCollection: (a wrapCopyFrom: 2 size: 4)
		equals: #(2 3 4 5) asFloatArray.
	self
		assertCollection: (a wrapCopyFrom: 6 size: 4)
		equals: #(6 7 8 1) asFloatArray.
	self
		assertCollection: (a wrapCopyFrom: 8 size: 4)
		equals: #(8 1 2 3) asFloatArray.
	self
		assertCollection: (a wrapCopyFrom: 9 size: 4)
		equals: #(1 2 3 4) asFloatArray.
	self
		assertCollection: (a wrapCopyFrom: -1 size: 4)
		equals: #(7 8 1 2) asFloatArray
]
