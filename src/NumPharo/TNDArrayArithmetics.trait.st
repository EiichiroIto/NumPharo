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

{ #category : #arithmetic }
TNDArrayArithmetics >> < aNumber [
	^ self adaptToNumber: aNumber andSend: #>
]

{ #category : #arithmetic }
TNDArrayArithmetics >> <= aNumber [
	^ self adaptToNumber: aNumber andSend: #>=
]

{ #category : #arithmetic }
TNDArrayArithmetics >> > aNumber [
	^ self adaptToNumber: aNumber andSend: #<
]

{ #category : #arithmetic }
TNDArrayArithmetics >> >= aNumber [
	^ self adaptToNumber: aNumber andSend: #<=
]

{ #category : #converting }
TNDArrayArithmetics >> adaptToInteger: rcvr andSend: selector [
	^ self adaptToNumber: rcvr andSend: selector
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
	| arr newDtype |
	arr := self array.
	newDtype := self dtype.
	(#(< > = ~= <= >=) includes: selector)
		ifTrue: [ arr := self array asArray.
			newDtype := #Boolean ].
	^ self class
		array: (arr collect: [ :each | rcvr perform: selector with: each ])
		shape: self shape
		dtype: newDtype
]

{ #category : #arithmetic }
TNDArrayArithmetics >> argMax [
	| max |
	max := self array max.
	^ self array detectIndex: [ :each | each = max ]
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

{ #category : #testing }
TNDArrayArithmetics >> isZero [
	^ false
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
TNDArrayArithmetics >> max: max [
	| newArray |
	newArray := self array
		withIndexCollect:
			[ :each :index | each max: (max ndValueAt: index) ].
	^ self class array: newArray shape: self shape dtype: self dtype
]

{ #category : #arithmetic }
TNDArrayArithmetics >> min: min [
	| newArray |
	newArray := self array
		withIndexCollect:
			[ :each :index | each min: (min ndValueAt: index) ].
	^ self class array: newArray shape: self shape dtype: self dtype
]

{ #category : #arithmetic }
TNDArrayArithmetics >> min: min max: max [
	| newArray |
	newArray := self array
		withIndexCollect:
			[ :each :index | each min: (min ndValueAt: index) max: (max ndValueAt: index) ].
	^ self class array: newArray shape: self shape dtype: self dtype
]

{ #category : #private }
TNDArrayArithmetics >> ndValueAt: anInteger [
	^ self array at: anInteger
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
	^ self array sum
]
