Extension { #name : #Number }

{ #category : #'*NumPharo' }
Number >> adaptToNDArray: rcvr andCompare: selector [
	^ rcvr newArrayComparing: [ :each | each perform: selector with: self ]
]

{ #category : #'*NumPharo' }
Number >> adaptToNDArray: rcvr andSend: selector [
	| newObj |
	newObj := rcvr copy.
	newObj array perform: selector with: self.
	^ newObj
]

{ #category : #'*NumPharo' }
Number >> asNDArray [
	^ NDArray fromArray: { self }
]

{ #category : #'*NumPharo' }
Number >> asNDIndexes [
	^ Array with: self
]

{ #category : #'*NumPharo' }
Number >> digitize: aNDArray right: aBoolean [
	| r |
	r := aNDArray array
		findBinaryIndex: [ :a | self - a ]
		ifNone: [ :a | a negated ].
	r := r > 0
		ifTrue: [ aBoolean
				ifTrue: [ r - 1 ]
				ifFalse: [ r ] ]
		ifFalse: [ r negated ].
	^ r + 1
]
