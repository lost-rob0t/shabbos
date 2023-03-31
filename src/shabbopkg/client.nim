import tables
import redis, redpool
import asyncdispatch
import sequtils
import uuids
type
  TaskState* = enum
    error,
    complete,
    queued,
    started
  Shabbos* = ref object
    host: string
    port: int
    password: string
    redis*: RedisPool
    id: string
    channels*: Table[string, seq[proc (name, message: string) {.async.}]]
    # channels are also queue names
proc newShabbos*(host: string, port: int, password: string = ""): Shabbos =
   result = Shabbos(host: host, port: port, password: password, id: $genUUID())

proc connect*(client: Shabbos) {.async.} =
  # TODO move pool options to init
  if client.password.len != 0:
    client.redis = await newRedisPool(size=1, maxConns=10, timeout=10.0, host=client.host,
                                                                   port=client.port, password=client.password)
    client.password = ""
  else:
    client.redis = await newRedisPool(size=1, maxConns=10, timeout=10.0, host= client.host, port = client.port)
