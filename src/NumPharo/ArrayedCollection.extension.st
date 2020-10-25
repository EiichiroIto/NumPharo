Extension { #name : #ArrayedCollection }

{ #category : #'*NumPharo' }
ArrayedCollection >> **= other [
	self
		withIndexDo:
			[ :each :index | self at: index put: (each ** (other at: index)) ]
]

{ #category : #'*NumPharo' }
ArrayedCollection >> *= other [
	self
		withIndexDo:
			[ :each :index | self at: index put: (each * (other at: index)) ]
]

{ #category : #'*NumPharo' }
ArrayedCollection >> += other [
	self
		withIndexDo:
			[ :each :index | self at: index put: (each + (other at: index)) ]
]

{ #category : #'*NumPharo' }
ArrayedCollection >> asNDArray [
	^ NDArray fromArray: self
]

{ #category : #'*NumPharo' }
ArrayedCollection >> inplaceMax: other [
	self
		withIndexDo:
			[ :each :index | self at: index put: (each max: (other at: index)) ]
]

{ #category : #'*NumPharo' }
ArrayedCollection >> inplaceMin: other [
	self
		withIndexDo:
			[ :each :index | self at: index put: (each min: (other at: index)) ]
]
