Class {
	#name : #Chapter4Functions,
	#superclass : #Object,
	#category : #'NumPharo-Demo'
}

{ #category : #private }
Chapter4Functions >> crossEntropyErrorY: y andT: t [
	| delta |
	delta := 1.0e-7.
	^ (t * (y + delta) ln) sum negated
]

{ #category : #private }
Chapter4Functions >> sigmoid: x [
	^ 1 / (1 + x negated exp)
]

{ #category : #private }
Chapter4Functions >> softMax: a [
	| c exp sum |
	c := a max.
	exp := (a - c) exp.
	sum := exp sum.
	^ exp / sum
]
