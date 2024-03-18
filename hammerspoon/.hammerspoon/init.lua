hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("ReloadConfiguration")
spoon.ReloadConfiguration:start()

spoon.SpoonInstall:andUse("RecursiveBinder")
spoon.RecursiveBinder.escapeKey = {{}, 'escape'}
singleKey = spoon.RecursiveBinder.singleKey;

require("appdynamo")
require("spacedynamo")
require("yabaister")
