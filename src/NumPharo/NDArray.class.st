Class {
	#name : #NDArray,
	#superclass : #Object,
	#traits : 'TNDArrayArithmetics + TNDArrayAccessors',
	#classTraits : 'TNDArrayArithmetics classTrait + TNDArrayAccessors classTrait',
	#instVars : [
		'shape',
		'array'
	],
	#classVars : [
		'Coerces'
	],
	#category : #'NumPharo-Core'
}

{ #category : #'instance creation' }
NDArray class >> arangeFrom: from to: to by: step [
	^ self fromArray: (from to: to by: step) asArray
]

{ #category : #private }
NDArray class >> array: anArray1 shape: anArray2 [
	^ self basicNew
		privArray: anArray1;
		privShape: anArray2
]

{ #category : #private }
NDArray class >> arrayFrom: from to: to num: anInteger withEndPoint: aBoolean [
	| diff s |
	diff := ((to - from)
		/
			(aBoolean
				ifTrue: [ anInteger - 1 ]
				ifFalse: [ anInteger ])) asFloat.
	s := WriteStream on: FloatArray new.
	(0 to: anInteger - 1) do: [ :each | s nextPut: each * diff + from ].
	^ s contents
]

{ #category : #private }
NDArray class >> coerceDtype: aSymbol1 with: aSymbol2 [
	aSymbol1 = aSymbol2
		ifTrue: [ ^ aSymbol1 ].
	^ Coerces at: aSymbol1 at: aSymbol2
]

{ #category : #private }
NDArray class >> comprehension: anArray [
	| sizes num result itemSize itemCount pos arr |
	sizes := anArray collect: #size.
	num := self finiteProductOf: sizes.
	result := Array new: anArray size.
	anArray
		withIndexDo: [ :each1 :index1 | 
			itemSize := self finiteProductOf: (sizes copyWithoutIndex: index1).
			itemCount := self
				finiteProductOf: (sizes copyFrom: index1 + 1 to: sizes size).
			arr := Array new: num.
			pos := 1.
			itemSize / itemCount
				timesRepeat: [ each1
						withIndexDo: [ :each2 :index2 | 
							"pos := (index2 - 1) * itemSize + 1."
							itemCount
								timesRepeat: [ arr at: pos put: each2.
									pos := pos + 1 ] ] ].
			result at: index1 put: arr ].
	^ result
]

{ #category : #private }
NDArray class >> finiteProductOf: anArray [
	^ anArray inject: 1 into: [ :p :e | p * e ]
]

{ #category : #'instance creation' }
NDArray class >> fromArray: anArray [
	(anArray isKindOf: FloatArray)
		ifTrue: [ ^ self fromArray: anArray dtype: #Float ].
	(anArray isKindOf: IntegerArray)
		ifTrue: [ ^ self fromArray: anArray dtype: #Integer ].
	(anArray isKindOf: ByteArray)
		ifTrue: [ ^ self fromArray: anArray dtype: #Byte ].
	(anArray isKindOf: WordArray)
		ifTrue: [ ^ self fromArray: anArray dtype: #Word ].
	(anArray allSatisfy: [:each | each isKindOf: Boolean])
		ifTrue: [ ^ self fromArray: anArray dtype: #Boolean ].
	^ self fromArray: anArray dtype: anArray dtype
]

{ #category : #'instance creation' }
NDArray class >> fromArray: anArray dtype: aSymbol [
	| shape arr size |
	shape := self shapeOf: anArray.
	arr := nil.
	aSymbol = #Float
		ifTrue: [ arr := anArray flattened asFloatArray ].
	aSymbol = #Integer
		ifTrue: [ arr := anArray flattened asIntegerArray ].
	aSymbol = #Byte
		ifTrue: [ arr := anArray flattened asByteArray ].
	aSymbol = #Word
		ifTrue: [ arr := anArray flattened asWordArray ].
	aSymbol = #Boolean
		ifTrue: [ arr := anArray flattened copy ].
	arr ifNil: [ self error: 'invalid dtype' ].
	size := self finiteProductOf: shape.
	size = arr size
		ifFalse: [ self error: 'invalid shape' ].
	^ self array: arr shape: shape
]

{ #category : #'instance creation' }
NDArray class >> full: anObject withAll: aNumber dtype: aSymbol [
	| arr shape size |
	shape := self normalizedIndex: anObject.
	size := self finiteProductOf: shape.
	arr := self newArrayDtype: aSymbol size: size withAll: aNumber.
	^ self array: arr shape: shape
]

{ #category : #'class initialization' }
NDArray class >> initialize [
	"self initialize"
	self setupCoerces
]

{ #category : #'instance creation' }
NDArray class >> linspaceFrom: from to: to num: anInteger withEndPoint: aBoolean [
	| arr |
	arr := self arrayFrom: from to: to num: anInteger withEndPoint: aBoolean.
	^ self array: arr shape: (Array with: arr size)
]

{ #category : #private }
NDArray class >> meshArraysOf: anArray [
	^ anArray
		collect: [ :each | 
			each isNDArray
				ifTrue: [ each array ]
				ifFalse: [ each ] ]
]

{ #category : #private }
NDArray class >> meshDtypeOf: anArray [
	^ anArray
		inject: nil
		into: [ :prev :each | 
			prev
				ifNil: [ each dtype ]
				ifNotNil: [ self coerceDtype: prev with: each dtype ] ]
]

{ #category : #'instance creation' }
NDArray class >> meshGridOf: anArray [
	| arrays newShape |
	arrays := self meshArraysOf: anArray.
	newShape := self meshShapeOf: anArray.
	^ anArray
		withIndexCollect: [ :each :index | 
			| s newDtype |
			newDtype := each dtype.
			s := WriteStream on: (self newArrayDtype: newDtype).
			self writeMeshGridArrayOf: arrays at: index on: s.
			self array: s contents shape: newShape ]
]

{ #category : #private }
NDArray class >> meshShapeOf: anArray [
	| list |
	list := anArray collect: [ :each | each size ].
	list swap: 1 with: 2.
	^ list
]

{ #category : #private }
NDArray class >> newArrayDtype: aSymbol [
	aSymbol = #Float
		ifTrue: [ ^ FloatArray new ].
	aSymbol = #Byte
		ifTrue: [ ^ ByteArray new ].
	aSymbol = #Word
		ifTrue: [ ^ WordArray new ].
	aSymbol = #Integer
		ifTrue: [ ^ IntegerArray new ].
	aSymbol = #Boolean
		ifTrue: [ ^ Array new ].
	self error
]

{ #category : #private }
NDArray class >> newArrayDtype: aSymbol size: anInteger [
	aSymbol = #Float
		ifTrue: [ ^ FloatArray new: anInteger ].
	aSymbol = #Byte
		ifTrue: [ ^ ByteArray new: anInteger ].
	aSymbol = #Word
		ifTrue: [ ^ WordArray new: anInteger ].
	aSymbol = #Integer
		ifTrue: [ ^ IntegerArray new: anInteger ].
	aSymbol = #Boolean
		ifTrue: [ ^ Array new: anInteger ].
	self error
]

{ #category : #private }
NDArray class >> newArrayDtype: aSymbol size: anInteger withAll: aNumber [
	aSymbol = #Float
		ifTrue: [ ^ FloatArray new: anInteger withAll: aNumber ].
	aSymbol = #Byte
		ifTrue: [ ^ ByteArray new: anInteger withAll: aNumber ].
	aSymbol = #Word
		ifTrue: [ ^ WordArray new: anInteger withAll: aNumber ].
	aSymbol = #Integer
		ifTrue: [ ^ IntegerArray new: anInteger withAll: aNumber ].
	aSymbol = #Boolean
		ifTrue: [ ^ Array new: anInteger withAll: aNumber ].
	self error
]

{ #category : #private }
NDArray class >> normalizedIndex: anObject [
	^ anObject isNumber
		ifTrue: [ Array with: anObject asInteger ]
		ifFalse: [ anObject copy asArray ]
]

{ #category : #private }
NDArray class >> normalizedIndexes: anArray [
	| sizes result tmp |
	anArray isEmpty
		ifTrue: [ ^ #() ].
	sizes := anArray collect: #size.
	result := Array new: anArray size.
	anArray
		withIndexDo: [ :each :index | 
			tmp := each size = sizes max
				ifTrue: [ each copy ]
				ifFalse: [ each size = 1
						ifTrue: [ Array new: sizes max withAll: each first ]
						ifFalse: [ self error ] ].
			result at: index put: tmp ].
	^ result
]

{ #category : #'instance creation' }
NDArray class >> ones: anObject dtype: aSymbol [
	^ self full: anObject withAll: 1 dtype: aSymbol
]

{ #category : #accessing }
NDArray class >> presumeDtype: anArray [
	| arr |
	anArray isNDArray
		ifTrue: [ ^ anArray dtype ].
	arr := anArray flattened.
	arr isEmpty
		ifTrue: [ ^ #Float ].
	(arr allSatisfy: [ :each | each = true or: [ each = false ] ])
		ifTrue: [ ^ #Boolean ].
	(arr allSatisfy: [ :each | each isInteger ])
		ifTrue: [ ^ #Integer ].
	(arr allSatisfy: [ :each | each isNumber ])
		ifTrue: [ ^ #Float ].
	self error
]

{ #category : #private }
NDArray class >> setupCoerces [
	| dict |
	dict := Dictionary new.
	dict at: #Float at: #Integer put: #Float.
	dict at: #Float at: #Word put: #Float.
	dict at: #Float at: #Byte put: #Float.
	dict at: #Float at: #Boolean put: #Float.
	dict at: #Integer at: #Float put: #Float.
	dict at: #Integer at: #Word put: #Integer.
	dict at: #Integer at: #Byte put: #Integer.
	dict at: #Integer at: #Boolean put: #Integer.
	dict at: #Word at: #Float put: #Float.
	dict at: #Word at: #Integer put: #Integer.
	dict at: #Word at: #Byte put: #Word.
	dict at: #Word at: #Boolean put: #Word.
	dict at: #Byte at: #Float put: #Float.
	dict at: #Byte at: #Integer put: #Integer.
	dict at: #Byte at: #Word put: #Word.
	dict at: #Byte at: #Boolean put: #Byte.
	dict at: #Boolean at: #Float put: #Float.
	dict at: #Boolean at: #Integer put: #Integer.
	dict at: #Boolean at: #Word put: #Word.
	dict at: #Boolean at: #Byte put: #Byte.
	Coerces := dict
]

{ #category : #private }
NDArray class >> shape: anObject generateEach: aBlock [
	| shape array |
	shape := self normalizedIndex: anObject.
	array := FloatArray new: (self finiteProductOf: shape).
	1 to: array size do: [ :each | array at: each put: aBlock value ].
	^ self array: array shape: shape
]

{ #category : #private }
NDArray class >> shapeOf: anArray [
	| arr list |
	arr := anArray.
	list := OrderedCollection new.
	[ (arr isKindOf: ArrayedCollection) and: [ arr notEmpty ] ]
		whileTrue: [ list add: arr size.
			arr := arr first ].
	^ list asArray
]

{ #category : #private }
NDArray class >> writeMeshGridArrayOf: anArray at: anInteger on: aStream [
	| sizes count count2 |
	sizes := anArray collect: #size.
	anArray size < 2
		ifTrue: [ self error ].
	anInteger = 1
		ifTrue: [ count := self finiteProductOf: (sizes copyFrom: 3 to: sizes size).
			sizes second
				timesRepeat: [ anArray first
						do: [ :each | count timesRepeat: [ aStream nextPut: each ] ] ].
			^ self ].
	anInteger = 2
		ifTrue: [ count := (self finiteProductOf: sizes) / sizes second.
			anArray second
				do: [ :each | count timesRepeat: [ aStream nextPut: each ] ].
			^ self ].
	anInteger = anArray size
		ifTrue: [ count := (self finiteProductOf: sizes) / sizes last.
			count timesRepeat: [ aStream nextPutAll: anArray last ].
			^ self ].
	count := self finiteProductOf: (sizes copyFrom: 1 to: anInteger - 1).
	count2 := self
		finiteProductOf: (sizes copyFrom: anInteger + 1 to: sizes size).
	count
		timesRepeat: [ (anArray at: anInteger)
				do: [ :each | count2 timesRepeat: [ aStream nextPut: each ] ] ]
]

{ #category : #'instance creation' }
NDArray class >> zeros: anObject dtype: aSymbol [
	| arr shape size |
	shape := self normalizedIndex: anObject.
	size := self finiteProductOf: shape.
	arr := self newArrayDtype: aSymbol size: size.
	^ self array: arr shape: shape
]

{ #category : #'instance creation' }
NDArray class >> zerosLike: aNDArray [
	| arr |
	arr := self newArrayDtype: aNDArray dtype size: aNDArray size.
	^ self array: arr shape: aNDArray shape copy
]

{ #category : #accessing }
NDArray >> array [
	^ array
]

{ #category : #private }
NDArray >> arrayAt: anInteger [
	^ array at: anInteger
]

{ #category : #private }
NDArray >> arrayAt: anInteger put: anObject [
	array at: anInteger put: anObject
]

{ #category : #private }
NDArray >> arrayIndexAt: anArray [
	| pos list |
	list := self itemSizeList.
	pos := 1.
	anArray
		withIndexDo: [ :each :index | pos := pos + ((each - 1) * (list at: index)) ].
	^ pos
]

{ #category : #converting }
NDArray >> asArray [
	| list s |
	list := self array asArray.
	self shape copyWithoutFirst reversed
		do: [ :size | 
			s := WriteStream on: Array new.
			1 to: list size / size do:
				[ :pos | s nextPut: (list copyFrom: (pos - 1) * size + 1 to: pos * size) ].
			list := s contents ].
	^ list
]

{ #category : #converting }
NDArray >> asColoredForm [
	| obj r w b |
	obj := self withShape: (self shape copyFrom: 1 to: 2).
	r := ReadStream on: obj array.
	w := WriteStream on: Array new.
	[ r atEnd ]
		whileFalse: [ b := 16rFF.
			b := (b << 8) + r next.
			b := (b << 8) + r next.
			b := (b << 8) + r next.
			w nextPut: b ].
	^ Form
		extent: self shape second @ self shape first
		depth: 32
		fromArray: w contents
		offset: 0 @ 0
]

{ #category : #converting }
NDArray >> asFlatArray [
	^ self array asArray
]

{ #category : #converting }
NDArray >> asForm [
	self dtype = #Byte
		ifFalse: [ self error ].
	(self ndim = 2 or: [ self ndim = 3 and: [ self shape last = 1 ] ])
		ifTrue: [ ^ self asGrayScale ].
	(self ndim = 3 and: [ self shape last = 3 ])
		ifTrue: [ ^ self asColoredForm ].
	self error
]

{ #category : #converting }
NDArray >> asGrayScale [
	| obj r w b d |
	obj := self withShape: (self shape copyFrom: 1 to: 2).
	r := ReadStream on: obj array.
	w := WriteStream on: Array new.
	[ r atEnd ]
		whileFalse: [ b := 16rFF.
			d := r next.
			b := (b << 8) + d.
			b := (b << 8) + d.
			b := (b << 8) + d.
			w nextPut: b ].
	^ Form
		extent: self shape second @ self shape first
		depth: 32
		fromArray: w contents
		offset: 0 @ 0
]

{ #category : #converting }
NDArray >> asNDArray [
	^ self
]

{ #category : #converting }
NDArray >> broadcastTo: anObject [
	| ndim newShape obj |
	obj := self.
	newShape := anObject shape.
	ndim := anObject ndim.
	self ndim > ndim
		ifTrue: [ newShape := anObject shapeWithNdim: self ndim ]
		ifFalse: [ self ndim < ndim
				ifTrue: [ obj := self copyWithNdim: ndim ] ].
	^ obj broadcastToShape: newShape
]

{ #category : #private }
NDArray >> broadcastToShape: anArray [
	| r1 r2 newShape itemSize count newArray s pos |
	self ndim = anArray size
		ifFalse: [ self error ].
	newShape := self shape copy.
	newArray := self array copy.
	1 to: self ndim do: [ :index | 
		r1 := newShape at: index.
		r2 := anArray at: index.
		(r1 < r2 and: [ r1 ~= 1 ])
			ifTrue: [ self error ].
		(r1 = 1 and: [ r2 > r1 ])
			ifTrue: [ newShape at: index put: r2.
				itemSize := self itemSizeAxis: index.
				count := self class
					finiteProductOf: (newShape copyFrom: 1 to: index - 1).
				s := WriteStream on: newArray class new.
				1 to: count do: [ :each | 
					pos := (each - 1) * itemSize + 1.
					r2
						timesRepeat: [ s nextPutAll: (newArray copyFrom: pos to: pos + itemSize - 1) ] ].
				newArray := s contents ] ].
	^ self class array: newArray shape: newShape
]

{ #category : #private }
NDArray >> coerceDtype: aSymbol [
	| newDtype newArray |
	newDtype := self class coerceDtype: self dtype with: aSymbol.
	newDtype = self dtype
		ifTrue: [ ^ self ].
	newArray := nil.
	newDtype = #Boolean
		ifTrue: [ newArray := self convertToBoolean ].
	newDtype = #Byte
		ifTrue: [ newArray := self convertToByte ].
	newDtype = #Float
		ifTrue: [ newArray := self convertToFloat ].
	newDtype = #Integer
		ifTrue: [ newArray := self convertToInteger ].
	newDtype = #Word
		ifTrue: [ newArray := self convertToWord ].
	newArray ifNil: [ self error ].
	array := newArray
]

{ #category : #enumerating }
NDArray >> collect: aBlock [
	| s |
	s := WriteStream on: Array new.
	1 to: self shape first do: [ :each | s nextPut: (aBlock cull: (self at: each)) ].
	^ s contents
]

{ #category : #private }
NDArray >> convertToBoolean [
	self dtype = #Boolean
		ifTrue: [ ^ array copy ].
	^ self array asArray collect: [ :each | (each closeTo: 0) not ]
]

{ #category : #private }
NDArray >> convertToByte [
	| newArray |
	newArray := ByteArray new: self size.
	self array
		withIndexDo: [ :each :index | 
			| num |
			num := self dtype = #Boolean
				ifTrue: [ each
						ifTrue: [ 1 ]
						ifFalse: [ 0 ] ]
				ifFalse: [ each truncated min: 255 max: 0 ].
			newArray at: index put: num ].
	^ newArray
]

{ #category : #private }
NDArray >> convertToFloat [
	| newArray |
	newArray := FloatArray new: self size.
	self array
		withIndexDo: [ :each :index | 
			| num |
			num := self dtype = #Boolean
				ifTrue: [ each
						ifTrue: [ 1 ]
						ifFalse: [ 0 ] ]
				ifFalse: [ each ].
			newArray at: index put: num ].
	^ newArray
]

{ #category : #private }
NDArray >> convertToInteger [
	| newArray |
	newArray := IntegerArray new: self size.
	self array
		withIndexDo: [ :each :index | 
			| num |
			num := self dtype = #Boolean
				ifTrue: [ each
						ifTrue: [ 1 ]
						ifFalse: [ 0 ] ]
				ifFalse: [ each truncated ].
			newArray at: index put: num ].
	^ newArray
]

{ #category : #private }
NDArray >> convertToWord [
	| newArray |
	newArray := WordArray new: self size.
	self array
		withIndexDo: [ :each :index | 
			| num |
			num := self dtype = #Boolean
				ifTrue: [ each
						ifTrue: [ 1 ]
						ifFalse: [ 0 ] ]
				ifFalse: [ each truncated min: 16rFFFF max: 0 ].
			newArray at: index put: num ].
	^ newArray
]

{ #category : #copying }
NDArray >> copy [
	^ self class
		array: self array copy
		shape: self shape copy
]

{ #category : #copying }
NDArray >> copyFrom: anInteger1 to: anInteger2 [
	| itemSize from to newArray s |
	s := self shape copyWithoutFirst.
	itemSize := self class finiteProductOf: s.
	from := (anInteger1 - 1) * itemSize + 1.
	to := anInteger2 * itemSize.
	newArray := self array copyFrom: from to: to.
	^ self class
		array: newArray
		shape: (Array with: anInteger2 - anInteger1 + 1) , s
]

{ #category : #copying }
NDArray >> copyWithNdim: anInteger [
	^ self class
		array: self array copy
		shape: (self shapeWithNdim: anInteger)
]

{ #category : #enumerating }
NDArray >> do: aBlock [
	1 to: self shape first do: [ :each | aBlock cull: (self at: each) ]
]

{ #category : #accessing }
NDArray >> dtype [
	^ self array dtype
]

{ #category : #accessing }
NDArray >> extent [
	^ self shape first @ self shape second
]

{ #category : #accessing }
NDArray >> flatten [
	^ self class
		array: self array copy
		shape: (Array with: (self class finiteProductOf: self shape))
]

{ #category : #testing }
NDArray >> isNDArray [
	^ true
]

{ #category : #private }
NDArray >> itemSizeList [
	^ (1 to: self ndim) collect: [ :each | self itemSizeAxis: each ]
]

{ #category : #accessing }
NDArray >> len [
	^ self shape first
]

{ #category : #accessing }
NDArray >> ndim [
	^ self shape size
]

{ #category : #private }
NDArray >> presumeShape: anArray [
	| r index |
	r := self class finiteProductOf: anArray.
	index := anArray indexOf: -1.
	(r < 0 and: [ index > 0 ])
		ifFalse: [ self error ].
	^ anArray copy
		at: index put: self array size // r negated;
		yourself
]

{ #category : #printing }
NDArray >> printOn: aStream [
	aStream nextPutAll: 'array['.
	array printElementsOn: aStream.
	aStream nextPutAll: ',shape='.
	shape printElementsOn: aStream.
	aStream
		nextPutAll: ',dtype=';
		nextPutAll: self dtype asString;
		nextPut: $]
]

{ #category : #private }
NDArray >> privArray: anArray [
	array := anArray
]

{ #category : #private }
NDArray >> privShape: anArray [
	shape := anArray
]

{ #category : #private }
NDArray >> rawAt: anInteger [
	| newSize from to |
	newSize := self class finiteProductOf: shape copyWithoutFirst.
	from := (anInteger - 1) * newSize + 1.
	to := from + newSize - 1.
	^ array copyFrom: from to: to
]

{ #category : #modifying }
NDArray >> reShape: anArray [
	| newShape |
	newShape := (anArray includes: -1)
		ifTrue: [ self presumeShape: anArray ]
		ifFalse: [ anArray ].
	(self class finiteProductOf: self shape)
		= (self class finiteProductOf: newShape)
		ifFalse: [ self error ].
	shape := newShape
]

{ #category : #accessing }
NDArray >> shape [
	^ shape
]

{ #category : #private }
NDArray >> shapeWithNdim: anInteger [
	| ndim |
	ndim := self ndim.
	ndim > anInteger
		ifTrue: [ self error ].
	^ (Array new: anInteger - ndim withAll: 1) , self shape
]

{ #category : #private }
NDArray >> shapeWithoutAxis: anInteger [
	^ self shape copyWithoutIndex: anInteger
]

{ #category : #accessing }
NDArray >> size [
	^ self array size
]

{ #category : #converting }
NDArray >> withDtype: aSymbol [
	| newArray |
	self dtype = aSymbol
		ifTrue: [ ^ self copy ].
	newArray := nil.
	aSymbol = #Float
		ifTrue: [ newArray := self convertToFloat ].
	aSymbol = #Integer
		ifTrue: [ newArray := self convertToInteger ].
	aSymbol = #Byte
		ifTrue: [ newArray := self convertToByte ].
	aSymbol = #Word
		ifTrue: [ newArray := self convertToWord ].
	aSymbol = #Boolean
		ifTrue: [ newArray := self convertToBoolean ].
	newArray ifNil: [ self error ].
	^ self class array: newArray shape: self shape copy
]

{ #category : #converting }
NDArray >> withShape: anArray [
	| newShape |
	newShape := (anArray includes: -1)
		ifTrue: [ self presumeShape: anArray ]
		ifFalse: [ anArray ].
	(self class finiteProductOf: self shape)
		= (self class finiteProductOf: newShape)
		ifFalse: [ self error ].
	^ self class array: self array copy shape: newShape
]
