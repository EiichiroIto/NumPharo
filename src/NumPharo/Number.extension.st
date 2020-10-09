Extension { #name : #Number }

{ #category : #'*NumPharo' }
Number >> adaptToNDArray: rcvr andCompare: selector [
	^ rcvr newArrayComparing: [ :each | each perform: selector with: self ]
]

{ #category : #'*NumPharo' }
Number >> adaptToNDArray: rcvr andSend: selector [
	^ rcvr newArrayDoing: [ :each | each perform: selector with: self ]
]
