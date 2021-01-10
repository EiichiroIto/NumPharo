Class {
	#name : #NDPadder,
	#superclass : #Object,
	#instVars : [
		'ndArray',
		'before',
		'after'
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
NDPadder >> before [
	^ before
]

{ #category : #accessing }
NDPadder >> before: anObject [
	before := anObject
]

{ #category : #api }
NDPadder >> constant: aNDArray [
	self setupForPadding: aNDArray.
	self constantCopy: aNDArray.
	^ self ndArray
]

{ #category : #private }
NDPadder >> constantCopy: aNDArray [
	| arr src dst size iter index offset |
	arr := self ndArray array.
	size := aNDArray shape last.
	iter := NDIndexIterator new shape: aNDArray shape.
	src := 1.
	offset := Array new: self ndArray ndim withAll: self before.
	[ index := iter nextForPad.
	index notNil ]
		whileTrue: [ dst := self ndArray arrayIndexAt: index + offset.
			arr
				replaceFrom: dst
				to: dst + size - 1
				with: aNDArray array
				startingAt: src.
			src := src + size ]
]

{ #category : #api }
NDPadder >> edge: aNDArray [
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
					self edgeCopyFrom: from to: to size: each ] ]
]

{ #category : #private }
NDPadder >> edgeCopyFrom: anInteger to: anInteger2 size: anInteger3 [
	| arr dst |
	arr := self ndArray array.
	dst := anInteger.
	self before
		timesRepeat: [ dst := dst - anInteger3.
			arr
				replaceFrom: dst
				to: dst + anInteger3 - 1
				with: arr
				startingAt: anInteger ].
	dst := anInteger2 + 1.
	self after
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
	r := anArray + self before.
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
	r := anArray + self before.
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
	self setupForOmitting: aNDArray.
	self omitCopy: aNDArray.
	^ self ndArray
]

{ #category : #private }
NDPadder >> omitCopy: aNDArray [
	| arr src dst size iter index offset |
	arr := self ndArray array.
	size := self ndArray shape last.
	iter := NDIndexIterator new shape: self ndArray shape.
	dst := 1.
	offset := Array new: aNDArray ndim withAll: self before.
	[ index := iter nextForPad.
	index notNil ]
		whileTrue: [ src := aNDArray arrayIndexAt: index + offset.
			arr
				replaceFrom: dst
				to: dst + size - 1
				with: aNDArray array
				startingAt: src.
			dst := dst + size ]
]

{ #category : #private }
NDPadder >> setupForOmitting: aNDArray [
	| newShape |
	newShape := aNDArray shape
		collect: [ :each | each - self before - self after ].
	self ndArray: (NDArray zeros: newShape dtype: aNDArray dtype)
]

{ #category : #private }
NDPadder >> setupForPadding: aNDArray [
	| newShape |
	newShape := aNDArray shape
		collect: [ :each | each + self before + self after ].
	self ndArray: (NDArray zeros: newShape dtype: aNDArray dtype)
]

{ #category : #private }
NDPadder >> startPos [
	| pos |
	pos := 1.
	1 to: self ndArray ndim do: [ :each | pos := (self ndArray itemSizeAxis: each) * self before + pos ].
	^ pos
]
