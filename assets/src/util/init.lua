LOADED_PACKAGE = {}

if audio == nil then
    DEBUG = 0
    audio = require("cocos.framework.audio")
end

require("script.manager.GameManager")

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
Platefrom = require("Common.Platefrom"):create()
GameSocket = require("Common.GameSocket"):create(MSG_MAP,"gameSocket")
RoomSocket = require("Common.GameSocket"):create(MSG_ROOM_MAP,"roomSocket")
TemplateData = require("Common.TemplateData"):create()
PlayerData = require("Common.PlayerData"):create()
PlayerTaskData = require("Common.PlayerTaskData"):create()
R = require("Common.R"):create()

ExTimeLable = require("util.ExTimeLable")
ExTimeLoadBar = require("util.ExTimeLoadBar")

Alert = require("Common.Alert"):create()
Animation = require("Common.Animation"):create()
downLoadModule = require("Common.downLoadModule")

_gm:init()