Extension { #name : #Array }

{ #category : #'*NumPharo' }
Array >> asNDArray [
	^ NDArray fromArray: self dtype: #Float
]

{ #category : #'*NumPharo' }
Array >> atAllInNDArray: aNdArray [
	^ aNdArray atAllIndexes: self
]
