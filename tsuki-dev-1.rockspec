package = "tsuki"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/kaleidosium/tsuki.git"
}
description = {
   detailed = [[
Tsuki is a project template to quickly set up LOVE2D to run Yuescript instead of Lua,
*without* precompiling your `.yue` files to `.lua`, forked from Selene by novafacing]],
   homepage = "https://github.com/kaleidosium/tsuki.git",
   license = "MIT"
}
dependencies = {
   "lua == 5.1",
   "busted >= 2.0.0",
   "yuescript >= 0.24.1",
   "luafilesystem >= 1.8.0",
   "argparse >= 0.7.1"
}
build = {
   type = "builtin",
   modules = {}
}
