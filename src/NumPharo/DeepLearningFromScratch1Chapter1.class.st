Class {
	#name : #DeepLearningFromScratch1Chapter1,
	#superclass : #TestCase,
	#category : #'NumPharo-Demo'
}

{ #category : #private }
DeepLearningFromScratch1Chapter1 class >> checkLenaImageAndDownload [
	"self checkLenaImageAndDownload"
	| fr |
	fr := FileSystem workingDirectory / self lenaFilename.
	fr isFile
		ifTrue: [ ^ self ].
	(ZnClient new url: self lenaImageURL) downloadTo: self lenaFilename.
	fr isFile
		ifFalse: [ self error ]
]

{ #category : #private }
DeepLearningFromScratch1Chapter1 class >> lenaFilename [
	^ 'lena.bmp'
]

{ #category : #api }
DeepLearningFromScratch1Chapter1 class >> lenaImage [
	"self lenaImage asMorph openInWorld"
	self checkLenaImageAndDownload.
	^ BMPReadWriter formFromFileNamed: self lenaFilename
]

{ #category : #private }
DeepLearningFromScratch1Chapter1 class >> lenaImageURL [
	^ 'http://www.ess.ic.kanagawa-it.ac.jp/std_img/colorimage/lena_std.bmp'
]

{ #category : #test }
DeepLearningFromScratch1Chapter1 >> testChapter1_5_3 [
	| x y z |
	x := NDArray fromArray: #(1 2 3) dtype: #Float.
	y := NDArray fromArray: #(2 4 6).
	z := x + y.
	self assertCollection: z array equals: #(3 6 9) asFloatArray.
	self assertCollection: z shape equals: #(3).
	self assert: z dtype equals: #Float.
	z := x - y.
	self assertCollection: z array equals: #(-1 -2 -3) asFloatArray.
	self assertCollection: z shape equals: #(3).
	self assert: z dtype equals: #Float.
	z := x * y.
	self assertCollection: z array equals: #(2 8 18) asFloatArray.
	self assertCollection: z shape equals: #(3).
	self assert: z dtype equals: #Float.
	z := x / y.
	self assertCollection: z array equals: #(0.5 0.5 0.5) asFloatArray.
	self assertCollection: z shape equals: #(3).
	self assert: z dtype equals: #Float.
	z := x / 2.
	self assertCollection: z array equals: #(0.5 1 1.5) asFloatArray.
	self assertCollection: z shape equals: #(3).
	self assert: z dtype equals: #Float
]

{ #category : #test }
DeepLearningFromScratch1Chapter1 >> testChapter1_5_4 [
	| a b c |
	a := NDArray fromArray: #((1 2) (3 4)) dtype: #Integer.
	self assertCollection: a shape equals: #(2 2).
	self assert: a dtype equals: #Integer.
	b := NDArray fromArray: #((3 0) (0 6)) dtype: #Integer.
	c := a + b.
	self assertCollection: c array equals: #(4 2 3 10) asIntegerArray.
	self assertCollection: c shape equals: #(2 2).
	self assert: a dtype equals: #Integer.
	c := a * b.
	self assertCollection: c array equals: #(3 0 0 24) asIntegerArray.
	self assertCollection: c shape equals: #(2 2).
	self assert: a dtype equals: #Integer.
	c := a * 10.
	self assertCollection: c array equals: #(10 20 30 40) asIntegerArray.
	self assertCollection: c shape equals: #(2 2).
	self assert: a dtype equals: #Integer
]

{ #category : #test }
DeepLearningFromScratch1Chapter1 >> testChapter1_5_5 [
	| a b c |
	a := NDArray fromArray: #((1 2) (3 4)) dtype: #Integer.
	b := NDArray fromArray: #(10 20) dtype: #Integer.
	c := a * b.
	self assertCollection: c array equals: #(10 40 30 80) asIntegerArray.
	self assertCollection: c shape equals: #(2 2)
]

{ #category : #test }
DeepLearningFromScratch1Chapter1 >> testChapter1_5_6 [
	| x r |
	x := NDArray fromArray: #(#(51 55) #(14 19) #(0 4)).
	r := x at: 1.
	self assertCollection: r array equals: #(51 55) asIntegerArray.
	self assertCollection: r shape equals: #(2).
	self assert: r dtype equals: #Integer.
	r := x at: (Array with: 1 with: 2).
	self assert: r equals: 55.
	x := x flatten.
	self
		assertCollection: x array
		equals: #(51 55 14 19 0 4) asIntegerArray.
	self assertCollection: x shape equals: #(6).
	self assert: x dtype equals: #Integer.
	r := x at: (Array with: 1 with: 3 with: 5) asNDArray.
	self assertCollection: r array equals: #(51 14 0) asIntegerArray.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Integer.
	r := x > 15.
	self
		assertCollection: r array
		equals: #(true true false true false false).
	self assertCollection: r shape equals: #(6).
	self assert: r dtype equals: #Boolean.
	r := x at: x > 15.
	self assertCollection: r array equals: #(51 55 19) asIntegerArray.
	self assertCollection: r shape equals: #(3).
	self assert: r dtype equals: #Integer
]

{ #category : #test }
DeepLearningFromScratch1Chapter1 >> testChapter1_6_1 [
	| x y plt |
	x := NDArray arangeFrom: 0 to: 6 by: 0.1.
	y := x sin.
	plt := PharoPlot new.
	plt plotX: x y: y label: ''.
	plt show
]

{ #category : #test }
DeepLearningFromScratch1Chapter1 >> testChapter1_6_2 [
	| x y1 y2 plt |
	x := NDArray arangeFrom: 0 to: 6 by: 0.1.
	y1 := x sin.
	y2 := x cos.
	plt := PharoPlot new.
	plt plotX: x y: y1 label: 'sin'.
	plt plotX: x y: y2 label: 'cos'.
	plt xLabel: 'x'.
	plt yLabel: 'y'.
	plt title: 'sin & cos'.
	plt showLegend: true.
	plt show
]

{ #category : #test }
DeepLearningFromScratch1Chapter1 >> testChapter1_6_3 [
	| img plt |
	img := self class lenaImage.
	plt := PharoPlot new.
	plt image: img.
	plt show
]
