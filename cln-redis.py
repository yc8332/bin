#!/usr/bin/python
import redis
try:
    r = redis.Redis(host='127.0.0.1',port=6379,db=0)
except Exception:
    r = redis.Redis(host='127.0.0.1',port=6379,db=0,password='io')
r.flushdb()
r.save()
