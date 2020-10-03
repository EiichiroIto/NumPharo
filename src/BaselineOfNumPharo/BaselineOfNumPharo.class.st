Class {
	#name : #BaselineOfNumPharo,
	#superclass : #BaselineOf,
	#category : #BaselineOfNumPharo
}

{ #category : #baselines }
BaselineOfNumPharo >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'NumPharo';
				package: 'NumPharo-Tests'
					with: [ spec requires: #('NumPharo') ] ]
]

{ #category : #accessing }
BaselineOfNumPharo >> projectClass [
	^ MetacelloCypressBaselineProject
]
