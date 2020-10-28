Extension { #name : #Array }

{ #category : #'*NumPharo' }
Array >> adaptToNDArray: anObject andSend: selector [
	^ anObject
		adaptToNDArray: self asNDArray
		andSend: selector
]

{ #category : #'*NumPharo' }
Array >> asNDArray [
	^ NDArray fromArray: self dtype: #Float
]

{ #category : #'*NumPharo' }
Array >> atAllInNDArray: aNdArray [
	^ aNdArray atAllIndexes: self
]

{ #category : #'*NumPharo' }
Array >> dtype [
	^ NDArray presumeDtype: self
]
