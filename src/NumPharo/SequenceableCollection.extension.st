Extension { #name : #SequenceableCollection }

{ #category : #'*NumPharo' }
SequenceableCollection >> asNDArray [
	^ NDArray fromArray: self asArray
]

{ #category : #'*NumPharo' }
SequenceableCollection >> permutateUsing: anArray [
	^ anArray collect: [ :each | self at: each ]
]
