# Usage
## Start Service on Pharo Playground
```smalltalk
q := LearningService new engine: CartPoleQ new.
q start.
```

## Start Python Client
```bash
$ python3 cartpole-client.py
```

## Stop Service
```smalltalk
q stop.
```

# Using pre-trained data
```smalltalk
pg := STON fromStream: (FileSystem workingDirectory / 'cartpole-pg.ston') readStream.
q := LearningService new engine: pg.
q start.
```
