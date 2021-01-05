Class {
	#name : #NDIndexIterator,
	#superclass : #Object,
	#instVars : [
		'nextIndex',
		'shape'
	],
	#category : #'NumPharo-Core'
}

{ #category : #private }
NDIndexIterator >> indexesFor: aBlock [
	| l i |
	l := OrderedCollection new.
	[ i := aBlock value.
	i notNil ] whileTrue: [ l add: i ].
	^ l asArray
]

{ #category : #api }
NDIndexIterator >> indexesForPad [
	self nextIndex: nil.
	^ self indexesFor: [ self nextForPad ]
]

{ #category : #api }
NDIndexIterator >> indexesForT [
	self nextIndex: nil.
	^ self indexesFor: [ self nextForT ]
]

{ #category : #api }
NDIndexIterator >> nextForPad [
	nextIndex ifNil: [ ^ self resetIndex ].
	nextIndex last = 1
		ifFalse: [ ^ nil ].
	nextIndex size - 1 to: 1 by: -1 do: [ :index | 
			| each b |
			each := nextIndex at: index.
			b := shape at: index.
			each < b
				ifTrue: [ nextIndex at: index put: each + 1.
					^ nextIndex copy ]
				ifFalse: [ nextIndex at: index put: 1 ] ].
	^ nil
]

{ #category : #api }
NDIndexIterator >> nextForT [
	nextIndex ifNil: [ ^ self resetIndex ].
	nextIndex = shape
		ifTrue: [ ^ nil ].
	nextIndex
		withIndexDo: [ :each :index | 
			| b |
			b := shape at: index.
			each < b
				ifTrue: [ nextIndex at: index put: each + 1.
					^ nextIndex copy ]
				ifFalse: [ nextIndex at: index put: 1 ] ].
	self error
]

{ #category : #accessing }
NDIndexIterator >> nextIndex [
	^ nextIndex
]

{ #category : #accessing }
NDIndexIterator >> nextIndex: anObject [
	nextIndex := anObject
]

{ #category : #private }
NDIndexIterator >> resetIndex [
	nextIndex := Array new: shape size withAll: 1.
	^ nextIndex copy
]

{ #category : #accessing }
NDIndexIterator >> shape [
	^ shape
]

{ #category : #accessing }
NDIndexIterator >> shape: anArray [
	shape := anArray
]
