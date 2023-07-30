# Package

version       = "0.1.0"
author        = "srozb"
description   = "gptcli"
license       = "MIT"
srcDir        = "src"
bin           = @["gptcli"]


# Dependencies

requires "nim >= 1.6.8, pyopenai == 0.1.1, cligen"
