Class {
	#name : #NDArray,
	#superclass : #Object,
	#traits : 'TNDArrayArithmetics',
	#classTraits : 'TNDArrayArithmetics classTrait',
	#instVars : [
		'shape',
		'array',
		'dtype'
	],
	#classVars : [
		'Coerces',
		'Rand'
	],
	#category : #'NumPharo-Core'
}

{ #category : #'instance creation' }
NDArray class >> arangeFrom: from to: to by: step [
	^ self fromArray: (from to: to by: step) asArray
]

{ #category : #private }
NDArray class >> array: anArray1 shape: anArray2 dtype: aSymbol [
	^ self basicNew
		privArray: anArray1;
		privShape: anArray2;
		privDtype: aSymbol
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

{ #category : #accessing }
NDArray class >> coerceArray: aSymbol1 with: aSymbol2 [
	aSymbol1 = aSymbol2
		ifTrue: [ ^ aSymbol1 ].
	^ Coerces at: aSymbol1 at: aSymbol2
]

{ #category : #utilities }
NDArray class >> crossEntropyErrorY: y andT: t [
	| delta |
	delta := 1.0e-7.
	^ (t * (y + delta) ln) sum negated
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
	^ self array: arr shape: shape dtype: aSymbol
]

{ #category : #'instance creation' }
NDArray class >> fromArray: anArray shape: anArray2 dtype: aSymbol [
	| arr size |
	arr := nil.
	aSymbol = #Float
		ifTrue: [ arr := anArray copy asFloatArray ].
	aSymbol = #Integer
		ifTrue: [ arr := anArray copy asIntegerArray ].
	aSymbol = #Byte
		ifTrue: [ arr := anArray copy asByteArray ].
	aSymbol = #Word
		ifTrue: [ arr := anArray copy asWordArray ].
	aSymbol = #Boolean
		ifTrue: [ arr := anArray copy ].
	arr ifNil: [ self error: 'invalid dtype' ].
	size := self finiteProductOf: anArray2.
	size = arr size
		ifFalse: [ self error: 'invalid shape' ].
	^ self array: arr shape: anArray2 copy dtype: aSymbol
]

{ #category : #'class initialization' }
NDArray class >> initialize [
	"self initialize"
	self setupCoerces.
	Rand := Random new
]

{ #category : #'instance creation' }
NDArray class >> linspaceFrom: from to: to num: anInteger withEndPoint: aBoolean [
	| arr |
	arr := self arrayFrom: from to: to num: anInteger withEndPoint: aBoolean.
	^ self array: arr shape: (Array with: arr size) dtype: #Float
]

{ #category : #utilities }
NDArray class >> meanSquaredErrorY: y andT: t [
	^ 0.5 * ((y - t) ** 2) sum
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
				ifNotNil: [ self coerceArray: prev with: each dtype ] ]
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
			self array: s contents shape: newShape dtype: newDtype ]
]

{ #category : #private }
NDArray class >> meshShapeOf: anArray [
	| list |
	list := anArray collect: [ :each | each size ].
	list swap: 1 with: 2.
	^ list
]

{ #category : #accessing }
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

{ #category : #accessing }
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

{ #category : #'instance creation' }
NDArray class >> normalRandom: anObject [
	| shape array |
	shape := self normalizedIndex: anObject.
	array := FloatArray new: (self finiteProductOf: shape).
	1 to: array size do: [ :each | array at: each put: self normalRandomNumber ].
	^ self array: array shape: shape dtype: #Float
]

{ #category : #private }
NDArray class >> normalRandomNumber [
	| r |
	r := 0.0.
	12 timesRepeat: [ r := r + self uniformRandomNumber ].
	^ r - 6
]

{ #category : #private }
NDArray class >> normalizedIndex: anObject [
	^ anObject isNumber
		ifTrue: [ Array with: anObject asInteger ]
		ifFalse: [ anObject asArray ]
]

{ #category : #'instance creation' }
NDArray class >> ones: anObject [
	| arr size shape |
	shape := self normalizedIndex: anObject.
	size := self finiteProductOf: shape.
	arr := IntegerArray new: size withAll: 1.
	^ self array: arr shape: shape dtype: #Integer
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

{ #category : #'instance creation' }
NDArray class >> random: anObject [
	| shape array |
	shape := self normalizedIndex: anObject.
	array := FloatArray new: (self finiteProductOf: shape).
	1 to: array size do: [ :each | array at: each put: self uniformRandomNumber ].
	^ self array: array shape: shape dtype: #Float
]

{ #category : #'instance creation' }
NDArray class >> randomChoice: anInteger from: aCollection [
	| list |
	list := aCollection isNumber
		ifTrue: [ 1 to: aCollection ]
		ifFalse: [ aCollection ].
	^ self
		fromArray: (list shuffled copyFrom: 1 to: anInteger)
		dtype: #Integer
]

{ #category : #utilities }
NDArray class >> relu: x [
	^ x min: x max: 0
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
NDArray class >> shapeOf: anArray [
	| arr list |
	arr := anArray.
	list := OrderedCollection new.
	[ (arr isKindOf: ArrayedCollection) and: [ arr notEmpty ] ]
		whileTrue: [ list add: arr size.
			arr := arr first ].
	^ list asArray
]

{ #category : #utilities }
NDArray class >> sigmoid: x [
	^ 1 / (1 + x negated exp)
]

{ #category : #utilities }
NDArray class >> softMax: a [
	| c exp sum |
	c := a max.
	exp := (a - c) exp.
	sum := exp sum.
	^ exp / sum
]

{ #category : #utilities }
NDArray class >> stepFunction: x [
	^ (x > 0) withDtype: #Integer
]

{ #category : #private }
NDArray class >> uniformRandomNumber [
	^ Rand next
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
NDArray class >> zeros: anObject [
	| arr size shape |
	shape := self normalizedIndex: anObject.
	size := self finiteProductOf: shape.
	arr := IntegerArray new: size.
	^ self array: arr shape: shape dtype: #Integer
]

{ #category : #'instance creation' }
NDArray class >> zerosLike: aNDArray [
	| arr |
	arr := self newArrayDtype: aNDArray dtype size: aNDArray size.
	^ self array: arr shape: aNDArray shape copy dtype: aNDArray dtype
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
	^ self array
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

{ #category : #accessing }
NDArray >> at: anArray [
	| arr pos num |
	arr := self class normalizedIndex: anArray.
	pos := self arrayIndexAt: arr.
	num := self itemSizeAxis: arr size.
	self ndim = arr size
		ifTrue: [ ^ array at: pos ].
	^ self class
		array: (array copyFrom: pos to: pos + num - 1)
		shape: (shape copyFrom: arr size + 1 to: shape size)
		dtype: dtype
]

{ #category : #modifying }
NDArray >> at: anArray put: anObject [
	| arr pos num |
	arr := self class normalizedIndex: anArray.
	pos := self arrayIndexAt: arr.
	num := self itemSizeAxis: arr size.
	num = 1
		ifTrue: [ ^ self arrayAt: pos put: anObject ].
	anObject size = num
		ifFalse: [ self error ].
	anObject asFlatArray
		withIndexDo: [ :each :index | self arrayAt: pos + index - 1 put: each ]
]

{ #category : #accessing }
NDArray >> atAll: anObject [
	^ anObject atAllInNDArray: self
]

{ #category : #modifying }
NDArray >> atAll: anObject put: anObject2 [
	self shouldBeImplemented
]

{ #category : #private }
NDArray >> atAllBooleans: aBooleanArray [
	| s |
	self size = aBooleanArray size
		ifFalse: [ ^ self atAllFlatBooleans: aBooleanArray ].
	s := WriteStream on: self array class new.
	self array
		with: aBooleanArray
		do: [ :each :flag | 
			flag
				ifTrue: [ s nextPut: each ] ].
	^ self class
		array: s contents
		shape: {s contents size}
		dtype: self dtype
]

{ #category : #private }
NDArray >> atAllFlatBooleans: aBooleanArray [
	| s c |
	self shape first = aBooleanArray size
		ifFalse: [ self error ].
	c := 0.
	s := WriteStream on: self array class new.
	aBooleanArray
		withIndexDo: [ :each :index | 
			each
				ifTrue: [ s nextPutAll: (self rawAt: index).
					c := c + 1 ] ].
	^ self class
		array: s contents
		shape: (Array with: c) , self shape copyWithoutFirst
		dtype: self dtype
]

{ #category : #private }
NDArray >> atAllInNDArray: aNdArray [
	self dtype = #Boolean
		ifTrue: [ ^ aNdArray atAllBooleans: self array ].
	^ aNdArray atAllIndexes: self array
]

{ #category : #private }
NDArray >> atAllIndexes: anArray [
	| s c |
	c := 0.
	s := WriteStream on: self array class new.
	anArray
		do: [ :index | 
			s nextPutAll: (self rawAt: index rounded).
			c := c + 1 ].
	^ self class
		array: s contents
		shape: (Array with: c) , self shape copyWithoutFirst
		dtype: self dtype
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
	^ self class array: newArray shape: newShape dtype: self dtype
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
	dtype = #Boolean
		ifTrue: [ ^ self copy ].
	^ self class
		array: (self array asArray collect: [ :each | (each closeTo: 0) not ])
		shape: self shape copy
		dtype: #Boolean
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
	^ self class array: newArray shape: self shape copy dtype: #Byte
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
	^ self class array: newArray shape: self shape copy dtype: #Float
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
	^ self class array: newArray shape: self shape copy dtype: #Integer
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
	^ self class array: newArray shape: self shape copy dtype: #Word
]

{ #category : #copying }
NDArray >> copy [
	^ self class
		array: self array copy
		shape: self shape copy
		dtype: self dtype
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
		dtype: self dtype
]

{ #category : #copying }
NDArray >> copyWithNdim: anInteger [
	^ self class
		array: self array copy
		shape: (self shapeWithNdim: anInteger)
		dtype: self dtype
]

{ #category : #enumerating }
NDArray >> do: aBlock [
	1 to: self shape first do: [ :each | aBlock cull: (self at: each) ]
]

{ #category : #accessing }
NDArray >> dtype [
	^ dtype
]

{ #category : #accessing }
NDArray >> flatten [
	^ self class
		array: self array copy
		shape: (Array with: (self class finiteProductOf: self shape))
		dtype: self dtype
]

{ #category : #accessing }
NDArray >> indexAt: anInteger [
	| r v a |
	v := anInteger - 1.
	r := WriteStream on: Array new.
	1 to: self ndim do: [ :each | 
		a := self itemSizeAxis: each.
		r nextPut: (v // a) + 1.
		v := v \\ a ].
	^ r contents
]

{ #category : #initialization }
NDArray >> initialize [
	shape := Array new.
	dtype := nil.
	array := Array new
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
		nextPutAll: dtype asString;
		nextPut: $]
]

{ #category : #private }
NDArray >> privArray: anArray [
	array := anArray
]

{ #category : #private }
NDArray >> privDtype: aSymbol [
	dtype := aSymbol
]

{ #category : #private }
NDArray >> privRoll: anInteger1 axis: anInteger2 [
	| shift s count1 count2 itemSize blockSize |
	anInteger2 <= self ndim
		ifFalse: [ self error ].
	count1 := 1.
	count2 := self size.
	shift := anInteger1.
	itemSize := 1.
	anInteger2 > 0
		ifTrue: [ count1 := self class
				finiteProductOf: (self shape copyFrom: 1 to: anInteger2 - 1).
			count2 := self shape at: anInteger2.
			shift := anInteger1 \\ count2.
			itemSize := self itemSizeAxis: anInteger2 ].
	blockSize := self size // count1.
	s := WriteStream on: self array class new.
	1 to: count1 do: [ :each | 
		1 to: count2 do: [ :each2 | 
			| pos |
			pos := ((each - 1) * blockSize + ((each2 - shift - 1) \\ count2))
				* itemSize + 1.
			s nextPutAll: (self wrapCopyFrom: pos size: itemSize) ] ].
	^ self class array: s contents shape: self shape copy dtype: self dtype
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
NDArray >> t [
	| s |
	self ndim = 1
		ifTrue: [ ^ self ].
	s := WriteStream on: self newArray.
	self transposeOn: s.
	^ self class array: s contents shape: self shape reversed dtype: self dtype
]

{ #category : #converting }
NDArray >> withDtype: aSymbol [
	dtype = aSymbol
		ifTrue: [ ^ self copy ].
	aSymbol = #Float
		ifTrue: [ ^ self convertToFloat ].
	aSymbol = #Integer
		ifTrue: [ ^ self convertToInteger ].
	aSymbol = #Byte
		ifTrue: [ ^ self convertToByte ].
	aSymbol = #Word
		ifTrue: [ ^ self convertToWord ].
	aSymbol = #Boolean
		ifTrue: [ ^ self convertToBoolean ].
	self error
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
	^ self class array: self array copy shape: newShape dtype: self dtype
]
