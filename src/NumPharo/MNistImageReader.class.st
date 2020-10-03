Class {
	#name : #MNistImageReader,
	#superclass : #MNistReader,
	#instVars : [
		'images',
		'rows'
	],
	#category : #'NumPharo-MNist'
}

{ #category : #api }
MNistImageReader >> fromFileNamed: aString [
	| f size row col array |
	f := aString asFileReference.
	f
		binaryReadStreamDo: [ :s | 
			self readMagicFrom: s.
			size := self read32BitIntegerFrom: s.
			row := self read32BitIntegerFrom: s.
			col := self read32BitIntegerFrom: s.
			array := s next: size * row * col ].
	^ NDArray
		fromArray: array
		shape: (Array with: size with: row with: col)
		dtype: #Byte
]

{ #category : #private }
MNistImageReader >> magicNumber [
	^ 2051
]
