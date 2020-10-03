Class {
	#name : #DeepLearningFromScratch1Chapter2,
	#superclass : #TestCase,
	#category : #'NumPharo-Demo'
}

{ #category : #private }
DeepLearningFromScratch1Chapter2 >> and231X1: x1 x2: x2 [
	| w1 w2 theta tmp |
	w1 := 0.5.
	w2 := 0.5.
	theta := 0.7.
	tmp := x1 * w1 + (x2 * w2).
	^ tmp <= theta
		ifTrue: [ 0 ]
		ifFalse: [ 1 ]
]

{ #category : #private }
DeepLearningFromScratch1Chapter2 >> and233X1: x1 x2: x2 [
	| x w b tmp |
	x := NDArray fromArray: (Array with: x1 with: x2).
	w := NDArray fromArray: #(0.5 0.5).
	b := -0.7.
	tmp := (w * x) sum + b.
	^ tmp <= 0
		ifTrue: [ 0 ]
		ifFalse: [ 1 ]
]

{ #category : #private }
DeepLearningFromScratch1Chapter2 >> nand233X1: x1 x2: x2 [
	| x w b tmp |
	x := NDArray fromArray: (Array with: x1 with: x2).
	w := NDArray fromArray: #(-0.5 -0.5).
	b := 0.7.
	tmp := (w * x) sum + b.
	^ tmp <= 0
		ifTrue: [ 0 ]
		ifFalse: [ 1 ]
]

{ #category : #private }
DeepLearningFromScratch1Chapter2 >> or233X1: x1 x2: x2 [
	| x w b tmp |
	x := NDArray fromArray: (Array with: x1 with: x2).
	w := NDArray fromArray: #(0.5 0.5).
	b := -0.2.
	tmp := (w * x) sum + b.
	^ tmp <= 0
		ifTrue: [ 0 ]
		ifFalse: [ 1 ]
]

{ #category : #private }
DeepLearningFromScratch1Chapter2 >> testChapter2_3_1 [
	self assert: (self and231X1: 0 x2: 0) equals: 0.
	self assert: (self and231X1: 1 x2: 0) equals: 0.
	self assert: (self and231X1: 0 x2: 1) equals: 0.
	self assert: (self and231X1: 1 x2: 1) equals: 1
]

{ #category : #private }
DeepLearningFromScratch1Chapter2 >> testChapter2_3_2 [
	| x w b r |
	x := NDArray fromArray: #(0 1).
	w := NDArray fromArray: #(0.5 0.5).
	b := -0.7.
	r := w * x.
	self assertCollection: r array equals: #(0 0.5) asFloatArray.
	self assertCollection: r shape equals: #(2).
	self assert: r dtype equals: #Float.
	r := (w * x) sum.
	self assert: r equals: 0.5.
	r := (w * x) sum + b.
	self assert: r closeTo: -0.2
]

{ #category : #private }
DeepLearningFromScratch1Chapter2 >> testChapter2_3_3 [
	self assert: (self and233X1: 0 x2: 0) equals: 0.
	self assert: (self and233X1: 1 x2: 0) equals: 0.
	self assert: (self and233X1: 0 x2: 1) equals: 0.
	self assert: (self and233X1: 1 x2: 1) equals: 1.
	self assert: (self nand233X1: 0 x2: 0) equals: 1.
	self assert: (self nand233X1: 1 x2: 0) equals: 1.
	self assert: (self nand233X1: 0 x2: 1) equals: 1.
	self assert: (self nand233X1: 1 x2: 1) equals: 0.
	self assert: (self or233X1: 0 x2: 0) equals: 0.
	self assert: (self or233X1: 1 x2: 0) equals: 1.
	self assert: (self or233X1: 0 x2: 1) equals: 1.
	self assert: (self or233X1: 1 x2: 1) equals: 1
]

{ #category : #private }
DeepLearningFromScratch1Chapter2 >> testChapter2_3_4 [
	self assert: (self xor252X1: 0 x2: 0) equals: 0.
	self assert: (self xor252X1: 1 x2: 0) equals: 1.
	self assert: (self xor252X1: 0 x2: 1) equals: 1.
	self assert: (self xor252X1: 1 x2: 1) equals: 0
]

{ #category : #private }
DeepLearningFromScratch1Chapter2 >> xor252X1: x1 x2: x2 [
	| s1 s2 y |
	s1 := self nand233X1: x1 x2: x2.
	s2 := self or233X1: x1 x2: x2.
	y := self and233X1: s1 x2: s2.
	^ y
]
