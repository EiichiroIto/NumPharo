Class {
	#name : #DeepLearningFromScratch1Chapter5,
	#superclass : #TestCase,
	#category : #'NumPharo-Demo'
}

{ #category : #tests }
DeepLearningFromScratch1Chapter5 >> testChapter5_4_1 [
	| mulAppleLayer mulTaxLayer apple appleNum tax applePrice price dPrice r dApplePrice dTax dAppleNum dApple |
	apple := 100.
	appleNum := 2.
	tax := 1.1.
	mulAppleLayer := MulLayer new.
	mulTaxLayer := MulLayer new.
	applePrice := mulAppleLayer forwardX: apple y: appleNum.
	price := mulTaxLayer forwardX: applePrice y: tax.
	self assert: price closeTo: 220.
	dPrice := 1.
	r := mulTaxLayer backward: dPrice.
	dApplePrice := r first.
	dTax := r second.
	r := mulAppleLayer backward: dApplePrice.
	dApple := r first.
	dAppleNum := r second.
	self assert: dApple closeTo: 2.2.
	self assert: dAppleNum closeTo: 110.
	self assert: dTax closeTo: 200
]

{ #category : #tests }
DeepLearningFromScratch1Chapter5 >> testChapter5_4_2 [
	| apple appleNum orange orandeNum tax mulAppleLayer mulOrangeLayer addAppleOrangeLayer mulTaxLayer applePrice orangePrice allPrice price dPrice r dAllPrice dTax dApplePrice dOrangePrice dOrange dOrangeNum dApple dAppleNum |
	apple := 100.
	appleNum := 2.
	orange := 150.
	orandeNum := 3.
	tax := 1.1.
	mulAppleLayer := MulLayer new.
	mulOrangeLayer := MulLayer new.
	addAppleOrangeLayer := AddLayer new.
	mulTaxLayer := MulLayer new.
	applePrice := mulAppleLayer forwardX: apple y: appleNum.
	orangePrice := mulOrangeLayer forwardX: orange y: orandeNum.
	allPrice := addAppleOrangeLayer forwardX: applePrice y: orangePrice.
	price := mulTaxLayer forwardX: allPrice y: tax.
	self assert: price closeTo: 715.
	dPrice := 1.
	r := mulTaxLayer backward: dPrice.
	dAllPrice := r first.
	dTax := r second.
	r := addAppleOrangeLayer backward: dAllPrice.
	dApplePrice := r first.
	dOrangePrice := r second.
	r := mulOrangeLayer backward: dOrangePrice.
	dOrange := r first.
	dOrangeNum := r second.
	r := mulAppleLayer backward: dApplePrice.
	dApple := r first.
	dAppleNum := r second.
	self assert: dAppleNum closeTo: 110.
	self assert: dApple closeTo: 2.2.
	self assert: dOrange closeTo: 3.3.
	self assert: dOrangeNum closeTo: 165.
	self assert: dTax closeTo: 650
]

{ #category : #tests }
DeepLearningFromScratch1Chapter5 >> testChapter5_5_1 [
	| x mask y |
	x := NDArray fromArray: #((1.0 -0.5) (-2.0 3.0)).
	mask := x <= 0.
	self assertCollection: mask array equals: #(false true true false).
	y := x copy.
	y at: mask put: 0.
	self assertCollection: y array equals: #(1.0 0 0 3.0) asFloatArray
]

{ #category : #tests }
DeepLearningFromScratch1Chapter5 >> testChapter5_6_1 [
	| x w b |
	x := NDRandom randomUniform: 2.
	w := NDRandom randomUniform: #(2 3).
	b := NDRandom randomUniform: 3.
	self assertCollection: x shape equals: #(2).
	self assertCollection: w shape equals: #(2 3).
	self assertCollection: b shape equals: #(3).
	^ (x dot: w) + b
]

{ #category : #tests }
DeepLearningFromScratch1Chapter5 >> testChapter5_6_2 [
	| xDotW b r dy db |
	xDotW := NDArray fromArray: #((0 0 0) (10 10 10)).
	b := NDArray fromArray: #(1 2 3).
	r := xDotW + b.
	self assertCollection: r array equals: #(1 2 3 11 12 13) asIntegerArray.
	self assertCollection: r shape equals: #(2 3).
	dy := NDArray fromArray: #((1 2 3) (4 5 6)).
	db := dy sumAxis: 1.
	self assertCollection: db array equals: #(5 7 9) asIntegerArray.
	self assertCollection: db shape equals: #(3)
]

{ #category : #tests }
DeepLearningFromScratch1Chapter5 >> testChapter5_7_3 [
	| mnist xTrain tTrain xBatch tBatch network gradNumerical gradBackProp |
	self timeLimit: 500 seconds.
	mnist := MNistData new.
	mnist
		normalize: true;
		oneHotLabel: true.
	xTrain := mnist trainingImages.
	tTrain := mnist trainingLabels.
	xBatch := xTrain copyFrom: 1 to: 3.
	tBatch := tTrain copyFrom: 1 to: 3.
	network := TwoLayerNet2 new
		inputSize: 784
		hiddenSize: 50
		outputSize: 10.
	gradBackProp := network gradient: xBatch t: tBatch.
	gradNumerical := network numericalGradient: xBatch t: tBatch.
	gradNumerical
		keysDo: [ :each | 
			self assert: ((gradBackProp at: each) - (gradNumerical at: each)) abs average < 0.0003.
			"self trace: each , ':'.
			self
				traceCr: ((gradBackProp at: each) - (gradNumerical at: each)) abs average" ]
]
