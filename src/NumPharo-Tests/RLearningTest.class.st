"
A RLearningTest is a test class for testing the behavior of RLearning
"
Class {
	#name : #RLearningTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
RLearningTest >> newLearning [
	^ RLearning new
]

{ #category : #test }
RLearningTest >> testAddSteps [
	| l |
	l := self newLearning.
	l steps: 10.
	l addSteps.
	l steps: 20.
	l addSteps.
	self assertCollection: l total equals: #(10 20) asOrderedCollection.
	self assertCollection: l recents equals: #(10 20) asOrderedCollection.
	l numRecents: 2.
	l steps: 30.
	l addSteps.
	self
		assertCollection: l total
		equals: #(10 20 30) asOrderedCollection.
	self assertCollection: l recents equals: #(20 30) asOrderedCollection
]

{ #category : #test }
RLearningTest >> testEpisode [
	| c |
	c := self newLearning.
	self assert: c episode equals: 1.
	c episode: 123.
	self assert: c episode equals: 123
]

{ #category : #test }
RLearningTest >> testNumRecents [
	| l |
	l := self newLearning.
	self assert: l numRecents equals: l defaultNumRecents.
	l numRecents: 123.
	self assert: l numRecents equals: 123
]

{ #category : #test }
RLearningTest >> testRecents [
	| c |
	c := self newLearning.
	self assert: c recents isCollection.
	self assert: c recents isEmpty.
	c recents: #(1 2 3 4).
	self assertCollection: c recents equals: #(1 2 3 4)
]

{ #category : #test }
RLearningTest >> testSteps [
	| c |
	c := self newLearning.
	self assert: c steps equals: 0.
	c steps: 123.
	self assert: c steps equals: 123
]

{ #category : #test }
RLearningTest >> testTotal [
	| c |
	c := self newLearning.
	self assert: c total isCollection.
	self assert: c total isEmpty.
	c total: #(1 2 3 4).
	self assertCollection: c total equals: #(1 2 3 4)
]
