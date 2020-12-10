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
Number >> asNDIndexes [
	^ Array with: self
]
