import tables
import redis, redpool
import asyncdispatch
import sequtils
import uuids
import client
# Pub/Sub lib for bots in star intel
# TODO rate limiting?
# For perodic commands maybe a hash table of "task" objects, then a function to loop over it and check if its ready,
# if time >= runStart run it

proc publish*(client: Shabbos, channel: string, message: string)  {.async.} =
  ## Publish a MESSAGE to CHANNEL
  client.redis.withAcquire(server):
    discard await server.publish(channel, message)

proc sub*(client: Shabbos) {.async.} =
  ## Subscribe to messages from client channels
  client.redis.withAcquire(server):
    for channel in client.channels.keys:
      await server.subscribe(channel)


proc start*(client: Shabbos) {.async.} =
  await client.sub
  client.redis.withAcquire(server):
    while true:
      for key in client.channels.keys:
        let rmessage = await server.nextMessage()
        for callback in client.channels[key]:
          await callback(key, rmessage.message)

