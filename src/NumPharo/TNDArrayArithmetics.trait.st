Trait {
	#name : #TNDArrayArithmetics,
	#category : #'NumPharo-Core'
}

{ #category : #arithmetic }
TNDArrayArithmetics >> * other [
	^ other adaptToNDArray: self andSend: #*=
]

{ #category : #arithmetic }
TNDArrayArithmetics >> ** other [
	^ other adaptToNDArray: self andSend: #'**='
]

{ #category : #arithmetic }
TNDArrayArithmetics >> + other [
	^ other adaptToNDArray: self andSend: #+=
]

{ #category : #arithmetic }
TNDArrayArithmetics >> - other [
	^ other adaptToNDArray: self andSend: #-=
]

{ #category : #arithmetic }
TNDArrayArithmetics >> / other [
	^ other adaptToNDArray: self andSend: #/=
]

{ #category : #comparing }
TNDArrayArithmetics >> < other [
	^ other adaptToNDArray: self andCompare: #<
]

{ #category : #comparing }
TNDArrayArithmetics >> <= other [
	^ other adaptToNDArray: self andCompare: #<=
]

{ #category : #comparing }
TNDArrayArithmetics >> = other [
	^ other adaptToNDArray: self andCompare: #=
]

{ #category : #comparing }
TNDArrayArithmetics >> > other [
	^ other adaptToNDArray: self andCompare: #>
]

{ #category : #comparing }
TNDArrayArithmetics >> >= other [
	^ other adaptToNDArray: self andCompare: #>=
]

{ #category : #arithmetic }
TNDArrayArithmetics >> \\ other [
	^ other adaptToNDArray: self andSend: #\\=
]

{ #category : #converting }
TNDArrayArithmetics >> adaptToInteger: rcvr andSend: selector [
	^ self adaptToNumber: rcvr andSend: selector
]

{ #category : #converting }
TNDArrayArithmetics >> adaptToNDArray: anObject andCompare: selector [
	| obj newObj newDtype |
	obj := self.
	newDtype := self class coerceDtype: self dtype with: anObject dtype.
	newObj := anObject withDtype: newDtype.
	self shape ~= anObject shape
		ifTrue: [ obj := self broadcastTo: newObj.
			newObj := newObj broadcastTo: self ].
	newObj
		privArray:
			(newObj array asArray
				with: obj array
				collect: [ :x :y | x perform: selector with: y ]).
	^ newObj
]

{ #category : #converting }
TNDArrayArithmetics >> adaptToNDArray: anObject andSend: selector [
	| obj newDtype newObj |
	newDtype := self class coerceDtype: anObject dtype with: self dtype.
	obj := self withDtype: newDtype.
	newObj := anObject withDtype: newDtype.
	self shape ~= newObj shape
		ifTrue: [ obj := self broadcastTo: newObj.
			newObj := newObj broadcastTo: self ].
	newObj array perform: selector asSymbol with: obj array.
	^ newObj
]

{ #category : #converting }
TNDArrayArithmetics >> adaptToNumber: rcvr andSend: selector [
	| arr |
	arr := self array species new: self array size withAll: rcvr.
	arr perform: (selector, '=') asSymbol with: self array.
	^ self class
		array: arr
		shape: self shape copy
]

{ #category : #private }
TNDArrayArithmetics >> argIndexAxis: anInteger [
	| total itemSize delta |
	itemSize := self itemSizeAxis: anInteger.
	total := self size / (self shape at: anInteger).
	delta := itemSize * (self shape at: anInteger).
	^ (0 to: total - 1)
		collect:
			[ :each | 1 + (each \\ itemSize) + (each // itemSize * delta) ]
]

{ #category : #arithmetic }
TNDArrayArithmetics >> argMax [
	^ self array indexOf: self array max
]

{ #category : #arithmetic }
TNDArrayArithmetics >> argMaxAxis: anInteger [
	^ self do: #argMax axis: anInteger dtype: #Integer
]

{ #category : #private }
TNDArrayArithmetics >> col2DArray: anInteger dtype: aSymbol [
	| newArray index delta |
	newArray := self class
		newArrayDtype: aSymbol
		size: self shape first.
	index := anInteger.
	delta := self shape second.
	1 to: self shape first do: [ :each | 
		newArray at: each put: (self arrayAt: index).
		index := index + delta ].
	^ newArray
]

{ #category : #private }
TNDArrayArithmetics >> collect: aBlock axis: anInteger dtype: aSymbol [
	| newShape items itemSize arr arr2 indexes |
	anInteger <= self ndim
		ifFalse: [ self error ].
	newShape := self shapeWithoutAxis: anInteger.
	items := self shape at: anInteger.
	itemSize := self itemSizeAxis: anInteger.
	indexes := self argIndexAxis: anInteger.
	arr := self class newArrayDtype: aSymbol size: indexes size.
	indexes
		withIndexDo: [ :each2 :index | 
			arr2 := self newArraySize: items.
			1 to: items do: [ :each | 
				| pos |
				pos := each2 + ((each - 1) * itemSize).
				arr2 at: each put: (self arrayAt: pos) ].
			arr at: index put: (aBlock cull: arr2) ].
	^ self class array: arr shape: newShape
]

{ #category : #arithmetic }
TNDArrayArithmetics >> cos [
	^ self newArrayDoing: #cos
]

{ #category : #arithmetic }
TNDArrayArithmetics >> do: aSymbol axis: anInteger dtype: aSymbol2 [
	anInteger = 0
		ifTrue: [ ^ self perform: aSymbol ].
	^ self
		collect: [ :array | array perform: aSymbol ]
		axis: anInteger
		dtype: aSymbol2
]

{ #category : #arithmetic }
TNDArrayArithmetics >> dot: aNDArray [
	| rows cols one another newDtype newShape newArray index colArrays rowArrays |
	one := self ndim = 1
		ifTrue: [ self
				withShape:
					{1.
					aNDArray shape first} ]
		ifFalse: [ self ].
	another := aNDArray ndim = 1
		ifTrue: [ aNDArray
				withShape:
					{aNDArray shape first.
					1} ]
		ifFalse: [ aNDArray ].
	one shape second = another shape first
		ifFalse: [ self error ].
	rows := one shape first.
	cols := another shape second.
	newShape := Array with: rows with: cols.
	newDtype := self class coerceDtype: self dtype with: aNDArray dtype.
	newArray := self class newArrayDtype: newDtype size: rows * cols.
	index := 1.
	rowArrays := (1 to: rows)
		collect: [ :each | one row2DArray: each dtype: newDtype ].
	colArrays := (1 to: cols)
		collect: [ :each | another col2DArray: each dtype: newDtype ].
	1 to: rows do: [ :row | 
		| r c |
		r := rowArrays at: row.
		1 to: cols do: [ :col | 
			c := colArrays at: col.
			newArray at: index put: (r dot: c).
			index := index + 1 ] ].
	newShape first = 1
		ifTrue: [ newShape := Array with: newShape second ]
		ifFalse: [ newShape second = 1
				ifTrue: [ newShape := Array with: newShape first ] ].
	^ self class array: newArray shape: newShape
]

{ #category : #arithmetic }
TNDArrayArithmetics >> exp [
	^ self newArrayDoing: #exp
]

{ #category : #accessing }
TNDArrayArithmetics >> indexAt: anInteger [
	| r v a |
	v := anInteger - 1.
	r := WriteStream on: Array new.
	1 to: self ndim do: [ :each | 
		a := self itemSizeAxis: each.
		r nextPut: (v // a) + 1.
		v := v \\ a ].
	^ r contents
]

{ #category : #testing }
TNDArrayArithmetics >> isZero [
	^ false
]

{ #category : #private }
TNDArrayArithmetics >> itemSizeAxis: anInteger [
	^ self class
		finiteProductOf: (self shape copyFrom: anInteger + 1 to: self shape size)
]

{ #category : #arithmetic }
TNDArrayArithmetics >> ln [
	^ self newArrayDoing: #ln
]

{ #category : #arithmetic }
TNDArrayArithmetics >> log [
	^ self newArrayDoing: #log
]

{ #category : #arithmetic }
TNDArrayArithmetics >> max [
	^ self array max
]

{ #category : #arithmetic }
TNDArrayArithmetics >> maxAxis: anInteger [
	^ self do: #max axis: anInteger dtype: self dtype
]

{ #category : #arithmetic }
TNDArrayArithmetics >> maximum: other [
	^ other adaptToNDArray: self andSend: #inplaceMax:
]

{ #category : #arithmetic }
TNDArrayArithmetics >> min [
	^ self array min
]

{ #category : #arithmetic }
TNDArrayArithmetics >> min: min max: max [
	| newArray |
	newArray := self array
		withIndexCollect:
			[ :each :index | each min: (min arrayAt: index) max: (max arrayAt: index) ].
	^ self class array: newArray shape: self shape copy
]

{ #category : #arithmetic }
TNDArrayArithmetics >> minAxis: anInteger [
	^ self do: #min axis: anInteger dtype: self dtype
]

{ #category : #arithmetic }
TNDArrayArithmetics >> minimum: other [
	^ other adaptToNDArray: self andSend: #inplaceMin:
]

{ #category : #arithmetic }
TNDArrayArithmetics >> negated [
	^ self
		newArrayDoing:
			(self dtype = #Boolean
				ifTrue: [ #not ]
				ifFalse: [ #negated ])
]

{ #category : #private }
TNDArrayArithmetics >> newArrayComparing: aBlock [
	^ self class
		array: (self array asArray collect: aBlock)
		shape: self shape copy
]

{ #category : #private }
TNDArrayArithmetics >> newArrayDoing: aBlock [
	^ self class
		array: (self array collect: aBlock)
		shape: self shape copy
]

{ #category : #private }
TNDArrayArithmetics >> newArraySize: anInteger [
	^ self class newArrayDtype: self dtype size: anInteger
]

{ #category : #private }
TNDArrayArithmetics >> nextIndex: anArray [
	| newArray |
	anArray size = self ndim
		ifFalse: [ self error ].
	anArray = self shape
		ifTrue: [ ^ nil ].
	newArray := anArray copy.
	newArray
		withIndexDo: [ :each :index | 
			| b |
			b := self shape at: index.
			each < b
				ifTrue: [ newArray at: index put: each + 1.
					^ newArray ]
				ifFalse: [ newArray at: index put: 1 ] ].
	self error
]

{ #category : #private }
TNDArrayArithmetics >> privRoll: anInteger1 axis: anInteger2 [
	| shift count1 count2 itemSize blockSize arr dst |
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
	arr := self array class new: count1 * count2 * itemSize.
	dst := 1.
	1 to: count1 do: [ :each | 
		1 to: count2 do: [ :each2 | 
			| pos |
			pos := ((each - 1) * blockSize + ((each2 - shift - 1) \\ count2))
				* itemSize + 1.
			self array
				wrapCopyFrom: pos
				size: itemSize
				on: arr
				at: dst.
			dst := dst + itemSize ] ].
	^ self class array: arr shape: self shape copy
]

{ #category : #converting }
TNDArrayArithmetics >> roll: anInteger [
	^ self roll: anInteger axes: 0
]

{ #category : #converting }
TNDArrayArithmetics >> roll: anObject1 axes: anObject2 [
	| shifts axes obj |
	shifts := self class normalizedIndex: anObject1.
	axes := self class normalizedIndex: anObject2.
	shifts size = axes size
		ifFalse: [ self error ].
	obj := self.
	shifts with: axes do: [ :s :a | obj := obj privRoll: s axis: a ].
	^ obj
]

{ #category : #private }
TNDArrayArithmetics >> row2DArray: anInteger dtype: aSymbol [
	| pos size arr |
	pos := self arrayIndexAt: (Array with: anInteger).
	size := self itemSizeAxis: 1.
	arr := self class newArrayDtype: aSymbol size: size.
	1 to: size do: [ :each | arr at: each put: (self array at: pos + each - 1) ].
	^ arr
]

{ #category : #arithmetic }
TNDArrayArithmetics >> sin [
	^ self newArrayDoing: #sin
]

{ #category : #arithmetic }
TNDArrayArithmetics >> sum [
	| arr |
	arr := self dtype = #Boolean
		ifTrue: [ (self withDtype: #Integer) array ]
		ifFalse: [ self array ].
	^ arr sum
]

{ #category : #arithmetic }
TNDArrayArithmetics >> sumAxis: anInteger [
	^ self do: #sum axis: anInteger dtype: self dtype
]

{ #category : #converting }
TNDArrayArithmetics >> t [
	| arr arr2 i |
	self ndim = 1
		ifTrue: [ ^ self ].
	arr2 := self newArraySize: self size.
	arr := Array new: self ndim withAll: 1.
	1 to: self size do: [ :each | 
		i := self arrayIndexAt: arr.
		arr2 at: each put: (self array at: i).
		arr := self nextIndex: arr ].
	^ self class array: arr2 shape: self shape reversed
]

{ #category : #accessing }
TNDArrayArithmetics >> where [
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

{ #category : #comparing }
TNDArrayArithmetics >> ~= other [
	^ other adaptToNDArray: self andCompare: #~=
]
