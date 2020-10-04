# NumPharo
NumPy like tools for Pharo Smalltalk.

![Build Status](https://api.travis-ci.com/EiichiroIto/NumPharo.svg?branch=main&status=unknown)

This is just personal project.

I bought the book "Deep Learning from Scratch" last year.

I would like to build Deep Learning System from Scratch using Pharo Smalltalk,
but the book uses NumPy and some tools, So I decide to implement NumPy like tools.

For now, I implemented some alternative tools like this:

- NumPy (NDArray)
- Matplotlib.pyplot (line graph, scatter graph, bar graph and image)

## Install repository on Pharo (for developer)

```
Metacello new
    baseline: 'NumPharo';
    repository: 'github://EiichiroIto/NumPharo/src';
    load.
```

## Demo & Tests
see PharoPlotSample class methods and DeepLearningFromScratch1Chapter classes.

```
PharoPlotSample example1.
```
