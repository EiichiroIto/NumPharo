Trait {
	#name : #TNDArrayAccessors,
	#category : #'NumPharo-Core'
}

{ #category : #accessing }
TNDArrayAccessors >> at: anObject [
	anObject isInteger
		ifTrue: [ ^ self atTuple: {anObject} ].
	anObject isArray
		ifTrue: [ anObject isEmpty
				ifTrue: [ ^ self class
						array: (self class newArrayDtype: self dtype)
						shape:
							(self shape copy
								at: 1 put: 0;
								yourself) ].
			anObject isFlatArray
				ifTrue: [ ^ self atTuple: anObject ].
			^ self atTuples: anObject ].
	anObject isNDArray
		ifFalse: [ self error ].
	^ anObject dtype = #Boolean
		ifTrue: [ self atBooleans: anObject ]
		ifFalse: [ self atNumbers: anObject ]
]

{ #category : #modifying }
TNDArrayAccessors >> at: anObject put: anObject2 [
	anObject isInteger
		ifTrue: [ ^ self atTuple: {anObject} put: anObject2 ].
	anObject isArray
		ifTrue: [ anObject isFlatArray
				ifTrue: [ ^ self atTuple: anObject put: anObject2 ].
			^ self atTuples: anObject put: anObject2 ].
	anObject isNDArray
		ifFalse: [ self error ].
	^ anObject dtype = #Boolean
		ifTrue: [ self atBooleans: anObject put: anObject2 ]
		ifFalse: [ self atTuples: anObject put: anObject2 ]
]

{ #category : #private }
TNDArrayAccessors >> atBooleans1D: aBooleanArray [
	| count s |
	count := 0.
	s := WriteStream on: self array class new.
	aBooleanArray array
		with: self array
		do: [ :each :each2 | 
			each
				ifTrue: [ s nextPut: each2.
					count := count + 1 ] ].
	^ self class array: s contents shape: {count}
]

{ #category : #private }
TNDArrayAccessors >> atBooleans1D: aBooleanArray put: aNumber [
	aNumber isNumber
		ifFalse: [ self error ].
	aBooleanArray array
		withIndexDo: [ :each :index | 
			each
				ifTrue: [ self array at: index put: aNumber ] ]
]

{ #category : #private }
TNDArrayAccessors >> atBooleans: aBooleanArray [
	| shape2 s src size count |
	(self shape beginsWith: aBooleanArray shape)
		ifFalse: [ self error ].
	shape2 := self shape
		copyFrom: aBooleanArray shape size + 1
		to: self shape size.
	shape2 isEmpty
		ifTrue: [ ^ self atBooleans1D: aBooleanArray ].
	count := 0.
	src := 1.
	size := self class finiteProductOf: shape2.
	s := WriteStream on: self array class new.
	aBooleanArray array
		do: [ :each | 
			each
				ifTrue: [ s nextPutAll: (self array copyFrom: src to: src + size - 1).
					count := count + 1 ].
			src := src + size ].
	^ self class array: s contents shape: (shape2 copyWithFirst: count)
]

{ #category : #private }
TNDArrayAccessors >> atBooleans: aBooleanArray put: anObject [
	| shape2 data dst size |
	(self shape beginsWith: aBooleanArray shape)
		ifFalse: [ self error ].
	shape2 := self shape
		copyFrom: aBooleanArray shape size + 1
		to: self shape size.
	shape2 isEmpty
		ifTrue: [ ^ self atBooleans1D: aBooleanArray put: anObject ].
	data := self broadcast: anObject axis: aBooleanArray shape size.
	dst := 1.
	size := data array size.
	aBooleanArray array
		do: [ :each | 
			each
				ifTrue: [ self array
						replaceFrom: dst
						to: dst + size - 1
						with: data array
						startingAt: 1 ].
			dst := dst + size ]
]

{ #category : #private }
TNDArrayAccessors >> atNumbers: anArray [
	| dst size arr |
	size := self itemSizeAxis: 1.
	arr := self newArraySize: anArray size * size.
	dst := 1.
	anArray array
		do: [ :each | 
			arr
				replaceFrom: dst
				to: dst + size - 1
				with: self array
				startingAt: (self arrayIndexAt: { each }).
			dst := dst + size ].
	^ self class
		array: arr
		shape: anArray shape , self shape copyWithoutFirst
]

{ #category : #private }
TNDArrayAccessors >> atNumbers: anArray put: anObject [
	| dst size data |
	size := self itemSizeAxis: 1.
	data := self broadcast: anObject axis: 1.
	anArray array
		do: [ :each | 
			dst := (self arrayIndexAt: { each }).
			self array
				replaceFrom: dst
				to: dst + size - 1
				with: data array
				startingAt: 1 ]
]

{ #category : #private }
TNDArrayAccessors >> atTuple: anArray [
	| arr pos num |
	arr := self class normalizedIndex: anArray.
	pos := self arrayIndexAt: arr.
	num := self itemSizeAxis: arr size.
	self ndim = arr size
		ifTrue: [ ^ self array at: pos ].
	^ self class
		array: (self array copyFrom: pos to: pos + num - 1)
		shape: (self itemShapeAxis: arr size)
]

{ #category : #private }
TNDArrayAccessors >> atTuple: anArray put: anObject [
	| arr pos size data |
	arr := self class normalizedIndex: anArray.
	pos := self arrayIndexAt: arr.
	size := self itemSizeAxis: arr size.
	data := self broadcast: anObject axis: arr size.
	self array
		replaceFrom: pos
		to: pos + size - 1
		with: data array
		startingAt: 1
]

{ #category : #private }
TNDArrayAccessors >> atTuples: anArray [
	| num1 num2 newShape arr src dst size arr2 |
	arr2 := self class normalizedIndexes: anArray.
	num1 := arr2 size.
	num2 := arr2 first size.
	size := self itemSizeAxis: num1.
	arr := self newArraySize: num2 * size.
	dst := 1.
	1 to: num2 do: [ :index | 
		newShape := arr2 collect: [ :each | each at: index ].
		src := self arrayIndexAt: newShape.
		arr
			replaceFrom: dst
			to: dst + size - 1
			with: self array
			startingAt: src.
		dst := dst + size ].
	^ self class array: arr shape: {num2} , (self itemShapeAxis: num1)
]

{ #category : #private }
TNDArrayAccessors >> atTuples: anArray put: anObject [
	| num1 num2 newShape dst size data arr |
	arr := self class normalizedIndexes: anArray.
	num1 := arr size.
	num2 := arr first size.
	size := self itemSizeAxis: num1.
	data := self broadcast: anObject axis: num1.
	1 to: num2 do: [ :index | 
		newShape := arr collect: [ :each | each at: index ].
		dst := self arrayIndexAt: newShape.
		self array
			replaceFrom: dst
			to: dst + size - 1
			with: data array
			startingAt: 1 ]
]

{ #category : #private }
TNDArrayAccessors >> broadcast: anObject axis: anInteger [
	| arr obj |
	arr := self class
		ones: (self itemShapeAxis: anInteger)
		dtype: self dtype.
	obj := anObject isNDArray
		ifTrue: [ anObject ]
		ifFalse: [ self class
				fromArray:
					(anObject isArray
						ifTrue: [ anObject ]
						ifFalse: [ {anObject} ])
				dtype: self dtype ].
	^ obj broadcastTo: arr
]

{ #category : #accessing }
TNDArrayAccessors >> indexAt: anInteger [
	| r v a |
	v := anInteger - 1.
	r := WriteStream on: Array new.
	1 to: self ndim do: [ :each | 
		a := self itemSizeAxis: each.
		r nextPut: (v // a) + 1.
		v := v \\ a ].
	^ r contents
]

{ #category : #accessing }
TNDArrayAccessors >> where [
	| result |
	result := (1 to: self ndim)
		collect: [ :each | OrderedCollection new ].
	1 to: self array size do: [ :each | 
		(self arrayAt: each)
			ifTrue: [ | index |
				index := self indexAt: each.
				index
					withIndexDo: [ :each2 :index2 | (result at: index2) add: each2 ] ] ].
	^ result
		collect: [ :each | self class array: each asIntegerArray shape: {each size} ]
]
