Class {
	#name : #Chapter5Functions,
	#superclass : #Object,
	#category : #'NumPharo-Demo'
}

{ #category : #private }
Chapter5Functions >> crossEntropyErrorY: yy andT: tt [
	| yyy ttt batchSize tmp |
	yy ndim = 1
		ifTrue: [ ttt := tt
				reShape:
					{1.
					tt size}.
			yyy := yy
				reShape:
					{1.
					yy size} ]
		ifFalse: [ yyy := yy.
			ttt := tt ].
	ttt size = yyy size
		ifTrue: [ ttt := (ttt argMaxAxis: 2) - 1 ].
	batchSize := yyy shape first.
	tmp := (yyy
		at:
			{(1 to: batchSize) asArray.
			ttt array asArray + 1}).
	tmp := tmp + 1e-7.
	tmp := tmp ln.
	tmp := tmp sum negated / batchSize.
	^ tmp
]

{ #category : #private }
Chapter5Functions >> softMax: x [
	| a b c  |
	a := x maxAxis: -1.
	a := a reShape: (a shape copyWith: 1).
	a := x - a.
	b := a exp.
	c := b sumAxis: -1.
	c := c reShape: (c shape copyWith: 1).
	^ b / c
]
