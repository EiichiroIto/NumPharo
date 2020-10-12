Extension { #name : #ArrayedCollection }

{ #category : #'*NumPharo' }
ArrayedCollection >> asNDArray [
	^ NDArray fromArray: self
]
