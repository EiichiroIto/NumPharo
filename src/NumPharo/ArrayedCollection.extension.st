Extension { #name : #ArrayedCollection }

{ #category : #'*NumPharo' }
ArrayedCollection >> **= other [
	self inplace: #** with: other
]

{ #category : #'*NumPharo' }
ArrayedCollection >> *= other [
	self inplace: #* with: other
]

{ #category : #'*NumPharo' }
ArrayedCollection >> += other [
	self inplace: #+ with: other
]

{ #category : #'*NumPharo' }
ArrayedCollection >> -= other [
	self inplace: #- with: other
]

{ #category : #'*NumPharo' }
ArrayedCollection >> /= other [
	self inplace: #/ with: other
]

{ #category : #'*NumPharo' }
ArrayedCollection >> \\= other [
	self inplace: #\\ with: other
]

{ #category : #'*NumPharo' }
ArrayedCollection >> argMax [
	^ self indexOf: self max
]

{ #category : #'*NumPharo' }
ArrayedCollection >> asFlatArray [
	^ self
]

{ #category : #'*NumPharo' }
ArrayedCollection >> dot: another [
	| result |
	result := 0.
	1 to: self size do: [ :i | result := result + ((self at: i) * (another at: i)) ].
	^ result
]

{ #category : #'*NumPharo' }
ArrayedCollection >> inplace: aSymbol with: other [
	| block |
	block := other isNumber
		ifTrue: [ [ :index | other ] ]
		ifFalse: [ [ :index | other at: index ] ].
	self
		withIndexDo:
			[ :each :index | self at: index put: (each perform: aSymbol with: (block cull: index)) ]
]

{ #category : #'*NumPharo' }
ArrayedCollection >> inplaceMax: other [
	self inplace: #max: with: other
]

{ #category : #'*NumPharo' }
ArrayedCollection >> inplaceMin: other [
	self inplace: #min: with: other
]

{ #category : #'*NumPharo' }
ArrayedCollection >> isFlatArray [
	^ true
]

{ #category : #'*NumPharo' }
ArrayedCollection >> std [
	^ (self - self average) squared average sqrt
]

{ #category : #'*NumPharo' }
ArrayedCollection >> wrapCopyFrom: anInteger1 size: anInteger2 on: aCollection3 at: anInteger4 [
	| start end |
	start := (anInteger1 - 1) \\ self size + 1.
	end := start + anInteger2 - 1.
	end <= self size
		ifTrue: [ ^ aCollection3
				replaceFrom: anInteger4
				to: anInteger4 + anInteger2 - 1
				with: self
				startingAt: start ].
	aCollection3
		replaceFrom: anInteger4
		to: self size - start + anInteger4
		with: self
		startingAt: start.
	aCollection3
		replaceFrom: self size - start + anInteger4 + 1
		to: anInteger4 + anInteger2 - 1
		with: self
		startingAt: 1
]
