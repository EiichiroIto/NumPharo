Class {
	#name : #MNistLabelReader,
	#superclass : #MNistReader,
	#category : #'NumPharo-MNist'
}

{ #category : #api }
MNistLabelReader >> fromFileNamed: aString [
	| f size array |
	f := aString asFileReference.
	f
		binaryReadStreamDo: [ :s | 
			self readMagicFrom: s.
			size := self read32BitIntegerFrom: s.
			array := s next: size ].
	^ array
]

{ #category : #private }
MNistLabelReader >> magicNumber [
	^ 2049
]
