Class {
	#name : #NDPadder,
	#superclass : #Object,
	#instVars : [
		'ndArray',
		'before',
		'after',
		'afters',
		'befores'
	],
	#category : #'NumPharo-Core'
}

{ #category : #accessing }
NDPadder >> after [
	^ after
]

{ #category : #accessing }
NDPadder >> after: anObject [
	after := anObject
]

{ #category : #accessing }
NDPadder >> afters [
	^ afters
]

{ #category : #accessing }
NDPadder >> afters: anArray [
	afters := anArray
]

{ #category : #accessing }
NDPadder >> before [
	^ before
]

{ #category : #accessing }
NDPadder >> before: anObject [
	before := anObject
]

{ #category : #accessing }
NDPadder >> befores [
	^ befores
]

{ #category : #accessing }
NDPadder >> befores: anArray [
	befores := anArray
]

{ #category : #api }
NDPadder >> constant: aNDArray [
	self setupFor: aNDArray.
	self setupForPadding: aNDArray.
	self constantCopy: aNDArray.
	^ self ndArray
]

{ #category : #private }
NDPadder >> constantCopy: aNDArray [
	| arr src dst size iter index |
	arr := self ndArray array.
	size := aNDArray shape last.
	iter := NDIndexIterator new shape: aNDArray shape.
	src := 1.
	[ index := iter nextForPad.
	index notNil ]
		whileTrue: [ dst := self ndArray arrayIndexAt: index + befores.
			arr
				replaceFrom: dst
				to: dst + size - 1
				with: aNDArray array
				startingAt: src.
			src := src + size ]
]

{ #category : #api }
NDPadder >> edge: aNDArray [
	self setupFor: aNDArray.
	self setupForPadding: aNDArray.
	self constantCopy: aNDArray.
	self edgeCopy: aNDArray.
	^ self ndArray
]

{ #category : #private }
NDPadder >> edgeCopy: aNDArray [
	self ndArray itemSizeList reversed
		withIndexDo: [ :each :index | 
			| newShape iter |
			newShape := aNDArray shape
				copyFrom: 1
				to: aNDArray ndim - index + 1.
			iter := NDIndexIterator new shape: newShape.
			iter indexesForPad
				do: [ :f | 
					| from to |
					from := self edgeStart: f.
					from := self ndArray arrayIndexAt: from.
					to := self edgeEndOf: f for: aNDArray.
					to := self edgeEnd: to.
					to := self ndArray arrayIndexAt: to.
					self edgeCopyFrom: from to: to size: each at: index ] ]
]

{ #category : #private }
NDPadder >> edgeCopyFrom: anInteger to: anInteger2 size: anInteger3 at: anInteger4 [
	| arr dst |
	arr := self ndArray array.
	dst := anInteger.
	(befores at: anInteger4)
		timesRepeat: [ dst := dst - anInteger3.
			arr
				replaceFrom: dst
				to: dst + anInteger3 - 1
				with: arr
				startingAt: anInteger ].
	dst := anInteger2 + 1.
	(afters at: anInteger4)
		timesRepeat: [ arr
				replaceFrom: dst
				to: dst + anInteger3 - 1
				with: arr
				startingAt: anInteger2 - anInteger3 + 1.
			dst := dst + anInteger3 ]
]

{ #category : #private }
NDPadder >> edgeEnd: anArray [
	| r |
	r := anArray + (befores copyFrom: 1 to: anArray size).
	anArray size = self ndArray ndim
		ifTrue: [ ^ r ].
	^ r
		, (self ndArray shape copyFrom: anArray size + 1 to: self ndArray ndim)
]

{ #category : #private }
NDPadder >> edgeEndOf: anArray for: aNDArray [
	| arr |
	arr := anArray copy.
	arr at: anArray size put: (aNDArray shape at: anArray size).
	^ arr
]

{ #category : #private }
NDPadder >> edgeStart: anArray [
	| r |
	r := anArray + (befores copyFrom: 1 to: anArray size).
	anArray size = self ndArray ndim
		ifTrue: [ ^ r ].
	^ r forceTo: self ndArray ndim paddingWith: 1
]

{ #category : #accessing }
NDPadder >> ndArray [
	^ ndArray
]

{ #category : #accessing }
NDPadder >> ndArray: anObject [
	ndArray := anObject
]

{ #category : #api }
NDPadder >> omit: aNDArray [
	self setupFor: aNDArray.
	self setupForOmitting: aNDArray.
	self omitCopy: aNDArray.
	^ self ndArray
]

{ #category : #private }
NDPadder >> omitCopy: aNDArray [
	| arr src dst size iter index |
	arr := self ndArray array.
	size := self ndArray shape last.
	iter := NDIndexIterator new shape: self ndArray shape.
	dst := 1.
	[ index := iter nextForPad.
	index notNil ]
		whileTrue: [ src := aNDArray arrayIndexAt: index + befores.
			arr
				replaceFrom: dst
				to: dst + size - 1
				with: aNDArray array
				startingAt: src.
			dst := dst + size ]
]

{ #category : #private }
NDPadder >> setupFor: aNDArray [
	afters ifNil: [ afters := IntegerArray new: aNDArray ndim withAll: after ].
	befores
		ifNil: [ befores := IntegerArray new: aNDArray ndim withAll: before ]
]

{ #category : #private }
NDPadder >> setupForOmitting: aNDArray [
	| newShape |
	newShape := aNDArray shape
		withIndexCollect: [ :each :index | each - (befores at: index) - (afters at: index) ].
	self ndArray: (NDArray zeros: newShape dtype: aNDArray dtype)
]

{ #category : #private }
NDPadder >> setupForPadding: aNDArray [
	| newShape |
	newShape := aNDArray shape
		withIndexCollect: [ :each :index | each + (befores at: index) + (afters at: index) ].
	self ndArray: (NDArray zeros: newShape dtype: aNDArray dtype)
]

{ #category : #private }
NDPadder >> startPos [
	| pos |
	pos := 1.
	1 to: self ndArray ndim do: [ :each | pos := (self ndArray itemSizeAxis: each) * (befores at: each) + pos ].
	^ pos
]
