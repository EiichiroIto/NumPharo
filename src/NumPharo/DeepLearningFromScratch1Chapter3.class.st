Class {
	#name : #DeepLearningFromScratch1Chapter3,
	#superclass : #TestCase,
	#category : #'NumPharo-Demo'
}

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> checkFileNamed: aString1 ifNotDownloadFrom: aString2 [
	| fr fn |
	fr := FileSystem workingDirectory / aString1.
	fr isFile
		ifTrue: [ ^ fr ].
	fn := aString1 , '.gz'.
	(ZnClient new url: aString2) downloadTo: fn.
	GZipReadStream unzip: fn.
	fr isFile
		ifFalse: [ self error ].
	(FileSystem workingDirectory / fn) delete.
	^ fr
]

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> forward343: network x: x [
	| w1 w2 w3 b1 b2 b3 a1 a2 a3 z1 z2 y |
	w1 := network at: #W1.
	w2 := network at: #W2.
	w3 := network at: #W3.
	b1 := network at: #b1.
	b2 := network at: #b2.
	b3 := network at: #b3.
	a1 := (x dot: w1) + b1.
	z1 := self sigmoid324: a1.
	a2 := (z1 dot: w2) + b2.
	z2 := self sigmoid324: a2.
	a3 := (z2 dot: w3) + b3.
	y := self identity342: a3.
	^ y
]

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> identity342: x [
	^ x
]

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> initNetwork343 [
	| network |
	network := Dictionary new.
	network
		at: #W1
		put: (NDArray fromArray: #(#(0.1 0.3 0.5) #(0.2 0.4 0.6))).
	network at: #b1 put: (NDArray fromArray: #(0.1 0.2 0.3)).
	network
		at: #W2
		put: (NDArray fromArray: #(#(0.1 0.4) #(0.2 0.5) #(0.3 0.6))).
	network at: #b2 put: (NDArray fromArray: #(0.1 0.2)).
	network at: #W3 put: (NDArray fromArray: #(#(0.1 0.3) #(0.2 0.4))).
	network at: #b3 put: (NDArray fromArray: #(0.1 0.2)).
	^ network
]

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> initNetwork362 [
	| fr |
	fr := self
		checkFileNamed: 'sample_weight.ston'
		ifNotDownloadFrom: self sampleWeightURL.
	^ STON fromStream: fr readStream
]

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> predict362: network x: x [
	| w1 w2 w3 b1 b2 b3 a1 a2 a3 z1 z2 |
	w1 := network at: #W1.
	w2 := network at: #W2.
	w3 := network at: #W3.
	b1 := network at: #b1.
	b2 := network at: #b2.
	b3 := network at: #b3.
	a1 := (x dot: w1) + b1.
	z1 := self sigmoid324: a1.
	a2 := (z1 dot: w2) + b2.
	z2 := self sigmoid324: a2.
	a3 := (z2 dot: w3) + b3.
	^ self softmax352: a3
]

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> relu327: x [
	^ x maximum: 0
]

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> sampleWeightURL [
	^ 'https://github.com/EiichiroIto/NumPharo/raw/main/DLFS/sample_weight.ston.gz'
]

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> sigmoid324: x [
	^ 1 / (1 + x negated exp)
]

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> softmax352: a [
	| c exp sum |
	c := a max.
	exp := (a - c) exp.
	sum := exp sum.
	^ exp / sum
]

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> step322: x [
	| y |
	y := x > 0.
	^ y withDtype: #Integer
]

{ #category : #private }
DeepLearningFromScratch1Chapter3 >> step323: x [
	^ x > 0 withDtype: #Integer
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_2_2 [
	| x y |
	x := NDArray fromArray: #(-1 1 2) dtype: #Float.
	self assertCollection: x array equals: #(-1 1 2) asFloatArray.
	self assertCollection: x shape equals: #(3).
	self assert: x dtype equals: #Float.
	y := self step322: x.
	self assertCollection: y array equals: #(0 1 1) asIntegerArray.
	self assertCollection: y shape equals: #(3).
	self assert: y dtype equals: #Integer
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_2_3 [
	| x y plt |
	x := NDArray arangeFrom: -5 to: 5 by: 0.1.
	y := self step322: x.
	plt := PharoPlot new.
	plt plotX: x y: y label: 'Chapter 3.2.3'.
	plt yLimitFrom: -0.1 to: 1.1.
	plt show
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_2_4 [
	| x y plt |
	x := NDArray fromArray: #(-1 1 2) dtype: #Float.
	y := self sigmoid324: x.
	self assert: y array first closeTo: 0.26894142.
	self assert: y array second closeTo: 0.73105858.
	self assert: y array third closeTo: 0.88079708.
	x := NDArray arangeFrom: -5 to: 5 by: 0.1.
	y := self sigmoid324: x.
	plt := PharoPlot new.
	plt plotX: x y: y label: 'Chapter 3.2.4'.
	plt yLimitFrom: -0.1 to: 1.1.
	plt show
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_2_5 [
	| x y1 y2 plt |
	x := NDArray arangeFrom: -5 to: 5 by: 0.1.
	y1 := self step322: x.
	y2 := self sigmoid324: x.
	plt := PharoPlot new.
	plt extent: 300 @ 200.
	plt plotX: x y: y1 label: 'step function'.
	plt plotX: x y: y2 label: 'sigmoid'.
	plt yLimitFrom: -0.1 to: 1.1.
	plt show
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_2_6 [
	| x y plt |
	x := NDArray arangeFrom: -5 to: 5 by: 0.1.
	y := self relu327: x.
	plt := PharoPlot new.
	plt extent: 300 @ 200.
	plt plotX: x y: y label: ''.
	plt yLimitFrom: -1 to: 5.
	plt show
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_3_1 [
	| a b |
	a := NDArray fromArray: #(1 2 3 4).
	self assert: a ndim equals: 1.
	self assertCollection: a shape equals: #(4).
	self assertCollection: a array equals: #(1 2 3 4) asIntegerArray.
	b := NDArray fromArray: #((1 2) (3 4) (5 6)).
	self assert: b ndim equals: 2.
	self assertCollection: b shape equals: #(3 2).
	self assertCollection: b array equals: #(1 2 3 4 5 6) asIntegerArray
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_3_2 [
	| a b c r |
	a := NDArray fromArray: #((1 2) (3 4)) dtype: #Float.
	self assertCollection: a shape equals: #(2 2).
	b := NDArray fromArray: #((5 6) (7 8)) dtype: #Float.
	self assertCollection: b shape equals: #(2 2).
	r := a dot: b.
	self assertCollection: r array equals: #(19 22 43 50) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	a := NDArray fromArray: #((1 2 3) (4 5 6)) dtype: #Float.
	self assertCollection: a shape equals: #(2 3).
	b := NDArray fromArray: #((1 2) (3 4) (5 6)).
	self assertCollection: b shape equals: #(3 2).
	r := a dot: b.
	self assertCollection: r array equals: #(22 28 49 64) asFloatArray.
	self assertCollection: r shape equals: #(2 2).
	c := NDArray fromArray: #((1 2) (3 4)).
	self assertCollection: c shape equals: #(2 2).
	self should: [ a dot: c ] raise: Error.
	a := NDArray fromArray: #((1 2) (3 4) (5 6)).
	self assertCollection: a shape equals: #(3 2).
	b := NDArray fromArray: #(7 8).
	self assertCollection: b shape equals: #(2).
	r := a dot: b.
	self assertCollection: r array equals: #(23 53 83) asIntegerArray.
	self assertCollection: r shape equals: #(3)
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_3_3 [
	| x w y |
	x := NDArray fromArray: #(1 2).
	self assertCollection: x shape equals: #(2).
	w := NDArray fromArray: #((1 3 5) (2 4 6)).
	self assertCollection: w shape equals: #(2 3).
	y := x dot: w.
	self assertCollection: y array equals: #(5 11 17) asIntegerArray
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_4_2 [
	| x w1 b1 a1 z1 w2 b2 a2 z2 w3 b3 a3 y |
	x := NDArray fromArray: #(1 0.5).
	w1 := NDArray fromArray: #(#(0.1 0.3 0.5) #(0.2 0.4 0.6)).
	b1 := NDArray fromArray: #(0.1 0.2 0.3).
	self assertCollection: w1 shape equals: #(2 3).
	self assertCollection: x shape equals: #(2).
	self assertCollection: b1 shape equals: #(3).
	a1 := (x dot: w1) + b1.
	self assertCollection: a1 array equals: #(0.3 0.7 1.1) asFloatArray.
	z1 := self sigmoid324: a1.
	self assert: z1 array first closeTo: 0.57444252.
	self assert: z1 array second closeTo: 0.66818777.
	self assert: z1 array third closeTo: 0.75026011.
	w2 := NDArray fromArray: #(#(0.1 0.4) #(0.2 0.5) #(0.3 0.6)).
	b2 := NDArray fromArray: #(0.1 0.2).
	self assertCollection: z1 shape equals: #(3).
	self assertCollection: w2 shape equals: #(3 2).
	self assertCollection: b2 shape equals: #(2).
	a2 := (z1 dot: w2) + b2.
	z2 := self sigmoid324: a2.
	w3 := NDArray fromArray: #(#(0.1 0.3) #(0.2 0.4)).
	b3 := NDArray fromArray: #(0.1 0.2).
	a3 := (z2 dot: w3) + b3.
	y := self identity342: a3.
	^ y
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_4_3 [
	| network x y |
	network := self initNetwork343.
	x := NDArray fromArray: #(1.0 0.5).
	y := self forward343: network x: x.
	self assert: y array first closeTo: 0.31682708.
	self assert: y array second closeTo: 0.69627909
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_5_1 [
	| a expA sum y |
	a := NDArray fromArray: #(0.3 2.9 4.0).
	expA := a exp.
	self assert: expA array first closeTo: 1.34985881.
	self assert: expA array second closeTo: 18.17414537.
	self assert: expA array third closeTo: 54.59815003.
	sum := expA sum.
	self assert: sum closeTo: 74.1221542102.
	y := expA / sum.
	self assert: y array first closeTo: 0.01821127.
	self assert: y array second closeTo: 0.24519181.
	self assert: y array third closeTo: 0.73659691
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_5_3 [
	| a y |
	a := NDArray fromArray: #(0.3 2.9 4.0).
	y := self softmax352: a.
	self assert: y array first closeTo: 0.01821127.
	self assert: y array second closeTo: 0.24519181.
	self assert: y array third closeTo: 0.73659601.
	self assert: y sum closeTo: 1
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_6_1 [
	| mnist xTrain tTrain xTest tTest |
	mnist := MNistData new.
	mnist flatten: true.
	xTrain := mnist trainingImages.
	tTrain := mnist trainingLabels.
	xTest := mnist testingImages.
	tTest := mnist testingLabels.
	self assertCollection: xTrain shape equals: #(60000 784).
	self assertCollection: tTrain shape equals: #(60000).
	self assertCollection: xTest shape equals: #(10000 784).
	self assertCollection: tTest shape equals: #(10000)
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_6_1b [
	| mnist xTrain tTrain img label plt |
	mnist := MNistData new.
	mnist flatten: true.
	xTrain := mnist trainingImages.
	tTrain := mnist trainingLabels.
	img := xTrain at: 1.
	label := tTrain at: 1.
	self assert: label equals: 6.
	img := img withShape: #(28 28).
	plt := PharoPlot new.
	plt image: img asForm.
	plt show
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_6_2 [
	| data network x t accuracyCount |
	data := MNistData new flatten: true; normalize: true; yourself.
	x := data testingImages.
	t := data testingLabels.
	network := self initNetwork362.
	accuracyCount := 0.
	1 to: 100 do: [ :index | 
		| y p |
		y := self predict362: network x: (x at: index).
		p := y argMax.
		(p = (t at: index))
			ifTrue: [ accuracyCount := accuracyCount + 1 ] ].
	self assert: accuracyCount >= 95.
	self inform: 'Accuracy: ', ((accuracyCount / 100) asFloat asString)
]

{ #category : #test }
DeepLearningFromScratch1Chapter3 >> testChapter3_6_3 [
	| data x network w1 w2 w3 t batchSize accuracyCount xBatch yBatch tBatch p |
	self timeLimit: 300 seconds.
	data := MNistData new flatten: true; normalize: true; yourself.
	x := data testingImages.
	network := self initNetwork362.
	w1 := network at: #W1.
	w2 := network at: #W2.
	w3 := network at: #W3.
	self assertCollection: x shape equals: #(10000 784).
	self assertCollection: (x at: 1) shape equals: #(784).
	self assertCollection: w1 shape equals: #(784 50).
	self assertCollection: w2 shape equals: #(50 100).
	self assertCollection: w3 shape equals: #(100 10).
	t := data testingLabels.
	batchSize := 100.
	accuracyCount := 0.
	(1 to: x len by: batchSize)
		do: [ :each | 
			xBatch := x copyFrom: each to: each + batchSize - 1.
			yBatch := self predict362: network x: xBatch.
			p := yBatch argMaxAxis: 2.
			tBatch := t copyFrom: each to: each + batchSize - 1.
			accuracyCount := accuracyCount + (p = tBatch) sum ].
	self assert: (accuracyCount / x len) asFloat closeTo: 0.9352
]
