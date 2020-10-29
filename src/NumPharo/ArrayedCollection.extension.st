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
ArrayedCollection >> asFlatArray [
	^ self
]

{ #category : #'*NumPharo' }
ArrayedCollection >> asNDArray [
	^ NDArray fromArray: self
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
