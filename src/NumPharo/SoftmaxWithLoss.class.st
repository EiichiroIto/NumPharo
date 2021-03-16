Class {
	#name : #SoftmaxWithLoss,
	#superclass : #NNLayer,
	#instVars : [
		't',
		'y',
		'loss'
	],
	#category : #'NumPharo-Demo'
}

{ #category : #api }
SoftmaxWithLoss >> backward: dout [
	| batchSize dx tmp |
	batchSize := t shape first.
	dx := t size = y size
		ifTrue: [ (y - t) / batchSize ]
		ifFalse: [ tmp := {(1 to: batchSize) asArray.
			t + 1}.
			dx := y at: tmp.
			dx := dx - 1.
			dx := dx / batchSize ].
	^ dx
]

{ #category : #api }
SoftmaxWithLoss >> forward: x t: aNDArray2 [
	t := aNDArray2.
	y := functions softMax: x.
	loss := functions crossEntropyErrorY: y andT: t.
	^ loss
]
