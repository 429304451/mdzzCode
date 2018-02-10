LOADED_PACKAGE = {}

if audio == nil then
    DEBUG = 0
    audio = require("cocos.framework.audio")
end

require("script.manager.GameManager")
GameManager:init()

require("util.util")
require("util.Extend")
-- require("script.util.ui")
json = require "cjson"
File = require("util.File")
scheduler = require("util.scheduler")
EventProtocol = require "util.EventProtocol"
GameEvent = require("Common.GameEvent"):create()
require("Common.define")
require("Common.define_kanpai")
require("Common.define_hundred")
require("Common.define_shuiguo")
require("Common.define_crazy")
-- PlayerData = require("Common.PlayerData"):create()