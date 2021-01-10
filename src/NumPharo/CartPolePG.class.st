Class {
	#name : #CartPolePG,
	#superclass : #PolicyGradientMethod,
	#traits : 'TCartPole',
	#classTraits : 'TCartPole classTrait',
	#instVars : [
		'w',
		'n',
		'wTry',
		'batches',
		'rewards'
	],
	#category : #'NumPharo-Gym'
}

{ #category : #private }
CartPolePG >> actionFor: anArray [
	^ (self calculate: anArray) > 0.0
		ifTrue: [ 2 ]
		ifFalse: [ 1 ]
]

{ #category : #accessing }
CartPolePG >> batches [
	^ batches
]

{ #category : #accessing }
CartPolePG >> batches: anObject [
	batches := anObject
]

{ #category : #private }
CartPolePG >> calculate: anArray [
	^ (anArray asNDArray dot: wTry) at: 1
]

{ #category : #private }
CartPolePG >> changeEpisode [
	| std a wDelta |
	episode := episode + 1.
	std := rewards std.
	std = 0 ifTrue: [ std := 1 ].
	a := (rewards - rewards average) / std.
	wDelta := self eta / (self numBatches * self sigma) * (n t dot: a asNDArray).
	w := w + wDelta.
	self setupBatch
]

{ #category : #constants }
CartPolePG >> eta [
	^ 0.2
]

{ #category : #initialization }
CartPolePG >> initialize [
	super initialize.
	self setupRewards.
	self setupW.
	self setupBatch.
]

{ #category : #accessing }
CartPolePG >> n [
	^ n
]

{ #category : #accessing }
CartPolePG >> n: anObject [
	n := anObject
]

{ #category : #constants }
CartPolePG >> numBatches [
	^ 10
]

{ #category : #accessing }
CartPolePG >> rewards [
	^ rewards
]

{ #category : #accessing }
CartPolePG >> rewards: anObject [
	rewards := anObject
]

{ #category : #private }
CartPolePG >> setupBatch [
	batches := 1.
	self setupN.
	self setupWTry
]

{ #category : #private }
CartPolePG >> setupN [
	n := NDArray
		randomNormal:
			{self numBatches.
			w shape first}
		mean: 0
		std: self sigma
]

{ #category : #private }
CartPolePG >> setupRewards [
	rewards := Array new: self numBatches withAll: 0
]

{ #category : #private }
CartPolePG >> setupW [
	w := NDArray randomNormal: self numObservations
]

{ #category : #private }
CartPolePG >> setupWTry [
	wTry := w + (n at: batches)
]

{ #category : #private }
CartPolePG >> showInfo [
	Transcript
		show: 'episode=';
		show: episode * self numBatches;
		show: ' steps=';
		show: steps;
		show: ' mean=';
		show: recents average asFloat;
		cr
]

{ #category : #constants }
CartPolePG >> sigma [
	^ 0.05
]

{ #category : #api }
CartPolePG >> update: anArray reward: anInteger done: aBoolean [
	| reward |
	steps := steps + 1.
	(aBoolean not and: [ steps < self maxNumberOfSteps ])
		ifTrue: [ ^ self actionFor: anArray ].
	reward := steps >= self maxNumberOfSteps
		ifTrue: [ -1 ]
		ifFalse: [ steps - self maxNumberOfSteps ].
	self addSteps.
	batches >= (self numBatches - 1)
		ifTrue: [ self showInfo ].
	rewards at: batches put: reward.
	steps := 0.
	batches := batches + 1.
	batches < self numBatches
		ifTrue: [ self setupWTry.
			^ self defaultAction ].
	self changeEpisode.
	^ self defaultAction
]

{ #category : #accessing }
CartPolePG >> w [
	^ w
]

{ #category : #accessing }
CartPolePG >> w: anObject [
	w := anObject
]

{ #category : #accessing }
CartPolePG >> wTry [
	^ wTry
]

{ #category : #accessing }
CartPolePG >> wTry: anObject [
	wTry := anObject
]
