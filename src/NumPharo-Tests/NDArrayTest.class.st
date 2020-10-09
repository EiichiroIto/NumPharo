"
A NDArrayTest is a test class for testing the behavior of NDArray
"
Class {
	#name : #NDArrayTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
NDArrayTest >> newArray [
	^ NDArray basicNew
]

{ #category : #private }
NDArrayTest >> newArrayFrom: anArray [
	^ NDArray fromArray: anArray dtype: #Float
]

{ #category : #test }
NDArrayTest >> testArangeFromToBy [
	| a |
	a := NDArray arangeFrom: 1 to: 3 by: 1.
	self assertCollection: a array equals: #(1 2 3) asFloatArray.
	self assertCollection: a shape equals: #(3).
	self assert: a dtype equals: #Float.
	a := NDArray arangeFrom: 1 to: 7 by: 2.
	self assertCollection: a array equals: #(1 3 5 7) asFloatArray.
	self assertCollection: a shape equals: #(4).
	self assert: a dtype equals: #Float
]

{ #category : #test }
NDArrayTest >> testArray [
	| a |
	a := self newArray.
	self assert: a array isNil.
	a initialize.
	self assert: a array isArray.
	self assert: a array isEmpty
]

{ #category : #test }
NDArrayTest >> testArrayAt [
	| a |
	a := self newArrayFrom: #((10 20) (30 40)).
	self assert: (a arrayAt: 1) equals: 10.
	self assert: (a arrayAt: 2) equals: 20.
	self assert: (a arrayAt: 3) equals: 30.
	self assert: (a arrayAt: 4) equals: 40
]

{ #category : #test }
NDArrayTest >> testArrayFromToNumWithEndPoint [
	| a |
	a := NDArray
		arrayFrom: 1.0
		to: 2.0
		num: 3
		withEndPoint: true.
	self assertCollection: a equals: #(1 1.5 2) asFloatArray.
	a := NDArray
		arrayFrom: 1.0
		to: 2.0
		num: 3
		withEndPoint: false.
	self
		assertCollection: a
		equals:
			{1.0.
			(1 / 3 + 1) asFloat.
			(2 / 3 + 1) asFloat} asFloatArray
]

{ #category : #test }
NDArrayTest >> testArrayIndexAt [
	| a |
	a := NDArray ones: #(3 2 3).
	self assert: (a arrayIndexAt: #(1)) equals: 1.
	self assert: (a arrayIndexAt: #(2)) equals: 7.
	self assert: (a arrayIndexAt: #(3)) equals: 13.
	self assert: (a arrayIndexAt: #(1 1 1)) equals: 1.
	self assert: (a arrayIndexAt: #(3 2 3)) equals: 18.
	self assert: (a arrayIndexAt: #(2 2 2)) equals: (6 + 3 + 2)
]

{ #category : #test }
NDArrayTest >> testArrayShapeDtype [
	| arr shape a |
	arr := #(1 2 3).
	shape := #(4 5 6).
	a := NDArray array: arr shape: shape dtype: #Integer.
	self assert: a array equals: arr.
	self assert: a shape equals: shape.
	self assert: a dtype equals: #Integer
]

{ #category : #test }
NDArrayTest >> testAsArray [
	| a r |
	a := self newArrayFrom: #(1 2 3).
	r := a asArray.
	self assertCollection: r equals: #(1.0 2.0 3.0) asFloatArray.
	a := self newArrayFrom: #(#(1 2 3) #(3 4 5)).
	r := a asArray.
	self
		assertCollection: r
		equals:
			{#(1.0 2.0 3.0) asFloatArray.
			#(3.0 4.0 5.0) asFloatArray}.
	a := self newArrayFrom: #(#(#(1)) #(#(3))).
	r := a asArray.
	self
		assertCollection: r
		equals:
			{{#(1) asFloatArray}.
			{#(3) asFloatArray}}
]

{ #category : #test }
NDArrayTest >> testAt [
	| a n |
	a := self newArrayFrom: #((51 55) (14 19) (0 4)).
	n := a at: #(1 2).
	self assert: n equals: 55.
	n := a at: #(2 2).
	self assert: n equals: 19.
	n := a at: #(3 1).
	self assert: n equals: 0.
	n := a at: 1.
	self assertCollection: n array equals: #(51 55) asFloatArray.
	self assertCollection: n shape equals: #(2).
	self assert: n dtype equals: #Float.
	self assert: (n at: 2) equals: 55.
	n := a at: 2.
	self assertCollection: n array equals: #(14 19) asFloatArray.
	self assertCollection: n shape equals: #(2).
	self assert: n dtype equals: #Float.
	n := a at: 3.
	self assertCollection: n array equals: #(0 4) asFloatArray.
	self assertCollection: n shape equals: #(2).
	self assert: n dtype equals: #Float.
	a := self newArrayFrom: #(10 20 30).
	self assert: (a at: 1) equals: 10.
	self assert: (a at: 2) equals: 20.
	self assert: (a at: 3) equals: 30.
	self should: [ a at: 4 ] raise: Error.
	a := self newArrayFrom: #((10 20 30) (40 50 60)).
	n := a at: 1.
	self assertCollection: n array equals: #(10 20 30) asFloatArray.
	self assertCollection: n shape equals: #(3).
	self assert: n dtype equals: #Float.
	n := a at: 2.
	self assertCollection: n array equals: #(40 50 60) asFloatArray.
	self assertCollection: n shape equals: #(3).
	self assert: n dtype equals: #Float.
	a := self newArrayFrom: #(((10 20 30) (30 40 50)) ((40 50 60) (60 70 80))).
	n := a at: #(1 1 1).
	self assert: n equals: 10.
	n := a at: #(2 1 2).
	self assert: n equals: 50.
	n := a at: #(2 2 3).
	self assert: n equals: 80.
	n := a at: 1.
	self assertCollection: n array equals: #(10 20 30 30 40 50) asFloatArray.
	self assertCollection: n shape equals: #(2 3).
	self assert: n dtype equals: #Float.
	n := a at: 2.
	self assertCollection: n array equals: #(40 50 60 60 70 80) asFloatArray.
	self assertCollection: n shape equals: #(2 3).
	self assert: n dtype equals: #Float.
	a := self newArrayFrom: #(((1 2) (2 3) (4 5))).
	self assert: (((a at: 1) at: 3) at: 1) equals: 4.
	self assert: (((a at: 1) at: 3) at: 2) equals: 5
]

{ #category : #test }
NDArrayTest >> testAtAll [
	| a r |
	a := self newArrayFrom: #(6 5 4 3 2 1).
	r := a atAll: #(3 5 1).
	self assertCollection: r array equals: #(4 2 6) asFloatArray.
	a := self newArrayFrom: #((6 5 4) (3 2 1)).
	r := a atAll: #(2 1).
	self assertCollection: r array equals: #(3 2 1 6 5 4) asFloatArray.
	self assertCollection: r shape equals: #(2 3).
	self assert: r dtype equals: #Float.
	"r := a atAll: #((2 2) (1 3)).
	self assertCollection: r array equals: #(2 1) asFloatArray.
	self assertCollection: r shape equals: #(2).
	self assert: r dtype equals: #Float"
]

{ #category : #test }
NDArrayTest >> testAtAllBooleans [
	| a r |
	a := self newArrayFrom: #(1 2 3 4 5).
	r := a atAllBooleans: {true . false . true . false . false}.
	self assertCollection: r array equals: #(1 3) asFloatArray
]

{ #category : #test }
NDArrayTest >> testAtAllInNDArray [
	| a b r |
	a := self newArrayFrom: #(10 20 30 40 50).
	b := NDArray fromArray: {true . false . true . false . false} dtype: #Boolean.
	r := b atAllInNDArray: a.
	self assertCollection: r array equals: #(10 30) asFloatArray.
	b := self newArrayFrom: #(4 1 2).
	r := b atAllInNDArray: a.
	self assertCollection: r array equals: #(40 10 20) asFloatArray
]

{ #category : #test }
NDArrayTest >> testAtAllIndexes [
	| a r |
	a := self newArrayFrom: #(10 20 30 40 50).
	r := a atAllIndexes: #(4 1 2).
	self assertCollection: r array equals: #(40 10 20) asFloatArray
]

{ #category : #test }
NDArrayTest >> testBroadcastTo [
	| a b r |
	a := self newArrayFrom: #((1 2) (3 4)).
	b := self newArrayFrom: #(10 20).
	r := a broadcastTo: b.
	self assertCollection: r array equals: #(1 2 3 4) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	self assertCollection: r dtype equals: #Float.
	r := b broadcastTo: a.
	self assertCollection: r array equals: #(10 20 10 20) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	self assertCollection: r dtype equals: #Float
]

{ #category : #test }
NDArrayTest >> testBroadcastToShape [
	| a b |
	a := self newArrayFrom: #(2).
	b := a broadcastToShape: #(3).
	self assertCollection: b array equals: #(2 2 2) asFloatArray.
	self assertCollection: b shape equals: #(3).
	self assertCollection: b dtype equals: #Float.
	a := self newArrayFrom: #((4) (4) (4)).
	b := a broadcastToShape: #(3 2).
	self assertCollection: b array equals: #(4 4 4 4 4 4) asFloatArray.
	self assertCollection: b shape equals: #(3 2).
	self assertCollection: b dtype equals: #Float.
	a := self newArrayFrom: #((1 2)).
	b := a broadcastToShape: #(3 2).
	self assertCollection: b array equals: #(1 2 1 2 1 2) asFloatArray.
	self assertCollection: b shape equals: #(3 2).
	self assertCollection: b dtype equals: #Float.
	a := self newArrayFrom: #(((1 2 3)) ((4 5 6))).
	b := a broadcastToShape: #(2 3 3).
	self assertCollection: b array equals: #(1 2 3 1 2 3 1 2 3 4 5 6 4 5 6 4 5 6) asFloatArray.
	self assertCollection: b shape equals: #(2 3 3).
	self assertCollection: b dtype equals: #Float
]

{ #category : #test }
NDArrayTest >> testConvertToBoolean [
	| a r |
	a := NDArray arangeFrom: -1 to: 2 by: 1.
	r := a convertToBoolean.
	self assertCollection: r array equals: { true. false. true. true }.
	self assertCollection: r shape equals: #(4).
	self assertCollection: r dtype equals: #Boolean.
	a := NDArray fromArray: { true. false. true }.
	r := a convertToBoolean.
	self assert: r identicalTo: a
]

{ #category : #test }
NDArrayTest >> testConvertToByte [
	| a r |
	a := self newArrayFrom: #(100 200 300 400 -50).
	r := a convertToByte.
	self assertCollection: r array equals: #[100 200 255 255 0].
	self assert: r dtype equals: #Byte.
	a := NDArray fromArray: #(true false true) dtype: #Boolean.
	r := a convertToByte.
	self assertCollection: r array equals: #[1 0 1].
	self assert: r dtype equals: #Byte
]

{ #category : #test }
NDArrayTest >> testConvertToFloat [
	| a r |
	a := NDArray arangeFrom: -1 to: 2 by: 1.
	r := a convertToFloat.
	self assert: r identicalTo: a.
	a := NDArray fromArray: {true. false}.
	r := a convertToFloat.
	self assertCollection: r array equals: #(1 0) asFloatArray.
	self assertCollection: r shape equals: #(2).
	self assert: r dtype equals: #Float.
	a := NDArray fromArray: #(1 2) asIntegerArray.
	r := a convertToFloat.
	self assertCollection: r array equals: #(1 2) asFloatArray.
	self assertCollection: r shape equals: #(2).
	self assert: r dtype equals: #Float
]

{ #category : #test }
NDArrayTest >> testConvertToInteger [
	| a r |
	a := NDArray arangeFrom: -1 to: 2 by: 0.5.
	r := a convertToInteger.
	self assertCollection: r array equals: #(-1 0 0 0 1 1 2) asIntegerArray.
	self assertCollection: r shape equals: #(7).
	self assert: r dtype equals: #Integer.
	a := NDArray fromArray: {true. false}.
	r := a convertToInteger.
	self assertCollection: r array equals: #(1 0) asIntegerArray.
	self assertCollection: r shape equals: #(2).
	self assert: r dtype equals: #Integer.
	a := NDArray fromArray: #(1 2) asIntegerArray.
	r := a convertToInteger.
	self assert: r identicalTo: a
]

{ #category : #test }
NDArrayTest >> testConvertToWord [
	| a r |
	a := self newArrayFrom: #(10000 30000 60000 80000 -50).
	r := a convertToWord.
	self
		assertCollection: r array
		equals: #(10000 30000 60000 65535 0) asWordArray.
	self assert: r dtype equals: #Word.
	a := NDArray fromArray: #(true false true) dtype: #Boolean.
	r := a convertToWord.
	self assertCollection: r array equals: #(1 0 1) asWordArray.
	self assert: r dtype equals: #Word
]

{ #category : #test }
NDArrayTest >> testCopyWithNdim [
	| a b |
	a := self newArrayFrom: #((1 2) (3 4) (5 6)).
	b := a copyWithNdim: 4.
	self assert: b ndim equals: 4.
	self assertCollection: b array equals: a array.
	self assertCollection: b shape equals: #(1 1 3 2).
	self assertCollection: b dtype equals: a dtype
]

{ #category : #test }
NDArrayTest >> testCrossEntropyErrorYAndT [
	| t y r |
	t := NDArray fromArray: #(0 0 1 0 0 0 0 0 0 0).
	y := NDArray fromArray: #(0.1 0.05 0.6 0.0 0.05 0.1 0.0 0.1 0.0 0.0).
	r := NDArray crossEntropyErrorY: y andT: t.
	self assert: r closeTo: 0.51082545.
	y := NDArray fromArray: #(0.1 0.05 0.1 0.0 0.05 0.1 0.0 0.6 0.0 0.0).
	r := NDArray crossEntropyErrorY: y andT: t.
	self assert: r closeTo: 2.30258409
]

{ #category : #test }
NDArrayTest >> testDtype [
	| a |
	a := self newArray.
	self assert: a dtype isNil.
	a initialize.
	self assert: a dtype isNil
]

{ #category : #test }
NDArrayTest >> testFiniteProductOf [
	self assert: (NDArray finiteProductOf: #(3)) equals: 3.
	self assert: (NDArray finiteProductOf: #(2 3)) equals: 6.
	self assert: (NDArray finiteProductOf: #(2 3 4)) equals: 24
]

{ #category : #test }
NDArrayTest >> testFlatten [
	| a r |
	a := self newArrayFrom: #((1 2) (3 4)).
	r := a flatten.
	self assertCollection: r array equals: #(1 2 3 4) asFloatArray.
	self assertCollection: r shape equals: #(4).
	self assertCollection: r dtype equals: #Float
]

{ #category : #test }
NDArrayTest >> testFromArray [
	| a |
	a := NDArray fromArray: #(1 2 3) asFloatArray.
	self assertCollection: a array equals: #(1 2 3) asFloatArray.
	self assertCollection: a shape equals: #(3).
	self assertCollection: a dtype equals: #Float
]

{ #category : #test }
NDArrayTest >> testFromArrayDtype [
	| a |
	a := NDArray fromArray: #(1 2 3) dtype: #Float.
	self assertCollection: a array equals: #(1 2 3) asFloatArray.
	self assertCollection: a shape equals: #(3).
	self assert: a dtype equals: #Float.
	a := NDArray fromArray: #((1 2 3) (3 4 5)) dtype: #Integer.
	self assertCollection: a array equals: #(1 2 3 3 4 5) asIntegerArray.
	self assertCollection: a shape equals: #(2 3).
	self assert: a dtype equals: #Integer.
	a := NDArray fromArray: #(((1 2 3) (3 4 5)) ((3 4 5) (5 6 7))) dtype: #Byte.
	self assertCollection: a array equals: #(1 2 3 3 4 5 3 4 5 5 6 7) asByteArray.
	self assertCollection: a shape equals: #(2 2 3).
	self assert: a dtype equals: #Byte
]

{ #category : #test }
NDArrayTest >> testInitialize [
	| a |
	a := self newArray initialize.
	self assert: a array isArray.
	self assert: a shape isArray.
	self assert: a dtype isNil
]

{ #category : #test }
NDArrayTest >> testIsNDArray [
	| n |
	n := self newArray.
	self assert: n isNDArray.
	self deny: 1 isNDArray
]

{ #category : #test }
NDArrayTest >> testItemSizeAt [
	| a |
	a := NDArray ones: #(2 4 1 3 2).
	self assert: (a itemSizeAt: 3) equals: 6.
	self assert: (a itemSizeAt: 1) equals: 24.
	self assert: (a itemSizeAt: 5) equals: 1
]

{ #category : #test }
NDArrayTest >> testItemSizeList [
	| a |
	a := self newArrayFrom: #((1 2 3) (4 5 6)).
	self assertCollection: a itemSizeList equals: #(3 1).
	a := self newArrayFrom: #(((1 2 3) (4 5 6)) ((7 8 9) (10 11 12)) ((13 14 15) (16 17 18))).
	self assertCollection: a itemSizeList equals: #(6 3 1)
]

{ #category : #test }
NDArrayTest >> testLen [
	| a |
	a := self newArrayFrom: #(1 2 3 4).
	self assert: a len equals: 4.
	a := self newArrayFrom: #((1 2) (3 4)).
	self assert: a len equals: 2
]

{ #category : #test }
NDArrayTest >> testLinspaceFromToNumWithEndPoint [
	| a |
	a := NDArray linspaceFrom: 1 to: 2 num: 3 withEndPoint: true.
	self assertCollection: a array equals: #(1 1.5 2) asFloatArray.
	self assertCollection: a shape equals: #(3).
	self assert: a dtype equals: #Float.
	a := NDArray linspaceFrom: 1 to: 4 num: 3 withEndPoint: false.
	self assertCollection: a array equals: #(1 2 3) asFloatArray.
	self assertCollection: a shape equals: #(3).
	self assert: a dtype equals: #Float
]

{ #category : #test }
NDArrayTest >> testMeanSquaredErrorYAndT [
	| t y r |
	t := NDArray fromArray: #(0 0 1 0 0 0 0 0 0 0).
	y := NDArray fromArray: #(0.1 0.05 0.6 0.0 0.05 0.1 0.0 0.1 0.0 0.0).
	r := NDArray meanSquaredErrorY: y andT: t.
	self assert: r closeTo: 0.0975.
	y := NDArray fromArray: #(0.1 0.05 0.1 0.0 0.05 0.1 0.0 0.6 0.0 0.0).
	r := NDArray meanSquaredErrorY: y andT: t.
	self assert: r closeTo: 0.5975
]

{ #category : #test }
NDArrayTest >> testNdim [
	| a |
	a := self newArrayFrom: #(0 1).
	self assert: a ndim equals: 1.
	a := self newArrayFrom: #((1 2) (3 4)).
	self assert: a ndim equals: 2
]

{ #category : #test }
NDArrayTest >> testNormalizedIndex [
	| r |
	r := NDArray normalizedIndex: 1.
	self assertCollection: r equals: #(1).
	r := NDArray normalizedIndex: 2.3.
	self assertCollection: r equals: #(2).
	r := NDArray normalizedIndex: #(1 2).
	self assertCollection: r equals: #(1 2)
]

{ #category : #test }
NDArrayTest >> testOnes [
	| a |
	a := NDArray ones: 5.
	self assertCollection: a array equals: #(1 1 1 1 1) asIntegerArray.
	self assertCollection: a shape equals: #(5).
	self assert: a dtype equals: #Integer.
	a := NDArray ones: #(2 3).
	self assertCollection: a array equals: #(1 1 1 1 1 1) asIntegerArray.
	self assertCollection: a shape equals: #(2 3).
	self assert: a dtype equals: #Integer
]

{ #category : #test }
NDArrayTest >> testPresumeShape [
	| x r |
	x := self newArrayFrom: #(1 2 3).
	r := x presumeShape: #(-1).
	self assertCollection: x shape equals: #(3).
	self assertCollection: r equals: #(3).
	x := self newArrayFrom: #((1 2 3 4) (5 6 7 8) (9 10 11 12)).
	r := x presumeShape: #(-1).
	self assertCollection: x shape equals: #(3 4).
	self assertCollection: r equals: #(12).
	r := x presumeShape: #(-1 2).
	self assertCollection: x shape equals: #(3 4).
	self assertCollection: r equals: #(6 2)
]

{ #category : #test }
NDArrayTest >> testPrivArray [
	| a |
	a := self newArray.
	self assert: a array isNil.
	a privArray: #(1 2 3).
	self assertCollection: a array equals: #(1 2 3)
]

{ #category : #test }
NDArrayTest >> testPrivDtype [
	| a |
	a := self newArray.
	self assert: a dtype isNil.
	a privDtype: #Float.
	self assertCollection: a dtype equals: #Float
]

{ #category : #test }
NDArrayTest >> testPrivShape [
	| a |
	a := self newArray.
	self assert: a shape isNil.
	a privShape: #(1 2 3).
	self assertCollection: a shape equals: #(1 2 3)
]

{ #category : #test }
NDArrayTest >> testRandomChoiceFrom [
	| a |
	a := NDArray randomChoice: 10 from: (100 to: 200).
	self assert: a array size equals: 10.
	self assert: a array asSet size equals: 10.
	self assert: a dtype equals: #Integer.
	self assert: (a array allSatisfy: [ :each | each between: 100 and: 200 ]).
	a := NDArray randomChoice: 5 from: 50.
	self assert: a array size equals: 5.
	self assert: a array asSet size equals: 5.
	self assert: a dtype equals: #Integer.
	self assert: (a array allSatisfy: [ :each | each between: 1 and: 50 ])
]

{ #category : #test }
NDArrayTest >> testRawAt [
	| a r |
	a := self newArrayFrom: #(10 20 30).
	r := a rawAt: 1.
	self assertCollection: r equals: #(10) asFloatArray.
	r := a rawAt: 2.
	self assertCollection: r equals: #(20) asFloatArray.
	r := a rawAt: 3.
	self assertCollection: r equals: #(30) asFloatArray.
	a := self newArrayFrom: #(#(10 20 30) #(40 50 60)).
	r := a rawAt: 1.
	self assertCollection: r equals: #(10 20 30) asFloatArray.
	r := a rawAt: 2.
	self assertCollection: r equals: #(40 50 60) asFloatArray
]

{ #category : #test }
NDArrayTest >> testShape [
	| a |
	a := self newArray.
	self assert: a shape isNil.
	a initialize.
	self assert: a shape isArray.
	self assert: a shape isEmpty
]

{ #category : #test }
NDArrayTest >> testShapeOf [
	| arr |
	arr := NDArray shapeOf: #(1 2 3) asFloatArray.
	self assertCollection: arr equals: #(3).
	arr := NDArray shapeOf: #((1 2) (2 3) (3 4)).
	self assertCollection: arr equals: #(3 2).
	arr := NDArray shapeOf: #(((1 2 3)) ((2 3 4)) ((3 4 5))).
	self assertCollection: arr equals: #(3 1 3)
]

{ #category : #test }
NDArrayTest >> testShapeWithNdim [
	| a s |
	a := NDArray ones: #(2 3).
	self assertCollection: a shape equals: #(2 3).
	s := a shapeWithNdim: 5.
	self assertCollection: s equals: #(1 1 1 2 3)
]

{ #category : #test }
NDArrayTest >> testSize [
	| a |
	a := self newArrayFrom: #(1 2 3 4).
	self assert: a size equals: 4.
	a := self newArrayFrom: #((1 2) (3 4)).
	self assert: a size equals: 4
]

{ #category : #test }
NDArrayTest >> testSoftMax [
	| a y |
	a := NDArray fromArray: #(0.3 2.9 4.0).
	y := NDArray softMax: a.
	self assert: y sum closeTo: 1
]

{ #category : #test }
NDArrayTest >> testWithDtype [
	| a r |
	a := self newArrayFrom: #(-2 -1 0 1 2).
	r := a withDtype: #Boolean.
	self assertCollection: r array equals: #(true true false true true).
	self assert: r dtype equals: #Boolean.
	a := self newArrayFrom: #(-2 -1 0 1 2000).
	r := a withDtype: #Byte.
	self assertCollection: r array equals: #[0 0 0 1 255].
	self assert: r dtype equals: #Byte.
	a := self newArrayFrom: #(-2 -1 0 1 200000).
	r := a withDtype: #Word.
	self assertCollection: r array equals: #(0 0 0 1 65535) asWordArray.
	self assert: r dtype equals: #Word.
	a := self newArrayFrom: #(-2 -1 0 1 200000).
	r := a withDtype: #Float.
	self assert: a identicalTo: r
]

{ #category : #test }
NDArrayTest >> testWithShape [
	| a r arr |
	a := NDArray fromArray: #((1 2 3) (4 5 6)).
	arr := a array.
	self assertCollection: a shape equals: #(2 3).
	r := a withShape: #(3 2).
	self assertCollection: r array equals: arr.
	self assertCollection: r shape equals: #(3 2).
	r := a withShape: #(1 6).
	self assertCollection: r array equals: arr.
	self assertCollection: r shape equals: #(1 6).
	r := a withShape: #(6 1).
	self assertCollection: r array equals: arr.
	self assertCollection: r shape equals: #(6 1).
	a := self newArrayFrom: #(1 2 3).
	r := a withShape: #(-1).
	self assertCollection: r array equals: a array.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: a dtype.
	a := self newArrayFrom: #((1 2 3 4) (5 6 7 8) (9 10 11 12)).
	self assertCollection: a shape equals: #(3 4).
	r := a withShape: #(-1).
	self assertCollection: r array equals: a array.
	self assertCollection: r shape equals: #(12).
	self assert: r dtype equals: a dtype.
	r := a withShape: #(-1 2).
	self assertCollection: r array equals: a array.
	self assertCollection: r shape equals: #(6 2).
	self assert: r dtype equals: a dtype
]

{ #category : #test }
NDArrayTest >> testZeros [
	| a |
	a := NDArray zeros: 5.
	self assertCollection: a array equals: #(0 0 0 0 0) asIntegerArray.
	self assertCollection: a shape equals: #(5).
	self assert: a dtype equals: #Integer.
	a := NDArray zeros: #(2 3).
	self assertCollection: a array equals: #(0 0 0 0 0 0) asIntegerArray.
	self assertCollection: a shape equals: #(2 3).
	self assert: a dtype equals: #Integer
]
