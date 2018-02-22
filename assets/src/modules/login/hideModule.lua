local hideModule = class("hideModule")
local SHOW_ALL = __Platform__ == 0
local DEBUG = false
local isconfigdownload = false
local config = [[
local config = {
	"Login.Btn_weChat",
	"SelectGame.groundNode._mainRoomItems.4",--看牌抢庄
	"SelectGame.groundNode._mainRoomItems.5",--看牌抢庄
	"SelectGame.groundNode._mainRoomItems.6",--看牌抢庄
	"SelectGame.groundNode._mainRoomItems.7",--看牌抢庄
	"SelectGame.btn_huodong",--活动
	"SelectGame.btn_renwu",--任务
	"SelectGame.btn_exchange",--兑换
	"SelectGame.btn_lucky",--抽奖系统
	"SelectGame.btn_firstCharge",--首充
	"SelectGame.btn_goldDraw",--活动
	"SelectGame.btn_mail",--邮件
	"SelectGame.btn_rank",--排行
	"SelectGame.btn_fortune",--招财
	"SelectGame.btn_hongbao",
	"Login.Btn_SwitchAccount",--手机
	--"Login.Btn_QuickStart",--快速
	"activityMain",
	"lotteryCharge",
	"loginWelfare",
	--"shareMain.pageItems.5.btn_copy", --复制分享链接
	--"shareMain.pageItems.5.btn_timeline",--朋友圈
	"resurreMole.pnl_mode_3",--充值复活
}

return config
]]

function hideModule:ctor()
	self._bBackData = false
	if SHOW_ALL then
		return
	elseif DEBUG or util.isExamine() then
        trace("lw DEBUG or util.isExamine()")
		self:onLoadConfig(config)
	else
		self:loadConfig()
		util.setTimeout(function() 
			if not self._bBackData then
				self:loadConfig()
			end
		end,1)
	end
end


function hideModule:loadConfig()
    if isconfigdownload then
        trace("lw Error  hideModule:loadConfig is download!!!")
        --return;
    end
    
	local path = sdkManager:getConfingPath()
	local url = "http://ndownload." .. util.curDomainName() .. "/channel/"..path.."/config.txt"
	trace("lw hideModule url =",url)
	util.webGet(url,function(res,str) 
		if res and str then
			self._bBackData = true
			self:onLoadConfig(str)
		else
			trace("hideModule:loadConfig fail url = ",url)
		end
	end)
end


function hideModule:onLoadConfig(str)
    trace(str)
	local tbl = loadstring(str)()
	if type(tbl) ~= "table" then
		trace("hideModule:onLoadConfig fail str = ",str)
		return
	end
	for i,keys in pairs(tbl) do
		keys = string.split(keys,".")

		local key1 = table.remove(keys,1)
		if ui[key1] and _uim.addHideMap then
			-- trace("hidemap ",tbl[i])
			_uim:addHideMap(ui[key1],keys)
		end
	end
    if isconfigdownload == false then
        local downloader = downLoadModule:create()
        downloader:downLoadVersions()
        isconfigdownload = true
    end
end


return hideModule