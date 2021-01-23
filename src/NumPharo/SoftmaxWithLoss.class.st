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
SoftmaxWithLoss >> forwardX: x t: aNDArray2 [
	t := aNDArray2.
	y := NDArray softMax: x.
	loss := NDArray crossEntropyErrorY: y andT: t.
	^ loss
]
