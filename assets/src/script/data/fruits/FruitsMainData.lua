-- 水果机数据层
-- Author:gaomeng.ning
-- Since:2016-06-20
--	
local FruitsMainData = class(...)

function FruitsMainData:ctor()
	--音效资源加载标记
	self.audioLoadDone = false
	--数据文件加载标记
	self.fileLoadDone = false

	--正式组合列表 (不负责分类，只保证组合不重复，数据原始位置在这里)
	self.formalGroupsList = {}
	--正式数据列表
	self.formalDataList = {}
	for i=1,9 do
		self.formalDataList[i] = {}
	end
	--当前压住金币数
	self.nowBetGold = 100
	--当前选中线路条数
	self.nowSelLineNum = 9
	--当前编辑的组合数据
	self.nowGroupData = {
			--激活列表
			activeList = {},
			--线数倍数列表
			lineTimesList = {},
			--组合
			group = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			--总免费次数
			freeGameNum = 0,
			--开奖等级
			sevenLevel = 0
		}
	--激活行的数据
	self.activeList = {
			--激活行号
			lineId = 0,
			--激活的Item Id
			itemId = 0,
			--激活的位置
			posList = {}
		}
	--线路列表
	self.roadList = {
			[1] = {2,5,8,11,14},
			[2] = {1,4,7,10,13},
			[3] = {3,6,9,12,15},
			[4] = {1,5,9,11,13},
			[5] = {3,5,7,11,15},
			[6] = {1,4,8,12,15},
			[7] = {3,6,8,10,13},
			[8] = {2,6,8,10,14},
			[9] = {2,4,8,12,14}
		}
	--倍数列表
	self.timesList = {
				-- 2、3、4、5 倍数
			[1] = {1,3,10,75},
			[2] = {0,3,10,85},
			[3] = {0,15,40,250},
			[4] = {0,25,50,400},
			[5] = {0,30,70,550},
			[6] = {0,35,80,650},
			[7] = {0,45,100,800},
			[8] = {0,75,175,1250},
			[9] = {0,0,0,0},
			[10] = {0,25,50,400},
			[11] = {0,100,200,1750}
		}
	--图标对应概率 （ % ）
	self.iconProList = {
			[1] = 34,
			[2] = 14,
			[3] = 11,
			[4] = 9,
			[5] = 7,
			[6] = 5,
			[7] = 5,
			[8] = 4,
			[9] = 2,
			[10] = 4,
			[11] = 5
		}
	--图标个数对应免费摇奖次数
	self.iconFreeList = {
			[1] = 0,
			[2] = 0,
			[3] = 5,
			[4] = 10,
			[5] = 15
		}
	--可选投注金额列表
	-- trace("===========",PlayerData:getCurRoomInfo().iRoomLevel)
	-- local iRoomLevel = PlayerData:getCurRoomInfo().iRoomLevel
	-- self.canSelPerGold = {500,2500,5000,25000,50000,250000,500000}
	--当前选中押注金额 Index
	self.curSelGoldIndex = 1

	--玩家金币
	self.gold = 0

	--奖池金额
	self.prizePool = 0
	--免费摇奖次数
	self.freeLottery = 0
	--此次是否获得免费摇奖
	self.curGetFree = false
	--此次是否为免费摇奖
	self.curIsFree = false
	--此次是否获得开奖
	self.curGet777 = false
	--上局赢取金币
	self.perWinGold = 0
	--正在游戏的数据
	self.playingData = {}
	--此轮免费摇奖赢取总和
	self.curFreeGetGold = 0

	--上轮开奖池玩家数据
	self.getPrizePoolUserInfo = {
			iHeadID      = 0,
			nPrizePoolReward = 0,
			nUserID      = 0,
			iVipLevel	 = 0,
			szHeadWeb    = "",
			szNickName   = "",
			tmTime 		 = 0,
		}
	--上轮开奖池玩家数据
	self.getSuperPrizePoolUserInfo = {
			iHeadID      = 0,
			nPrizePoolReward = 0,
			nUserID      = 0,
			iVipLevel	 = 0,
			szHeadWeb    = "",
			szNickName   = "",
			tmTime 		 = 0,
		}
	--坐上玩家数据
	self:clearPlayerDataList()
	-- self.onSetPlayerDataList = {
	-- 		ucCount = 0,
	-- 		showUserInfo = {}
	-- 	}

	--数据初始化标记
	self.dataIsInit = false
end

--数据初始化
function FruitsMainData:init()
	self.gold = PlayerData:getGold()
	--奖池金额
	self.prizePool = 0
	--免费摇奖次数
	self.freeLottery = 0
	--此次是否获得免费摇奖
	self.curGetFree = false
	--此次是否为免费摇奖
	self.curIsFree = false
	--此次是否获得开奖
	self.curGet777 = false
	--上局赢取金币
	self.perWinGold = 0
	--正在游戏的数据
	self.playingData = {}
	--此轮免费摇奖赢取总和
	self.curFreeGetGold = 0

	local selPreGold = {
		[1] = {50,200,500,1000,2500,5000,10000,25000,50000,100000,250000,500000},
		[2] = {50,200,500,1000,2500,5000,10000,25000,50000,100000,250000,500000},
		[3] = {200,500,1000,2500,5000,10000,25000,50000,100000,250000,500000},
		[4] = {1000,2500,5000,10000,25000,50000,100000,250000,500000},
	}
	self.canSelPerGold = selPreGold[PlayerData:getCurRoomInfo().iRoomLevel] -- {50,200,500,1000,2500,5000,10000,25000,50000,100000,250000,500000}

	local fruitsLocalData = util.getKey("fruits")
	if fruitsLocalData == "" then
		util.setKey("fruits",""..self.nowSelLineNum..","..self.curSelGoldIndex)
	else
		local table = string.split(fruitsLocalData,",")
		-- self.nowSelLineNum = toint(table[1])
		self.curSelGoldIndex = toint(table[2])
		if self.curSelGoldIndex > #self.canSelPerGold then
			self.curSelGoldIndex = #self.canSelPerGold
		end
	end
	if not self.dataIsInit then
		self:dataInit()
	end
end

--数据初始化
function FruitsMainData:dataInit()
	self.dataIsInit = true
	local readText = cc.FileUtils:getInstance():getStringFromFile("img2/fruits/fruitsSimpleData.j")
	self.formalGroupsList = json.decode(readText)
	for k,v in pairs(self.formalGroupsList) do
		self:addGroup(v)
	end
	scheduleFunOne(function() 
		local readText = cc.FileUtils:getInstance():getStringFromFile("img2/fruits/fruitsData.j")
		self.formalGroupsList = json.decode(readText)
	    local addSch
	    local index = 0
	    local function addFun()
	    	for i=1,5 do
	    		index = index + 1
	    		self:addGroup(self.formalGroupsList[index])
				if index == #self.formalGroupsList then
					trace("-----DATA ADD DONE !!!!-----")
					unscheduleFun(addSch)
					return
				end
	    	end
	    end
	    addSch = scheduleFun(addFun, 0.05)
	end,5)
end

--添加正式组合
function FruitsMainData:initStartData(data)
	self.prizePool = data.i64PrizePool
	self.perWinGold = data.iPerWinGold
end

--更新上轮开奖池玩家数据
function FruitsMainData:updatePrizePoolUserInfo(data)
	self.getPrizePoolUserInfo = {
			iHeadID      		= data.userInfo.iHeadID,
			nPrizePoolReward 	= data.userInfo.nPrizePoolReward,
			n64PrizePool 		= data.userInfo.n64PrizePool,
			nUserID      		= data.userInfo.nUserID,
			iVipLevel	 		= data.userInfo.iVipLevel,
			szHeadWeb    		= data.userInfo.szHeadWeb,
			szNickName   		= data.userInfo.szNickName,
			tmTime 				= data.userInfo.tmTime,
		}
	self.getSuperPrizePoolUserInfo = {
			iHeadID      		= data.superUserInfo.iHeadID,
			nPrizePoolReward 	= data.superUserInfo.nPrizePoolReward,
			n64PrizePool 		= data.superUserInfo.n64PrizePool,
			nUserID      		= data.superUserInfo.nUserID,
			iVipLevel	 		= data.superUserInfo.iVipLevel,
			szHeadWeb    		= data.superUserInfo.szHeadWeb,
			szNickName   		= data.superUserInfo.szNickName,
			tmTime 		 		= data.superUserInfo.tmTime,
		}
	self.prizePool = data.userInfo.n64PrizePool
end

--展示的玩家信息
function FruitsMainData:initOnSetPlayer(data)
	if data.ucCount > 0 then
		self.onSetPlayerDataList = data
	end
end

function FruitsMainData:clearPlayerDataList( ... )
	self.onSetPlayerDataList = {
			ucCount = 0,
			showUserInfo = {}
	}
end

--展示的玩家信息
function FruitsMainData:updateOnSetPlayer(data)
end

--数据回调
function FruitsMainData:betDataHandle1(responseData)
	self.playingData = {}
	self.playingData.errCode = responseData.nErrCode
	self.playingData.line = responseData.nLineNum
	self.playingData.times = responseData.nWinRate
	self.playingData.bet = responseData.nBet
	self.playingData.freeGameNum = 0
	self.playingData.bonusCount = responseData.nBonusCount
	if responseData.nBonusCount > 0 then
		self.curGetFree = true
		self.curIsFree = true -- 修复刚获取免费摇奖 刚好金币不足的情况
		self.playingData.freeGameNum = (responseData.nBonusCount - 2)*5
	end
	self.playingData.sevenLevel = responseData.n777Count
	if responseData.n777Count > 0 then
		self.curGet777 = true
	end
end

--数据回调
function FruitsMainData:betDataHandle2(responseData)
	self.playingData.gold = responseData.nUserGold
	self.playingData.winGold = responseData.iWinGold
	self.playingData.freeLottery = responseData.bFreeLotteryCount
	self.playingData.prizePool = responseData.nPrizePool
	self.playingData.prizePoolReward = responseData.iPrizePoolReward
	util.setKey("fruits",""..self.nowSelLineNum..","..self.curSelGoldIndex)
end

--添加正式组合
function FruitsMainData:addGroup(groupData)
	local groupData = groupData
	local lineTimesList = groupData[2]
	local freeGameNum = groupData[3]
	local sevenLevel = groupData[4]
	local sevenLineId = groupData[5]
	for i=1,9 do
		--当前线数中奖倍数
		local curTimes = lineTimesList[i]
		local curGrouping
		if i < sevenLineId then
			curGrouping = self:getGrouping({line = i,times = curTimes,freeGameNum = freeGameNum,sevenLevel = 0})
		else
			curGrouping = self:getGrouping({line = i,times = curTimes,freeGameNum = freeGameNum,sevenLevel = sevenLevel})
		end
		table.insert(curGrouping.groupsList, groupData[1])
	end
end

--获取随机数据
function FruitsMainData:getRandData()
	math.randomseed(tonum(tostring(os.clock()*1000000):reverse():sub(1,6)))
	self.nowGroupData = self:makeNewData()
	self:dataHandle(self.nowGroupData)
	return self.nowGroupData
end

--获取随机数据
function FruitsMainData:getOneData(data)
	traceObj(data)
	local curGrouping = self:getGrouping({
			line = data.line,
			times = data.times,
			freeGameNum = data.freeGameNum,
			sevenLevel = data.sevenLevel
		})
	local group = self:strToTable(curGrouping.groupsList[math.random(#curGrouping.groupsList)])
	self.nowGroupData = self:makeNewData(group)

	trace("----self.nowGroupData------",self.nowGroupData)

	self:dataHandle(self.nowGroupData)
	return self.nowGroupData
end

--获取正式分组
function FruitsMainData:getGrouping(data)
	local line = data.line
	local times = data.times
	local freeGameNum = data.freeGameNum
	local sevenLevel = data.sevenLevel

	--当前线数 倍数 b 7 相同的列表
	local curData
	for k,v in pairs(self.formalDataList[line]) do
		if v.times == times and v.freeGameNum == freeGameNum and v.sevenLevel == sevenLevel then
			curData = v
		end
	end
	if not curData then
		curData = {times = times,freeGameNum = freeGameNum,sevenLevel = sevenLevel,groupsList = {}}
		table.insert(self.formalDataList[line], curData)
	end
	return curData
end

--table转str
function FruitsMainData:tableToStr(table)
	local str = ""
	for i=1,#table do
		if i ~= #table then
			str = str .. table[i] .. ","
		else
			str = str .. table[i]
		end
	end
	return str
end

--str转table
function FruitsMainData:strToTable(str)
	local table = string.split(str,",")
	for i=1,#table do
		table[i] = tonum(table[i])
	end
	return table
end

--获取一个图标
function FruitsMainData:getOneIconIndex()
	local randomNum = math.random(100)
	local cueIndex = 0
	for i=#self.iconProList,1,-1 do
		local addChance = self.iconProList[i]
		if randomNum <= addChance then
			cueIndex = i
			break
		else
			randomNum = randomNum - addChance
		end
	end
	return cueIndex
end

--随机生成算法
function FruitsMainData:makeNewData(group)
	local randData = {
			--激活列表
			activeList = {},
			--线数倍数列表
			lineTimesList = {},
			--组合
			group = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			--组合字符串
			groupStr = "",
			--总免费次数
			freeGameNum = 0,
			--开奖等级 3个7 3级，4个7 4级，5个以上7 5级。
			sevenLevel = 0
		}
	if group then
		randData.group = group
	else
		for i=1,15 do
			randData.group[i] = self:getOneIconIndex()
		end
	end
	randData.groupStr = self:tableToStr(randData.group)
	return randData
end

--倍数计算算法
function FruitsMainData:dataHandle(groupData)
	local group = groupData.group
	groupData.activeList = {}
	groupData.lineTimesList = {}
	groupData.group = group
	groupData.freeGameNum = 0
	groupData.sevenLevel = 0

	--单条线路倍数计算
	local function timesCount(roadData,lineId)
		local nowRoad = roadData
		local activeData = {
				--激活行号
				lineId = lineId,
				--激活的Item Id
				itemId = 0,
				--激活数量
				activeNum = 0,
				--此次倍数
				thisTimes = 0,
				--激活的位置
				posList = {}
			}

		local posList = {}
		--确定ItemId
		activeData.itemId = group[nowRoad[1]]
		for i=2,#nowRoad do
			if group[nowRoad[i-1]] == 9 then
				activeData.itemId = group[nowRoad[i]]
			else
				break
			end
		end
		--激活数量计算
		if activeData.itemId < 9 then
			for j=1,#nowRoad do
				if group[nowRoad[j]] == activeData.itemId or group[nowRoad[j]] == 9 then
					activeData.activeNum = activeData.activeNum + 1
					table.insert(posList,nowRoad[j])
				else
					break
				end
			end
		else
			for j=1,#nowRoad do
				if group[nowRoad[j]] == activeData.itemId then
					activeData.activeNum = activeData.activeNum + 1
					table.insert(posList,nowRoad[j])
				else
					break
				end
			end
		end
		if activeData.activeNum >= 2 then
			--当前线路倍数计算
			activeData.thisTimes = self.timesList[activeData.itemId][activeData.activeNum-1]
			activeData.posList = posList
			if activeData.thisTimes > 0 then
				return activeData
			end
		end
		return false
	end

	--检查线路
	local nineTimes = 0
	local nineActive = 0
	for i=1,#self.roadList do
		local lineNum = i
		local nowRoad = self.roadList[i]
		--正向检察
		local activeData = timesCount(nowRoad,i)
		if activeData then
			nineTimes = nineTimes + activeData.thisTimes
			nineActive = nineActive + 1
			table.insert(groupData.activeList,activeData)
		end
		groupData.lineTimesList[lineNum] = {times = nineTimes,active = nineActive}
	end

	--免费摇奖次数计算
	local exitList = {}
	for i=1,5 do
		local exit = false
		for j=1,3 do
			if group[(i-1)*3+j] == 10 then
				exit = true
			end
		end
		table.insert(exitList, exit)
	end
	local activeNum = 0
	local activeIndex = 0
	for i=1,#exitList do
		if exitList[i] then
			activeIndex = activeIndex + 1
			if activeIndex > activeNum then
				activeNum = activeIndex
			end
		else
			activeIndex = 0
		end
	end
	if activeNum >= 3 then
		groupData.freeGameNum = self.iconFreeList[activeNum]
	end

	--开奖等级计算
	for k,v in pairs(groupData.activeList) do
		if v.itemId == 11 then
			if v.activeNum > groupData.sevenLevel then
				groupData.sevenLevel = v.activeNum
			end
		end
	end

	return groupData
end

return FruitsMainData

