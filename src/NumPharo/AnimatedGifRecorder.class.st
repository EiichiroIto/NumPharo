Class {
	#name : #AnimatedGifRecorder,
	#superclass : #Object,
	#instVars : [
		'writer',
		'frameDelay',
		'extent'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #api }
AnimatedGifRecorder >> close [
	self isOpen
		ifFalse: [ ^ self ].
	writer close.
	writer := nil
]

{ #category : #private }
AnimatedGifRecorder >> defaultFrameDelay [
	^ 10
]

{ #category : #accessing }
AnimatedGifRecorder >> extent [
	^ extent
]

{ #category : #accessing }
AnimatedGifRecorder >> extent: aPoint [
	extent := aPoint
]

{ #category : #accessing }
AnimatedGifRecorder >> frameDelay [
	^ frameDelay ifNil: [ self defaultFrameDelay ]
]

{ #category : #accessing }
AnimatedGifRecorder >> frameDelay: anInteger [
	frameDelay := anInteger
]

{ #category : #private }
AnimatedGifRecorder >> frameFromForm: aForm [
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
AnimatedGifRecorder >> isOpen [
	^ writer notNil
]

{ #category : #api }
AnimatedGifRecorder >> openFileNamed: aString [
	self close.
	writer := GIFReadWriter on: aString asFileReference binaryWriteStream.
	^ self
]

{ #category : #api }
AnimatedGifRecorder >> writeForm: aForm [
	| frame |
	self isOpen
		ifFalse: [ ^ self ].
	frame := self frameFromForm: aForm.
	writer nextPutFrame: frame
]
