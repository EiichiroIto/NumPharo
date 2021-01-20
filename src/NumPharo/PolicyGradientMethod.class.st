Class {
	#name : #PolicyGradientMethod,
	#superclass : #RLearning,
	#instVars : [
		'batches'
	],
	#category : #'NumPharo-Gym'
}

{ #category : #accessing }
PolicyGradientMethod >> batches [
	^ batches
]

{ #category : #accessing }
PolicyGradientMethod >> batches: anObject [
	batches := anObject
]
