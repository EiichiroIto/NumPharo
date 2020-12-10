Class {
	#name : #PharoRecorder,
	#superclass : #Object,
	#instVars : [
		'writer',
		'frameDelay',
		'extent'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #api }
PharoRecorder >> close [
	self isOpen
		ifFalse: [ ^ self ].
	writer close.
	writer := nil
]

{ #category : #private }
PharoRecorder >> defaultFrameDelay [
	^ 10
]

{ #category : #accessing }
PharoRecorder >> extent [
	^ extent
]

{ #category : #accessing }
PharoRecorder >> extent: aPoint [
	extent := aPoint
]

{ #category : #accessing }
PharoRecorder >> frameDelay [
	^ frameDelay ifNil: [ self defaultFrameDelay ]
]

{ #category : #accessing }
PharoRecorder >> frameDelay: anInteger [
	frameDelay := anInteger
]

{ #category : #private }
PharoRecorder >> frameFromForm: aForm [
	| form |
	form := extent
		ifNil: [ aForm ]
		ifNotNil: [ aForm scaledToSize: extent ].
	^ AnimatedImageFrame new
		delay: self frameDelay;
		form: form as8BitColorForm;
		yourself
]

{ #category : #testing }
PharoRecorder >> isOpen [
	^ writer notNil
]

{ #category : #api }
PharoRecorder >> openFileNamed: aString [
	self close.
	writer := GIFReadWriter on: aString asFileReference binaryWriteStream.
	^ self
]

{ #category : #api }
PharoRecorder >> writeForm: aForm [
	| frame |
	self isOpen
		ifFalse: [ ^ self ].
	frame := self frameFromForm: aForm.
	writer nextPutFrame: frame
]
