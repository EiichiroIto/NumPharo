"
MNIST data from http://yann.lecun.com/exdb/mnist/

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #MNistReader,
	#superclass : #Object,
	#category : #'NumPharo-MNist'
}

{ #category : #private }
MNistReader class >> checkFileAndDownload: aString [
	| zipfn fr |
	fr := FileSystem workingDirectory / aString.
	fr isFile
		ifTrue: [ ^ self ].
	zipfn := aString , '.gz'.
	(ZnClient new url: self masterUrl , zipfn) downloadTo: zipfn.
	GZipReadStream unzip: zipfn.
	fr isFile
		ifFalse: [ self error ].
	(FileSystem workingDirectory / zipfn) delete
]

{ #category : #private }
MNistReader class >> imageDataFrom: aString [
	self checkFileAndDownload: aString.
	^ self newImage fromFileNamed: aString
]

{ #category : #private }
MNistReader class >> labelDataFrom: aString [
	self checkFileAndDownload: aString.
	^ self newLabel fromFileNamed: aString
]

{ #category : #api }
MNistReader class >> load [
	| trainings tests |
	trainings := Array
		with: (self imageDataFrom: self trainingImageFilename)
		with: (self labelDataFrom: self trainingLabelFilename).
	tests := Array
		with: (self imageDataFrom: self testImageFilename)
		with: (self labelDataFrom: self testLabelFilename).
	^ Array with: trainings with: tests
]

{ #category : #private }
MNistReader class >> masterUrl [
	^ 'http://yann.lecun.com/exdb/mnist/'
]

{ #category : #private }
MNistReader class >> newImage [
	^ MNistImageReader new
]

{ #category : #private }
MNistReader class >> newLabel [
	^ MNistLabelReader new
]

{ #category : #private }
MNistReader class >> testImageFilename [
	^ 't10k-images-idx3-ubyte'
]

{ #category : #private }
MNistReader class >> testLabelFilename [
	^ 't10k-labels-idx1-ubyte'
]

{ #category : #private }
MNistReader class >> trainingImageFilename [
	^ 'train-images-idx3-ubyte'
]

{ #category : #private }
MNistReader class >> trainingLabelFilename [
	^ 'train-labels-idx1-ubyte'
]

{ #category : #private }
MNistReader >> magicNumber [
	self subclassResponsibility
]

{ #category : #'file in/out' }
MNistReader >> read32BitIntegerFrom: aStream [
	^ (aStream next: 4) asInteger
]

{ #category : #'file in/out' }
MNistReader >> read8BitIntegerFrom: aStream [
	^ aStream next
]

{ #category : #'file in/out' }
MNistReader >> readMagicFrom: aStream [
	| magic |
	magic := (self read32BitIntegerFrom: aStream) asInteger.
	magic ~= self magicNumber
		ifTrue: [ self error: 'invalid magic number' ]
]
