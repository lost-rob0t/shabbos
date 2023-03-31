# Package

version       = "0.1.0"
author        = "nsaspy"
description   = "Load Star intel tasks from the couchdb and methods for bots to receive tasks"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["shabbo"]


# Dependencies

requires "nim >= 1.6.12"
requires "redis"
requires "redpool"
