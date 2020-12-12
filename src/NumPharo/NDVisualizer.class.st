Class {
	#name : #NDVisualizer,
	#superclass : #SpPresenter,
	#instVars : [
		'image',
		'whenStepsDo'
	],
	#category : #'NumPharo-Plot'
}

{ #category : #specs }
NDVisualizer class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #image;
		yourself
]

{ #category : #examples }
NDVisualizer class >> example1 [
	| gs v |
	gs := GrayScott stripe.
	v := self new.
	v
		whenStepsDo: [ :p | 
			gs loop.
			p form: gs form ].
	v openWithSpec
]

{ #category : #examples }
NDVisualizer class >> example2 [
	| gs v |
	gs := GrayScott amorphous.
	v := self new.
	v
		whenStepsDo: [ :p | 
			gs loop.
			p form: gs form ].
	v openWithSpec
]

{ #category : #'api-showing' }
NDVisualizer >> defaultWindowPresenterClass [
	^ SpTickingWindowPresenter
]

{ #category : #accessing }
NDVisualizer >> form: aForm [
	image image: aForm
]

{ #category : #initialization }
NDVisualizer >> initializePresenters [
	image := self newImage.
	self focusOrder add: image
]

{ #category : #stepping }
NDVisualizer >> step [
	whenStepsDo ifNotNil: [ whenStepsDo cull: self ]
]

{ #category : #stepping }
NDVisualizer >> stepTime [
	^ 10
]

{ #category : #accessing }
NDVisualizer >> whenStepsDo [
	^ whenStepsDo
]

{ #category : #accessing }
NDVisualizer >> whenStepsDo: aBlock [
	whenStepsDo := aBlock
]
