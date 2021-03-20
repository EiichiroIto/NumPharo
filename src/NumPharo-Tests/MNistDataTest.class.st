"
A MNistDataTest is a test class for testing the behavior of MNistData
"
Class {
	#name : #MNistDataTest,
	#superclass : #TestCase,
	#category : #'NumPharo-Tests'
}

{ #category : #private }
MNistDataTest >> newData [
	^ MNistData new
]

{ #category : #test }
MNistDataTest >> testConvertImageData [
	| d a r |
	d := self newData.
	a := {#(3 28 28).
	(ByteArray new: 3 * 28 * 28)}.
	r := d convertImageData: a.
	self assertCollection: r shape equals: #(3 28 28).
	self assert: r array size equals: 3 * 28 * 28.
	self assert: r array class equals: ByteArray.
	d normalize: true.
	r := d convertImageData: a.
	self assertCollection: r shape equals: #(3 28 28).
	self assert: r array size equals: 3 * 28 * 28.
	self assert: r array class equals: FloatArray.
	d flatten: true.
	r := d convertImageData: a.
	self assertCollection: r shape equals: #(3 784).
	self assert: r array size equals: 3 * 28 * 28.
	self assert: r array class equals: FloatArray
]

{ #category : #test }
MNistDataTest >> testConvertLabelData [
	| d r |
	d := self newData.
	r := d convertLabelData: #[1 2 3].
	self assertCollection: r array equals: #[2 3 4].
	self assertCollection: r shape equals: #(3).
	d oneHotLabel: true.
	r := d convertLabelData: #[1 2 3].
	self
		assertCollection: r array
		equals: #[0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0].
	self assertCollection: r shape equals: #(3 10)
]

{ #category : #test }
MNistDataTest >> testFlatten [
	| d |
	d := self newData.
	self deny: d flatten.
	d flatten: true.
	self assert: d flatten.
	d flatten: false.
	self deny: d flatten
]

{ #category : #test }
MNistDataTest >> testImages [
	| d |
	d := self newData.
	self assert: d images isNil.
	d images: #(1 2 3).
	self assertCollection: d images equals: #(1 2 3)
]

{ #category : #test }
MNistDataTest >> testIsReady [
	| d |
	d := self newData.
	self deny: d isReady.
	d images: #(1 2 3).
	self deny: d isReady.
	d labels: #(4 5 6).
	self assert: d isReady
]

{ #category : #test }
MNistDataTest >> testLabels [
	| d |
	d := self newData.
	self assert: d labels isNil.
	d labels: #(1 2 3).
	self assertCollection: d labels equals: #(1 2 3)
]

{ #category : #test }
MNistDataTest >> testNormalize [
	| d |
	d := self newData.
	self deny: d normalize.
	d normalize: true.
	self assert: d normalize.
	d normalize: false.
	self deny: d normalize
]

{ #category : #test }
MNistDataTest >> testOneHotLabel [
	| d |
	d := self newData.
	self deny: d oneHotLabel.
	d oneHotLabel: true.
	self assert: d oneHotLabel.
	d oneHotLabel: false.
	self deny: d oneHotLabel
]

{ #category : #test }
MNistDataTest >> testTestingImages [
	| d r |
	d := self newData.
	r := d testingImages.
	self assertCollection: r shape equals: #(10000 28 28).
	self assert: r array size equals: 10000 * 28 * 28
]

{ #category : #test }
MNistDataTest >> testTestingLabels [
	| d r |
	d := self newData.
	d oneHotLabel: true.
	r := d testingLabels.
	self assertCollection: r shape equals: #(10000 10).
	self assert: r array size equals: 10000 * 10
]

{ #category : #test }
MNistDataTest >> testTrainingImages [
	| d r |
	d := self newData.
	d flatten: true.
	r := d trainingImages.
	self assertCollection: r shape equals: #(60000 784).
	self assert: r array size equals: 60000 * 28 * 28
]

{ #category : #test }
MNistDataTest >> testTrainingLabels [
	| d r |
	d := self newData.
	r := d trainingLabels.
	self assertCollection: r shape equals: #(60000).
	self assert: r array size equals: 60000
]

{ #category : #test }
MNistDataTest >> testWriteOneHotDataToAt [
	| d array |
	d := self newData.
	array := Array new: 10.
	d writeOneHotData: 0 to: array at: 1.
	self assertCollection: array equals: #(1 0 0 0 0 0 0 0 0 0).
	array := Array new: 10.
	d writeOneHotData: 1 to: array at: 1.
	self assertCollection: array equals: #(0 1 0 0 0 0 0 0 0 0).
	array := Array new: 10.
	d writeOneHotData: 5 to: array at: 1.
	self assertCollection: array equals: #(0 0 0 0 0 1 0 0 0 0).
	array := Array new: 10.
	d writeOneHotData: 9 to: array at: 1.
	self assertCollection: array equals: #(0 0 0 0 0 0 0 0 0 1)
]
