Class {
	#name : #DeepLearningFromScratch1Chapter4,
	#superclass : #TestCase,
	#category : #'NumPharo-Demo'
}

{ #category : #private }
DeepLearningFromScratch1Chapter4 >> crossEntropyErrorY: y andT: t [
	| delta |
	delta := 1.0e-7.
	^ (t * (y + delta) ln) sum negated
]

{ #category : #private }
DeepLearningFromScratch1Chapter4 >> function1: aNumber [
	^ 0.01 * (aNumber ** 2) + (0.1 * aNumber)
]

{ #category : #private }
DeepLearningFromScratch1Chapter4 >> function2: aNumber [
	^ (aNumber ** 2) sum
]

{ #category : #private }
DeepLearningFromScratch1Chapter4 >> functionTmp1: x0 [
	^ (x0 * x0) + (4 ** 2)
]

{ #category : #private }
DeepLearningFromScratch1Chapter4 >> functionTmp2: x0 [
	^ (x0 * x0) + (3 ** 2)
]

{ #category : #private }
DeepLearningFromScratch1Chapter4 >> meanSquaredErrorY: y andT: t [
	^ 0.5 * ((y - t) ** 2) sum
]

{ #category : #private }
DeepLearningFromScratch1Chapter4 >> numericalDiff: aBlock atX: aNumber [
	| h |
	h := 1e-4.
	^ ((aBlock cull: aNumber + h) - (aBlock cull: aNumber - h)) / (2 * h)
]

{ #category : #private }
DeepLearningFromScratch1Chapter4 >> numericalGradient: aBlock atX: aNumber [
	| h grad tmp fxh1 fxh2 |
	h := 1e-4.
	grad := NDArray zerosLike: aNumber.
	1 to: aNumber size do: [ :each | 
		tmp := aNumber at: each.
		aNumber at: each put: tmp + h.
		fxh1 := aBlock cull: aNumber.
		aNumber at: each put: tmp - h.
		fxh2 := aBlock cull: aNumber.
		grad at: each put: (fxh1 - fxh2) / (2 * h).
		aNumber at: each put: tmp ].
	^ grad
]

{ #category : #private }
DeepLearningFromScratch1Chapter4 >> tangentLine: aBlock atX: aNumber [
	| d y |
	d := self numericalDiff: aBlock atX: aNumber.
	y := (aBlock cull: aNumber) - (d * aNumber).
	^ [ :t | d * t + y ]
]

{ #category : #test }
DeepLearningFromScratch1Chapter4 >> testChapter4_2_1 [
	| t y r |
	t := #(0 0 1 0 0 0 0 0 0 0).
	y := #(0.1 0.05 0.6 0 0.05 0.1 0 0.1 0 0).
	r := self
		meanSquaredErrorY: (NDArray fromArray: y)
		andT: (NDArray fromArray: t).
	self assert: r closeTo: 0.0975.
	y := #(0.1 0.05 0.1 0 0.05 0.1 0 0.6 0 0).
	r := self
		meanSquaredErrorY: (NDArray fromArray: y)
		andT: (NDArray fromArray: t).
	self assert: r closeTo: 0.5975
]

{ #category : #test }
DeepLearningFromScratch1Chapter4 >> testChapter4_2_2 [
	| t y r |
	t := #(0 0 1 0 0 0 0 0 0 0).
	y := #(0.1 0.05 0.6 0 0.05 0.1 0 0.1 0 0).
	r := self
		crossEntropyErrorY: (NDArray fromArray: y)
		andT: (NDArray fromArray: t).
	self assert: r closeTo: 0.510825457009933802.
	y := #(0.1 0.05 0.1 0 0.05 0.1 0 0.6 0 0).
	r := self
		crossEntropyErrorY: (NDArray fromArray: y)
		andT: (NDArray fromArray: t).
	self assert: r closeTo: 2.3025840929945458
]

{ #category : #test }
DeepLearningFromScratch1Chapter4 >> testChapter4_2_3 [
	| mnist xTrain tTrain trainSize batchSize batchMask xBatch tBatch |
	mnist := MNistReader load.
	xTrain := mnist first first.
	tTrain := mnist first second.
	trainSize := xTrain shape at: 1.
	batchSize := 10.
	batchMask := NDArray randomChoice: batchSize from: trainSize.
	self assert: batchMask size equals: batchSize.
	xBatch := xTrain atAll: batchMask.
	tBatch := tTrain atAll: batchMask.
	self
		assertCollection: xBatch shape
		equals:
			{batchSize.
			28.
			28}.
	self assertCollection: tBatch shape equals: {batchSize}
]

{ #category : #test }
DeepLearningFromScratch1Chapter4 >> testChapter4_3_2 [
	| x y plt r tf y2 |
	x := NDArray arangeFrom: 0 to: 20 by: 0.1.
	y := self function1: x.
	plt := PharoPlot new.
	plt xLabel: 'x'.
	plt yLabel: 'f(x)'.
	plt plotX: x y: y label: 'y'.
	"plt show."
	r := self numericalDiff: [ :v | self function1: v ] atX: 5.
	self assert: r closeTo: 0.1999999999990898.
	r := self numericalDiff: [ :v | self function1: v ] atX: 10.
	self assert: r closeTo: 0.2999999999986347.
	tf := self tangentLine: [ :v | self function1: v ] atX: 5.
	y2 := tf cull: x.
	plt plotX: x y: y2 label: 'y2'.
	plt show
]

{ #category : #test }
DeepLearningFromScratch1Chapter4 >> testChapter4_3_3 [
	| r |
	r := self numericalDiff: [ :v | self functionTmp1: v ] atX: 3.0.
	self assert: r closeTo: 6.00000000000378.
	r := self numericalDiff: [ :v | self functionTmp2: v ] atX: 4.0.
	self assert: r closeTo: 7.99999999999119.
	r := self
		numericalGradient: [ :v | self function2: v ]
		atX: (NDArray fromArray: #(3 4) dtype: #Float).
	self assert: r array first closeTo: 5.993843.
	self assert: r array second closeTo: 8.001327.
	r := self
		numericalGradient: [ :v | self function2: v ]
		atX: (NDArray fromArray: #(0 2) dtype: #Float).
	self assert: r array first closeTo: 0.
	self assert: r array second closeTo: 3.99827.
	r := self
		numericalGradient: [ :v | self function2: v ]
		atX: (NDArray fromArray: #(3 0) dtype: #Float).
	self assert: r array first closeTo: 5.993843.
	self assert: r array second closeTo: 0
]