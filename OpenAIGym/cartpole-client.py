import json
import requests

remote_base = 'http://localhost:5001'
session = requests.Session()
session.headers.update({'Content-type': 'application/json'})
data = {'observations':4,'actions':2}
resp = session.post(remote_base+'/new/', data=json.dumps(data))

import gym
env = gym.make('CartPole-v0')
for i in range(1000):
    observation = env.reset()
    action = env.action_space.sample()
    for t in range(1000):
        env.render()
        observation, reward, done, info = env.step(action)
        #print(observation, reward, info)
        data = {'observation':observation.tolist(),'reward':reward,'done':done}
        resp = session.post(remote_base+'/action/', data=json.dumps(data))
        action = resp.json()
        #print(action)
        if done:
            print("Episode{} finished after {} timesteps".format(i, t+1))
            break
env.close()
