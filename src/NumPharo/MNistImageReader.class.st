Class {
	#name : #MNistImageReader,
	#superclass : #MNistReader,
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
	^ Array with: (Array with: size with: row with: col) with: array
]

{ #category : #private }
MNistImageReader >> magicNumber [
	^ 2051
]
