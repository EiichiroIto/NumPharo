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
		'Coerces'
	],
	#category : #'NumPharo-Core'
}

{ #category : #'instance creation' }
NDArray class >> arangeFrom: from to: to by: step [
	| arr |
	arr := (from to: to by: step) asFloatArray.
	^ self array: arr shape: (Array with: arr size) dtype: #Float
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
	^ self fromArray: anArray dtype: #Float
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
		ifTrue: [ arr := anArray asFloatArray ].
	aSymbol = #Integer
		ifTrue: [ arr := anArray asIntegerArray ].
	aSymbol = #Byte
		ifTrue: [ arr := anArray asByteArray ].
	aSymbol = #Word
		ifTrue: [ arr := anArray asWordArray ].
	aSymbol = #Boolean
		ifTrue: [ arr := anArray copy ].
	arr ifNil: [ self error: 'invalid dtype' ].
	size := self finiteProductOf: anArray2.
	size = arr size
		ifFalse: [ self error: 'invalid shape' ].
	^ self array: arr copy shape: anArray2 dtype: aSymbol
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
	^ self array: arr shape: (Array with: arr size) dtype: #Float
]

{ #category : #utilities }
NDArray class >> meanSquaredErrorY: y andT: t [
	^ 0.5 * ((y - t) ** 2) sum
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

{ #category : #'instance creation' }
NDArray class >> random: anObject [
	| shape array r |
	shape := self normalizedIndex: anObject.
	r := Random new.
	array := FloatArray new: (self finiteProductOf: shape).
	1 to: array size do: [ :each | array at: each put: r next ].
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

{ #category : #'instance creation' }
NDArray class >> zeros: anObject [
	| arr size shape |
	shape := self normalizedIndex: anObject.
	size := self finiteProductOf: shape.
	arr := IntegerArray new: size.
	^ self array: arr shape: shape dtype: #Integer
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
	list := self array.
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
	num := self itemSizeAt: arr size.
	self ndim = arr size
		ifTrue: [ ^ array at: pos ].
	^ self class
		array: (array copyFrom: pos to: pos + num - 1)
		shape: (shape copyFrom: arr size + 1 to: shape size)
		dtype: dtype
]

{ #category : #accessing }
NDArray >> atAll: anObject [
	^ anObject atAllInNDArray: self
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
	| r1 r2 newShape num count newArray s pos |
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
				num := self itemSizeAt: index.
				count := self class
					finiteProductOf: (newShape copyFrom: 1 to: index - 1).
				s := WriteStream on: newArray class new.
				1 to: count do: [ :each | 
					pos := (each - 1) * num + 1.
					r2
						timesRepeat: [ s nextPutAll: (newArray copyFrom: pos to: pos + num - 1) ] ].
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

{ #category : #converting }
NDArray >> convertToBoolean [
	dtype = #Boolean
		ifTrue: [ ^ self ].
	^ self class
		array: (self array asArray collect: [ :each | (each closeTo: 0) not ])
		shape: self shape
		dtype: #Boolean
]

{ #category : #converting }
NDArray >> convertToByte [
	| newArray |
	dtype = #Byte
		ifTrue: [ ^ self ].
	newArray := nil.
	(#(#Float #Integer #Word) includes: dtype)
		ifTrue: [ newArray := self array asArray
				collect: [ :each | each truncated min: 255 max: 0 ] ].
	dtype = #Boolean
		ifTrue: [ newArray := self array asArray
				collect: [ :each | 
					each
						ifTrue: [ 1 ]
						ifFalse: [ 0 ] ] ].
	newArray ifNil: [ self error ].
	^ self class
		array: newArray asByteArray
		shape: self shape
		dtype: #Byte
]

{ #category : #converting }
NDArray >> convertToFloat [
	| newArray |
	dtype = #Float
		ifTrue: [ ^ self ].
	newArray := nil.
	dtype = #Boolean
		ifTrue: [ newArray := self array
				collect: [ :each | 
					each
						ifTrue: [ 1 ]
						ifFalse: [ 0 ] ] ].
	(#(#Integer #Byte #Word) includes: dtype)
		ifTrue: [ newArray := self array ].
	newArray ifNil: [ self error ].
	^ self class
		array: newArray asFloatArray
		shape: self shape
		dtype: #Float
]

{ #category : #converting }
NDArray >> convertToInteger [
	| newArray |
	dtype = #Integer
		ifTrue: [ ^ self ].
	newArray := nil.
	dtype = #Float
		ifTrue: [ newArray := self array asArray collect: #truncated ].
	dtype = #Boolean
		ifTrue: [ newArray := self array asArray
				collect: [ :each | 
					each
						ifTrue: [ 1 ]
						ifFalse: [ 0 ] ] ].
	(#(#Byte #Word) includes: dtype)
		ifTrue: [ newArray := self array ].
	newArray ifNil: [ self error ].
	^ self class
		array: newArray asIntegerArray
		shape: self shape
		dtype: #Integer
]

{ #category : #converting }
NDArray >> convertToWord [
	| newArray |
	dtype = #Word
		ifTrue: [ ^ self ].
	newArray := nil.
	(#(#Float #Integer #Byte) includes: dtype)
		ifTrue: [ newArray := self array asArray
				collect: [ :each | each truncated min: 16rFFFF max: 0 ] ].
	dtype = #Boolean
		ifTrue: [ newArray := self array asArray
				collect: [ :each | 
					each
						ifTrue: [ 1 ]
						ifFalse: [ 0 ] ] ].
	newArray ifNil: [ self error ].
	^ self class
		array: newArray asWordArray
		shape: self shape
		dtype: #Word
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
NDArray >> itemSizeAt: anInteger [
	^ self class
		finiteProductOf: (self shape copyFrom: anInteger + 1 to: self shape size)
]

{ #category : #private }
NDArray >> itemSizeList [
	^ (1 to: self ndim) collect: [ :each | self itemSizeAt: each ]
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

{ #category : #accessing }
NDArray >> size [
	^ self array size
]

{ #category : #converting }
NDArray >> withDtype: aSymbol [
	dtype = aSymbol
		ifTrue: [ ^ self ].
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
	^ self class array: self array shape: newShape dtype: self dtype
]
