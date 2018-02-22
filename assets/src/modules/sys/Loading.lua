local Loading = class("Loading",function()
	return ui.createCsb(ui.Loading).root
end)

--3秒后自动消失
local MAX_LOADING_TIME = 3

function Loading.create(...)
    local node = Loading.new(...)
    return node
end

function Loading:ctor(targetMsg)
	util.aptNotScale(self.node_msg)
	util.aptNotScale(self.img_loadingBgSmall)
	if targetMsg then
		self:setTarMsg(targetMsg)
	end
	self:addActions()
end

function Loading:setTarMsg(targetMsg)
	self.manID = targetMsg[2]
	self.assID = targetMsg[3]
	self.socket = targetMsg[1]
	if type(self.socket) == "string" then
		self.socket = _G[self.socket]
		if self.socket == nil then
			trace("error:Loading socket is ",targetMsg[1])
			self:close()
		end
	end
	if self.socket then
		self.socket:addDataHandler(self.manID,self.assID,self,self.close)
	end
	if targetMsg.msg then
    	self.lbl_tips:setString(targetMsg.msg)
    	--local width = util.fixLaberWidth(self.lbl_tips,true) + 100
    	--self.img_bg:setContentSize(cc.size(width,self.img_bg:getContentSize().height))
		self.node_msg:setVisible(true)
		self.img_loadingBgSmall:setVisible(false)
	else
		self.img_loadingBgSmall:setVisible(true)
	end
	local waitTime = self.manID and MAX_LOADING_TIME or 300
	util.delayCall(self,
		function()
			if not targetMsg.msg then
				trace("上条消息没收到回包",self.manID,self.assID)
				self.socket:checkConnect("上条消息没收到回包")
			end
			util.delayCall(self,function()
				self:close()
			end)
		end,
		waitTime
	)
end

function Loading:addEvents()
	GameEvent:addEventListener(GameEvent.hideLoading,self,self.close)
end

function Loading:addActions()
	local actionrotate = cc.RotateBy:create(2,360)
	local actionrep = cc.RepeatForever:create(actionrotate)
	self.sp_loading:runAction(actionrep)
	--self.sp_loading = Animation:createLoing(self.sp_loading)
end

function Loading:close()
	if not tolua.isnull(self) then
		util.popWin({self})
	end
end


return Loading