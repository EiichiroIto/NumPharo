Trait {
	#name : #TNDArrayArithmetics,
	#category : #'NumPharo-Core'
}

{ #category : #arithmetic }
TNDArrayArithmetics >> * other [
	^ other adaptToNDArray: self andSend: #*
]

{ #category : #arithmetic }
TNDArrayArithmetics >> ** other [
	^ other adaptToNDArray: self andSend: #'**'
]

{ #category : #arithmetic }
TNDArrayArithmetics >> + other [
	^ other adaptToNDArray: self andSend: #+
]

{ #category : #arithmetic }
TNDArrayArithmetics >> - other [
	^ other adaptToNDArray: self andSend: #-
]

{ #category : #arithmetic }
TNDArrayArithmetics >> / other [
	^ other adaptToNDArray: self andSend: #/
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
	^ other adaptToNDArray: self andSend: #\\
]

{ #category : #converting }
TNDArrayArithmetics >> adaptToInteger: rcvr andSend: selector [
	^ self adaptToNumber: rcvr andSend: selector
]

{ #category : #converting }
TNDArrayArithmetics >> adaptToNDArray: anObject andCompare: selector [
	| obj rcvr |
	self shape = anObject shape
		ifTrue: [ obj := self.
			rcvr := anObject ]
		ifFalse: [ obj := self broadcastTo: anObject.
			rcvr := anObject broadcastTo: self ].
	^ rcvr
		newArrayComparing: [ :x :y | x perform: selector with: y ]
		with: obj
]

{ #category : #converting }
TNDArrayArithmetics >> adaptToNDArray: anObject andSend: selector [
	| obj rcvr |
	self shape = anObject shape
		ifTrue: [ obj := self.
			rcvr := anObject ]
		ifFalse: [ obj := self broadcastTo: anObject.
			rcvr := anObject broadcastTo: self ].
	^ rcvr
		newArrayDoing: [ :x :y | x perform: selector with: y ]
		with: obj
]

{ #category : #converting }
TNDArrayArithmetics >> adaptToNumber: rcvr andSend: selector [
	^ self class
		array: (self array collect: [ :each | rcvr perform: selector with: each ])
		shape: self shape
		dtype: self dtype
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
	| max |
	max := self array max.
	^ self array detectIndex: [ :each | each = max ]
]

{ #category : #arithmetic }
TNDArrayArithmetics >> argMaxAxis: anInteger [
	anInteger = 0
		ifTrue: [ ^ self argMax ].
	^ self collect: [ :array | array indexOf: array max ] axis: anInteger
]

{ #category : #accessing }
TNDArrayArithmetics >> col: anInteger [
	| newArray |
	self ndim = 2
		ifFalse: [ self error ].
	newArray := (1 to: self shape first)
		collect:
			[ :each | self arrayAt: (each - 1) * self shape second + anInteger ].
	^ self class
		array: newArray asFloatArray
		shape: {self shape first}
		dtype: self dtype
]

{ #category : #private }
TNDArrayArithmetics >> collect: aBlock axis: anInteger [
	| newShape items itemSize s s2 |
	anInteger <= self ndim
		ifFalse: [ self error ].
	newShape := self shapeWithoutAxis: anInteger.
	items := self shape at: anInteger.
	itemSize := self itemSizeAxis: anInteger.
	s := WriteStream on: Array new.
	(self argIndexAxis: anInteger)
		do: [ :each2 | 
			s2 := WriteStream on: self array class new.
			1 to: items do: [ :each | 
				| pos |
				pos := each2 + ((each - 1) * itemSize).
				s2 nextPut: (self arrayAt: pos) ].
			s nextPut: (aBlock cull: s2 contents) ].
	^ self class array: s contents shape: newShape dtype: self dtype
]

{ #category : #arithmetic }
TNDArrayArithmetics >> cos [
	^ self newArrayDoing: #cos
]

{ #category : #arithmetic }
TNDArrayArithmetics >> dot: aNDArray [
	| rows cols s1 s2 r one another ret |
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
	rows := one shape first.
	cols := another shape second.
	s1 := WriteStream on: Array new.
	1 to: rows do: [ :row | 
		s2 := WriteStream on: Array new.
		1 to: cols do: [ :col | 
			r := ((one row: row) * (another col: col)) sum.
			s2 nextPut: r ].
		s1 nextPut: s2 contents ].
	ret := self class fromArray: s1 contents dtype: self dtype.
	ret shape first = 1
		ifTrue: [ ret := ret withShape: {ret shape second} ]
		ifFalse: [ ret shape second = 1
				ifTrue: [ ret := ret withShape: {ret shape first} ] ].
	^ ret
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
	anInteger = 0
		ifTrue: [ ^ self argMax ].
	^ self collect: [ :array | array max ] axis: anInteger
]

{ #category : #arithmetic }
TNDArrayArithmetics >> maximum: other [
	^ other adaptToNDArray: self andSend: #max:
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
	^ self class array: newArray shape: self shape dtype: self dtype
]

{ #category : #arithmetic }
TNDArrayArithmetics >> minAxis: anInteger [
	anInteger = 0
		ifTrue: [ ^ self min ].
	^ self collect: [ :array | array min ] axis: anInteger
]

{ #category : #arithmetic }
TNDArrayArithmetics >> minimum: other [
	^ other adaptToNDArray: self andSend: #min:
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
		shape: self shape
		dtype: #Boolean
]

{ #category : #private }
TNDArrayArithmetics >> newArrayComparing: aBlock with: aNDArray [
	| obj dt |
	self dtype = aNDArray dtype
		ifTrue: [ dt := self dtype.
			obj := self ]
		ifFalse: [ dt := self class coerceArray: self dtype with: aNDArray dtype.
			obj := self withDtype: dt ].
	^ self class
		array: (obj array asArray with: aNDArray array collect: aBlock)
		shape: self shape
		dtype: #Boolean
]

{ #category : #private }
TNDArrayArithmetics >> newArrayDoing: aBlock [
	^ self class
		array: (self array collect: aBlock)
		shape: self shape
		dtype: self dtype
]

{ #category : #private }
TNDArrayArithmetics >> newArrayDoing: aBlock with: aNDArray [
	| obj dt |
	self dtype = aNDArray dtype
		ifTrue: [ dt := self dtype.
			obj := self ]
		ifFalse: [ dt := self class coerceArray: self dtype with: aNDArray dtype.
			obj := self withDtype: dt ].
	^ self class
		array: (obj array with: aNDArray array collect: aBlock)
		shape: self shape
		dtype: dt
]

{ #category : #private }
TNDArrayArithmetics >> privRoll: anInteger1 axis: anInteger2 [
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
	^ self class array: s contents shape: self shape dtype: self dtype
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

{ #category : #accessing }
TNDArrayArithmetics >> row: anInteger [
	self ndim = 2
		ifFalse: [ self error ].
	^ self at: anInteger
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
		collect: [ :each | self class array: each asIntegerArray shape: {each size} dtype: #Integer ]
]

{ #category : #private }
TNDArrayArithmetics >> wrapCopyFrom: anInteger1 size: anInteger2 [
	| start end size s |
	size := self array size.
	start := (anInteger1 - 1) \\ size + 1.
	end := start + anInteger2 - 1.
	end <= size
		ifTrue: [ ^ self array copyFrom: start to: end ].
	s := WriteStream on: self array class new.
	anInteger2
		timesRepeat: [ s nextPut: (self array atWrap: start).
			start := start + 1 ].
	^ s contents
]

{ #category : #comparing }
TNDArrayArithmetics >> ~= other [
	^ other adaptToNDArray: self andCompare: #~=
]
