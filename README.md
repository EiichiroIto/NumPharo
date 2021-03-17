# NumPharo
NumPy like tools for Pharo Smalltalk.

![Build Status](https://api.travis-ci.com/EiichiroIto/NumPharo.svg?branch=main&status=unknown)

This is just my personal project.

I bought the book "Deep Learning from Scratch" last year.

I would like to build Deep Learning System from Scratch using Pharo Smalltalk,
but the book uses NumPy and some tools, So I decide to implement NumPy like tools.

For now, I implemented some alternative tools like this:

- NumPy (NDArray)
- Matplotlib.pyplot (line graph, scatter graph, bar graph and image)

## Install repository on Pharo (for developer)

```smalltalk
Metacello new
    baseline: 'NumPharo';
    repository: 'github://EiichiroIto/NumPharo:main/src';
    load.
```

## Demo & Tests
see PharoPlotSample class methods and DeepLearningFromScratch1Chapter classes.

```smalltalk
example1
  | x y plt |
  x := NDArray arangeFrom: 0 to: 6 by: 0.1.
  y := x sin.
  plt := PharoPlot new.
  plt extent: 500 @ 200.
  plt plotX: x y: y label: 'sin'.
  plt plotX: x y: x cos label: 'cos'.
  plt title: 'sin & cos'.
  plt xLabel: 'x'.
  plt yLabel: 'y'.
  plt showLegend: true.
  plt show.
  ^ plt
```

![Example1](https://raw.githubusercontent.com/EiichiroIto/NumPharo/main/images/example1.png)

