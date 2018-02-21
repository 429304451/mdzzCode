-- Date: 2018-01-10 14:03:00
-- 玩家任务数据
local PlayerTaskData = class("PlayerTaskData")

function PlayerTaskData.create()
	return PlayerTaskData.new()
end

--获取玩家任务数据列表
function PlayerTaskData:ctor()
    -- self._playerTaskData = require("config.template.resurrection")
    -- assert(self._playerTaskData~=nil , "PlayerTaskData:self._playerTaskData nil")
    self._7SignTask = require("config.template.7SignTask")
    assert(self._7SignTask~=nil , "PlayerTaskData:self._7SignTask nil")
end
--设置7
function PlayerTaskData:set7SignTaskCurDay( info )
	self._7SignTaskInfo = info
	self._7SignTaskCurDay = info.iNewTaskID
	if self._7SignTaskCurDay < 1 then
		self._7SignTaskCurDay = 1
	end
	if self._7SignTask and self._7SignTask[self._7SignTaskCurDay] then
		self._7SignTask[self._7SignTaskCurDay].bActive = true
		self._7SignTask[self._7SignTaskCurDay].iCurFinshJushu = info.iNewFinishCount
	end
end

function PlayerTaskData:get7SignTaskInfo( ... )
	return self._7SignTask
end

function PlayerTaskData:get7SignTaskCurDayInfo( ... )
	return self._7SignTaskInfo
end

function PlayerTaskData:setCurResurrectTask( ... )
	-- body
end

--任务类型,4对局，5赚金 6胜利 7充值 8签到 9比赛
--任务子类型 1斗地主 2牛牛 3百人狂欢 4疯狂水果 5疯狂双十
function PlayerTaskData:setCompleteCount( info )
	if not self._7SignTaskInfo or not self._7SignTaskInfo.iNewTaskID then
		return
	end
	local iDay = self._7SignTaskInfo.iNewTaskID
	if self._7SignTask and self._7SignTask[iDay] and self._7SignTask[iDay] then
		local taskType = self._7SignTask[iDay].taskType
		local iGameType = self._7SignTask[iDay].gameType
		local bGameMatch = self._7SignTask[iDay].bMatch
		if taskType == 4 then
			if iGameType == 0 and self._7SignTask[iDay].iCurFinshJushu < self._7SignTask[iDay].iFhishJushu then
				self._7SignTask[iDay].iCurFinshJushu = self._7SignTask[iDay].iCurFinshJushu + 1
			elseif iGameType == info.iGameType and self._7SignTask[iDay].iCurFinshJushu < self._7SignTask[iDay].iFhishJushu then
				self._7SignTask[iDay].iCurFinshJushu = self._7SignTask[iDay].iCurFinshJushu + 1
			end
		elseif taskType == 9  then
			if info.bMatch and iGameType == info.iGameType and self._7SignTask[iDay].iCurFinshJushu < self._7SignTask[iDay].iFhishJushu then
				self._7SignTask[iDay].iCurFinshJushu = self._7SignTask[iDay].iCurFinshJushu + 1
			end
		elseif taskType == 5 or taskType == 6  then
			if info.bWin and iGameType == info.iGameType and self._7SignTask[iDay].iCurFinshJushu < self._7SignTask[iDay].iFhishJushu then
				self._7SignTask[iDay].iCurFinshJushu = self._7SignTask[iDay].iCurFinshJushu + 1
			end
		elseif taskType == 7 or taskType == 8 then
			if info.taskType and info.taskType == taskType and self._7SignTask[iDay].iCurFinshJushu < self._7SignTask[iDay].iFhishJushu then
				self._7SignTask[iDay].iCurFinshJushu = self._7SignTask[iDay].iCurFinshJushu + 1
			end
		elseif taskType == 10 then
			if info.taskType and info.taskType == taskType and self._7SignTask[iDay].iCurFinshJushu < self._7SignTask[iDay].iFhishJushu then
				self._7SignTask[iDay].iCurFinshJushu = self._7SignTask[iDay].iCurFinshJushu + 1
				self._7SignTaskInfo.iNewTaskValue = 1
			end
		end
	end
end

function PlayerTaskData:setChargeCount( ... )
	-- body
end

return PlayerTaskData