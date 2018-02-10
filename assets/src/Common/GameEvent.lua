local GameEvent = class("GameEvent")

function GameEvent.create()
	return GameEvent.new()
end

function GameEvent:ctor()
	EventProtocol.extend(self)
	self.newState = {}
end


function GameEvent:notifyView( name ,data,isNew)
	if isNew then 
		self:setState(name)
	end
	self:dispatchEvent({name=name,data=data})
end

--读取状态
function GameEvent:readState( name )
	self.newState[name] = nil
	self:notifyView(name, nil, false)
end

--获取状态
function GameEvent:getState( name )
	return self.newState[name] and self.newState[name] == true
end

--设置状态
function GameEvent:setState( name )
	self.newState[name] = true
end

--界面消息传递事件

GameEvent.updateVersion = "updateVersion"
GameEvent.showLoading = "showLoading"
GameEvent.hideLoading = "hideLoading"
GameEvent.RecAllMsg = "RecAllMsg"
GameEvent.updatePlayer = "updatePlayer"
GameEvent.updateMatchInfo = "updateMatchInfo"
GameEvent.isGame = "isGame"
GameEvent.updateItem = "updateItem"
GameEvent.startGame = "startGame"
GameEvent.updateMail = "updateMail"
GameEvent.getHongbao = "getHongbao"
GameEvent.updatefriRoominfo = "updatefriRoominfo"
GameEvent.showgameMsg = "showgameMsg"
GameEvent.updateCardInfo = "updateCardInfo"
GameEvent.updateTaskInfo = "updateTaskInfo"
GameEvent.useItemJipaidi = "useItemJipaidi"
GameEvent.signupUserCnt = "signupUserCnt"
GameEvent.gameBackFromGround = "gameBackFromGround"--后台切回来
GameEvent.gametoBack = "gametoBack"--切后台
GameEvent.bshowMsgInfo = "bshowMsgInfo"--后台切回来
GameEvent.bNewMail = "bNewMail"--新邮件通知
GameEvent.updateRedSquare = "updateRedSquare"--刷新广场红包
GameEvent.updateMyRedSquare = "updateMyRedSquare"--刷新自己广场红包记录
GameEvent.updateChatInfo = "updateChatInfo"--刷新自己广场红包记录
GameEvent.upGradeVip = "upGradeVip"--vip升级
GameEvent.upHunderZoushi = "upHunderZoushi"--刷新走势图
GameEvent.updateBankerList = "updateBankerList"--刷新上庄玩家
GameEvent.updateChatCustomInfo = "updateChatCustomInfo"--刷新自定义聊天信息
GameEvent.updateRedMoney = "updateRedMoney"--刷新红包卷
GameEvent.updateBoolFirst = "updateBoolFirst"--刷新首充
GameEvent.updateLimitActivity = "updateLimitActivity"--刷新限时
GameEvent.updateFortuneAni = "GameEvent.updateFortuneAni" --刷新招财特效
GameEvent.updateDDZSignUpInfo = "GameEvent.updateDDZSignUpInfo" --刷新斗地主报名信息
GameEvent.updateShow7TaskSign = "GameEvent.updateShow7TaskSign" --刷新斗地主报名信息
GameEvent.updateLunckyUser = "GameEvent.updateLunckyUser" --刷新斗地主报名信息
GameEvent.updateBoxTask = "GameEvent.updateBoxTask" --刷新游戏宝箱任务
GameEvent.updateResurrectionTM = "GameEvent.updateResurrectionTM" --刷新复活倒计时任务
GameEvent.updateStartResurre = "GameEvent.updateStartResurre" --刷新开启复活
GameEvent.aliveChargeSuc = "GameEvent.aliveChargeSuc"--首充复活
GameEvent.updateCertifiy = "GameEvent.updateCertifiy"--刷新实名认证

return GameEvent