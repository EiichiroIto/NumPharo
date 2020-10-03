Extension { #name : #Point }

{ #category : #'*NumPharo' }
Point >> asArray [
	^ Array with: self x with: self y
]
