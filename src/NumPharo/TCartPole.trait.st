Trait {
	#name : #TCartPole,
	#category : #'NumPharo-Gym'
}

{ #category : #constants }
TCartPole >> maxNumberOfSteps [
	^ 200
]

{ #category : #constants }
TCartPole >> numActions [
	^ 2
]

{ #category : #constants }
TCartPole >> numObservations [
	^ 4
]
