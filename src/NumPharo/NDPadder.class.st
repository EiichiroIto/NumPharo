Class {
	#name : #NDPadder,
	#superclass : #Object,
	#instVars : [
		'ndArray',
		'before',
		'after',
		'mode'
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
	self setupNDArray: aNDArray.
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
	offset := Array new: self ndArray ndim withAll: before.
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
	self setupNDArray: aNDArray.
	self constantCopy: aNDArray.
	self edgeCopy: aNDArray.
	^ self ndArray
]

{ #category : #private }
NDPadder >> edgeCopy: aNDArray [
	ndArray itemSizeList reversed
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
					from := ndArray arrayIndexAt: from.
					to := self edgeEndOf: f for: aNDArray.
					to := self edgeEnd: to.
					to := ndArray arrayIndexAt: to.
					self edgeCopyFrom: from to: to size: each ] ]
]

{ #category : #private }
NDPadder >> edgeCopyFrom: anInteger to: anInteger2 size: anInteger3 [
	| dst |
	dst := anInteger.
	before
		timesRepeat: [ dst := dst - anInteger3.
			ndArray array
				replaceFrom: dst
				to: dst + anInteger3 - 1
				with: ndArray array
				startingAt: anInteger ].
	dst := anInteger2 + 1.
	after
		timesRepeat: [ ndArray array
				replaceFrom: dst
				to: dst + anInteger3 - 1
				with: ndArray array
				startingAt: anInteger2 - anInteger3 + 1.
			dst := dst + anInteger3 ]
]

{ #category : #private }
NDPadder >> edgeEnd: anArray [
	anArray size = ndArray ndim
		ifTrue: [ ^ anArray + before ].
	^ anArray + before
		, (ndArray shape copyFrom: anArray size + 1 to: ndArray shape size)
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
	anArray size = ndArray ndim
		ifTrue: [ ^ anArray + before ].
	^ (anArray + before) forceTo: ndArray ndim paddingWith: 1
]

{ #category : #accessing }
NDPadder >> mode [
	^ mode
]

{ #category : #accessing }
NDPadder >> mode: anObject [
	mode := anObject
]

{ #category : #accessing }
NDPadder >> ndArray [
	^ ndArray
]

{ #category : #accessing }
NDPadder >> ndArray: anObject [
	ndArray := anObject
]

{ #category : #private }
NDPadder >> setupNDArray: aNDArray [
	| newShape |
	newShape := aNDArray shape
		collect: [ :each | each + self before + self after ].
	ndArray := NDArray zeros: newShape dtype: aNDArray dtype
]

{ #category : #private }
NDPadder >> startPos [
	| pos |
	pos := 1.
	1 to: ndArray ndim do: [ :each | pos := (ndArray itemSizeAxis: each) * self before + pos ].
	^ pos
]
