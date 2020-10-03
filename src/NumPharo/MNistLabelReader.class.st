Class {
	#name : #MNistLabelReader,
	#superclass : #MNistReader,
	#instVars : [
		'labels'
	],
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
	^ NDArray fromArray: array dtype: #Byte
]

{ #category : #private }
MNistLabelReader >> magicNumber [
	^ 2049
]
