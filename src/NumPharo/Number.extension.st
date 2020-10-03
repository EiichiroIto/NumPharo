Extension { #name : #Number }

{ #category : #'*NumPharo' }
Number >> adaptToNDArray: rcvr andSend: selector [
	^ rcvr newArrayDoing: [ :each | each perform: selector with: self ]
]
