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
Array >> asNDIndexes [
	self isFlatArray ifTrue: [ ^ self asNDArray ].
	self shouldBeImplemented
]

{ #category : #'*NumPharo' }
Array >> comprehension [
	^ NDArray comprehension: self
]

{ #category : #'*NumPharo' }
Array >> dtype [
	^ NDArray presumeDtype: self
]

{ #category : #'*NumPharo' }
Array >> isFlatArray [
	^ self allSatisfy: [ :each | each isCollection not ]
]
