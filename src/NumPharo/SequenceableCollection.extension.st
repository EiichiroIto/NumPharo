Extension { #name : #SequenceableCollection }

{ #category : #'*NumPharo' }
SequenceableCollection >> asNDArray [
	^ NDArray fromArray: self asArray
]
