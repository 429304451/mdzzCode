--疯狂双十逻辑
local crazyLogic = class("crazyLogic")
local bit = require "bit"
UG_HUA_MASK			=		0xF0			
UG_VALUE_MASK		=		0x0F
--扑克花色
local CARD_POKER_COLOR ={}
CARD_POKER_COLOR.UG_FANG_KUAI				= 0x00			--方块	0000 0000
CARD_POKER_COLOR.UG_MEI_HUA					= 0x10			--梅花	0001 0000
CARD_POKER_COLOR.UG_HONG_TAO				= 0x20			--红桃	0010 0000
CARD_POKER_COLOR.UG_HEI_TAO					= 0x30			--黑桃	0011 0000
CARD_POKER_COLOR.UG_NT_CARD					= 0x40			--主牌	0100 0000
CARD_POKER_COLOR.UG_ERROR_HUA				= 0xF0			--错误  1111 0000

--扑克出牌类型
local CARD_TYPE = {}
CARD_TYPE.UG_UNKNOW								=	-1				--不能识别牌型
CARD_TYPE.UG_NO_POINT							=	0x00			--散牌
CARD_TYPE.UG_BULL_ONE							=	0x01			--牛一
CARD_TYPE.UG_BULL_TWO							=	0x02            --牛二
CARD_TYPE.UG_BULL_THREE							=	0x03			--牛三
CARD_TYPE.UG_BULL_FOUR							=	0x04            --牛四
CARD_TYPE.UG_BULL_FIVE							=	0x05			--牛五
CARD_TYPE.UG_BULL_SIX							=	0x06			--牛六
CARD_TYPE.UG_BULL_SEVEN							=	0x07			--牛七
CARD_TYPE.UG_BULL_EIGHT							=	0x08            --牛八
CARD_TYPE.UG_BULL_NINE							=	0x09			--牛九
CARD_TYPE.UG_BULL_BULL							=	0x0A			--牛牛
CARD_TYPE.UG_BULL_SIZHA							=	0x0B			--四炸
CARD_TYPE.UG_BULL_WUHUANIU						=	0x0C			--五花牛
CARD_TYPE.UG_BULL_WUXIAONIU						=	0x0D			--五小牛

--德州牌型
local CARD_TEXAX_TYPE = {}
CARD_TEXAX_TYPE.TEXAX_SINGLE 					=	0x00 			--单牌类型
CARD_TEXAX_TYPE.TEXAX_ONE_LONG 					=	0x01 			--对子类型
CARD_TEXAX_TYPE.TEXAX_TWO_LONG 					=	0x02 			--两对类型
CARD_TEXAX_TYPE.TEXAX_THREE_TIAO 				=	0x03 			--三条类型
CARD_TEXAX_TYPE.TEXAX_SHUN_ZI 					=	0x04 			--顺子类型
CARD_TEXAX_TYPE.TEXAX_TONG_HUA 					=	0x05 			--同花类型
CARD_TEXAX_TYPE.TEXAX_HU_LU 					=	0x06 			--葫芦类型
CARD_TEXAX_TYPE.TEXAX_TIE_ZHI 					=	0x07 			--铁支类型
CARD_TEXAX_TYPE.TEXAX_TONG_HUA_SHUN 			=	0x08 			--同花顺型

local enSortCardType = {}
enSortCardType.enDescend 						=	0x00
enSortCardType.enAscend 						=	0x01
enSortCardType.enColor 							=	0x02

local CARDCOUNT 	= 	5
local MAXCARDNUM 	=	6
local ONE_PK_CARD_NUM 	= 	52
local UG_VALUE_MASK 	=	0x0F

function crazyLogic:ctor()
end

function crazyLogic:SortCardList( bCardData, bCardCount, iSortCardType)
	if bCardCount ~= CARDCOUNT then
		return {}
	end
	if not iSortCardType then
		iSortCardType = enSortCardType.enAscend
	end
	local bLogicVolue = {}
	for i=0,bCardCount-1 do
		bLogicVolue[i] = self:GetCardPoint(bCardData[i])
	end
	if (iSortCardType == enSortCardType.enDescend) then --降序
		-- trace("=========降序==============")
		local bSorted = true
		local bTempData,bTempCardData
		local bLast = bCardCount - 1
		local m_bCardCount = 1
		for i=0,bLast do
			for j=i+1,bLast do
				if bLogicVolue[i] < bLogicVolue[j] or  (bLogicVolue[i] == bLogicVolue[j] and bCardData[i] < bCardData[j]) then
					bTempCardData = bCardData[i]
					bCardData[i] = bCardData[j]
					bCardData[j] = bTempCardData
					bTempData = bLogicVolue[i]
					bLogicVolue[i] = bLogicVolue[j]
					bLogicVolue[j] = bTempData
					bSorted = false
				end
			end
		end
	elseif iSortCardType == enSortCardType.enAscend then --升序
		-- trace("=========升序==============")
		local bSorted = true
		local bTempData
		local bLast = bCardCount - 1
		local m_bCardCount = 1
		for i=0,bLast do
			for j=i+1,bLast do
				if bLogicVolue[i] > bLogicVolue[j] or  (bLogicVolue[i] == bLogicVolue[j] and bCardData[i] > bCardData[j]) then
					bTempData = bCardData[i]
					bCardData[i] = bCardData[j]
					bCardData[j] = bTempData
					bTempData = bLogicVolue[i]
					bLogicVolue[i] = bLogicVolue[j]
					bLogicVolue[j] = bTempData
					bSorted = false
				end
			end
		end
	elseif enSortCardType.enColor == iSortCardType then --花色排序
		local bSorted = true
		local bTempData
		local bLast = bCardCount - 1
		local m_bCardCount = 1
		local bColor = {}
		for i=0,bCardCount-1 do
			bColor[i] = self:GetCardHuaKind(bCardData[i], true)
		end
		for i=0,bLast do
			for j=i+1,bLast do
				if bLogicVolue[i] > bLogicVolue[j] or  (bLogicVolue[i] == bLogicVolue[j] and self:GetCardPoint(bCardData[i]) > self:GetCardPoint(bCardData[j])) then
					bTempData = bCardData[i]
					bCardData[i] = bCardData[j]
					bCardData[j] = bTempData
					bTempData = bLogicVolue[i]
					bColor[i] = bColor[j]
					bColor[j] = bTempData
					bSorted = false
				end
			end
		end
	end
	return bCardData
end

function crazyLogic:TheBestCard( bCardData, bCardCount)
	local GetCardData = {}
	if bCardCount ~= MAXCARDNUM then
		return
	end
	local iTempCard = {}
	local iTempType = CARD_TYPE.UG_UNKNOW
	local bIndex = 0
	local bMaxCardType = CARD_TYPE.UG_UNKNOW
	local iMaxCardData = {}
	local bFirst = true
	for i=0,bCardCount-1 do
		iTempCard = {}
		for j=0,bCardCount-1 do
			if j ~= i then
				iTempCard[bIndex] = bCardData[j]
				bIndex = bIndex + 1
			end
		end
		bIndex = 0
		iTempType = self:GetCardShape(iTempCard,CARDCOUNT)
		if bFirst then
			bMaxCardType = iTempType
			iMaxCardData = table.copy(iTempCard)
			bFirst = false
		else
			if self:CompareCardType(bMaxCardType, iTempType, iMaxCardData, CARDCOUNT, iTempCard, CARDCOUNT) == 0 then
				bMaxCardType = iTempType
				iMaxCardData = table.copy(iTempCard)
			end
		end
	end
	GetCardData = table.copy(iMaxCardData)
	return GetCardData
end

--按牌面数字从大到小排列扑克
function crazyLogic:SortCard( iCardList, bUp, iCardCount, bSysSort )
	local iStationVol = {}
	local iTemp = 0
	if iCardCount <= 0 then
		return false
	end
	for i=0,iCardCount-1 do
		iStationVol[i] = self:GetCardBulk(iCardList[i], true)
	end
	for i=0,iCardCount-1 do
		for j=i+1,iCardCount-1 do
			if iStationVol[i] > iStationVol[j] then
				--交换位置				//==冒泡排序
				iTemp=iCardList[i]
				iCardList[i]=iCardList[j]
				iCardList[j]=iTemp

				iTemp=iStationVol[i]
				iStationVol[i]=iStationVol[j]
				iStationVol[j]=iTemp
			end
		end
	end
	return true
end

--删除扑克
function crazyLogic:RemoveCard( iRemoveCard, iRemoveCount,iCardList,iCardCount )
	if iRemoveCount > iCardCount then
		return 0
	end
	local iRecount
	local iDeleteCount = 0
	for k,v in pairs(iRemoveCard) do
		for key,val in pairs(iCardList) do
			if val == v then
				iDeleteCount = iDeleteCount + 1
				iCardList[key] = 0
				break
			end
		end
	end
	iRecount = self:RemoveNummCard(iCardList, iCardCount) --删除做了标记的牌
	if iDeleteCount ~= iRecount then
		return 0
	end
	return iDeleteCount
end
--清除
function crazyLogic:RemoveNummCard( iCardList, iCardCount )
	local iRemoveCount = 0
	for i=0,iCardCount-1 do
		if iCardList[i] ~= 0 then
			iCardList[i - iRemoveCount] = iCardList[i]
		else
			iRemoveCount = iRemoveCount + 1
		end
	end
	return iRemoveCount
end

--获取扑克数字
function crazyLogic:GetCardNum( iCard )
	return (math.floor(iCard%16))+1
 end

 --获取牌型数字
 function crazyLogic:GetLogicCardValue( iCard )
 	if self:GetCardNum(iCard) == 14 then 
 		return 1
 	else
 		return self:GetCardNum(iCard)
 	end
 end

--获取扑克花色
function crazyLogic:GetCardHuaKind( iCard , bTrueHua)
 	local iHuaKind =  math.floor(iCard/16)
	if not bTrueHua then
		iHuaKind = CARD_POKER_COLOR.UG_NT_CARD 
		return iHuaKind
	end
	return iHuaKind
 end

--获取扑克相对大小
function crazyLogic:GetCardBulk( iCard, bExtVal )
	if iCard == 0x4E or iCard == 0x4F then
		if bExtVal then
			return iCard-14
		else
			return iCard-62
		end
	end

	local iCardNum = self:GetCardNum(iCard)
	local iHuaKind = self:GetCardHuaKind(iCard, true)
	if iCardNum == 14 then
		return 1
	end

	return iCardNum
end
--获取牌型点数
function crazyLogic:GetCardPoint( iCard )
	if iCard == 0x00 then
		return 0
	end
	if self:GetCardNum(iCard) == 14 then
		return 1
	else
		return self:GetCardNum(iCard)
	end
end
--根据牌获取它对应的点数值 --JQK为10点
function crazyLogic:GetPoint( iCard )
	if iCard == 0x00 then
		return 0
	end
	if self:GetCardNum(iCard) == 14 then
		return 1
	elseif self:GetCardNum(iCard) == 10 or  self:GetCardNum(iCard) == 11 or self:GetCardNum(iCard) == 12 or self:GetCardNum(iCard) == 13 or self:GetCardNum(iCard) == 15 or self:GetCardNum(iCard) == 16 then
		return 10
	else
		return self:GetCardNum(iCard)
	end
end
--排序
function crazyLogic:SortBullTypeCard( iCardList,iCardCount )
	if iCardCount ~= 5 then
		return
	end
	local iCardType = self:GetCardShape(iCardList,iCardCount)
	if iCardType == CARD_TYPE.UG_NO_POINT or iCardType == CARD_TYPE.UG_BULL_WUHUANIU or iCardType == CARD_TYPE.UG_BULL_SIZHA or iCardType == CARD_TYPE.UG_BULL_WUXIAONIU then
		return
	end
	local temp = table.copy(iCardList)
	local iCardBull = {}
	iCardBull = self:GetBullCard(temp,table.nums(temp),iCardBull,table.nums(iCardBull))
	iCardList = table.copy(iCardBull)
	local index = table.nums(iCardList)
	for k,v in pairs(temp) do
		local bFind = false
		for k1,v1 in pairs(iCardList) do
			if v == v1 then
				bFind = true
				break
			end
		end
		if not bFind then
			table.insert(iCardList,index,v)
		end
	end
	return iCardList
end
--获取能组合10倍数的三张牌
function crazyLogic:GetBullCard( bCardList,iCardCount,bCardBull,iCountBull )
	local total = self:CountPoint(bCardList,iCardCount)
	for i=0,2 do
		for j=i+1,3 do
			for k=j+1,iCardCount-1 do
				local temp = self:GetPoint(bCardList[i])+self:GetPoint(bCardList[j])+self:GetPoint(bCardList[k])
				if temp==30 or temp==10 or temp==20 then
					bCardBull[0] = bCardList[i]
					bCardBull[1] = bCardList[j]
					bCardBull[2] = bCardList[k]
					return bCardBull
				end
			end
		end
	end
	return bCardBull
end
--计算牌中点数
function crazyLogic:CountPoint( iCardList,iCardCount )
	local iPoint = 0
	for i,v in pairs(iCardList) do
		local temp = self:GetPoint(v)
		if temp == 14 then
			temp = 1
		end
		iPoint = iPoint + temp
	end
	return iPoint
end
--获取指定张数牌个数
function crazyLogic:GetCountBySpecifyNumCount( iCardList,iCardCount,Num )
	local temp = {}
	local count = 0
	for i,v in pairs(iCardList) do
		if temp[self:GetCardBulk(v, false)] == nil then
			temp[self:GetCardBulk(v, false)] = 0
		end
		temp[self:GetCardBulk(v, false)] = temp[self:GetCardBulk(v, false)]+1
	end
	for i=0,17 do
		if temp[i] and temp[i] == Num then
			count = count + 1
		end
	end
	return count
end
--统计选出指定张数牌是否可以组成20,10,0如果返回为非0值,表示余下点数和,返回0表示不成立
function crazyLogic:CanSumIn( iCardList,iCardCount,iSelectNum )
	local total = self:CountPoint(iCardList,iCardCount)
	for i=0,2 do
		for j=i+1,3 do
			for k=j+1,iCardCount-1 do
				local temp = self:GetPoint(iCardList[i]) + self:GetPoint(iCardList[j]) + self:GetPoint(iCardList[k])
				if temp == 30 or temp == 10 or temp == 20 then
					return total - temp
				end
			end
		end
	end
	return -1
end

--五小牛
function crazyLogic:IsWuXiaoBull( iCardList,iCardCount )
	if CARDCOUNT ~= iCardCount then
		return false
	end
	for i,v in pairs(iCardList) do
		if self:GetCardPoint(v) >= 5 then
			return false
		end
	end
	if self:CountPoint(iCardList,iCardCount) > 10 then
		return false
	end
	return true
end

--四炸
function crazyLogic:IsFourBomb( iCardList,iCardCount )
	if CARDCOUNT ~= iCardCount then
		return false
	end
	if self:GetCountBySpecifyNumCount(iCardList,iCardCount,4) ~= 1 then
		return false
	end
	return true
end

--五花牛
function crazyLogic:IsGoldBull( iCardList,iCardCount )
	if CARDCOUNT ~= iCardCount then
		return false
	end
	for i,v in pairs(iCardList) do
		if self:GetCardNum(v) < 11 or self:GetCardNum(v) == 14 then
			return false
		end
	end
	return true
end

--牛牛
function crazyLogic:IsBullBull( iCardList,iCardCount )
	if CARDCOUNT ~= iCardCount then
		return false
	end
	local total = self:CountPoint(iCardList,iCardCount)
	if self:CanSumIn(iCardList,iCardCount,3) == -1 then
		return false
	end
	if total > 0 and total%10 == 0 then
		return true
	end
	return false
end

--是否有牛
function crazyLogic:IsHaveNote( iCardList,iCardCount )
	local Note = self:CanSumIn(iCardList,iCardCount,3)
	if Note == -1 then
		return -1
	else
		return Note%10
	end
end

-------------------------------------------------------------------
----------------------------德州牌型判断---------------------------
-------------------------------------------------------------------
--葫芦
function crazyLogic:IsHuLu( iCardList,iCardCount )
	if CARDCOUNT ~= iCardCount then
		return false
	end
	if self:GetCountBySpecifyNumCount(iCardList,iCardCount,3) ~= 1 then
		return false
	end
	if self:GetCountBySpecifyNumCount(iCardList,iCardCount,2) ~= 1 then
		return false
	end
	return true
end
--同花顺
function crazyLogic:IsSameHuaShun( iCardList,iCardCount )
	if not self:IsSameHua(iCardList,iCardCount) then
		return false
	elseif not self:IsShunZi(iCardList,iCardCount) then
		return false
	end
	return true
end
--同花
function crazyLogic:IsSameHua( iCardList,iCardCount )
	if CARDCOUNT ~= iCardCount then
		return false
	end
	local tblCardList = table.copy(iCardList)
	-- self:SortCardList(tblCardList, iCardCount)
	
	local hua = self:GetCardHuaKind(tblCardList[0], true)
	for i=1,iCardCount-1 do 
		if self:GetCardHuaKind(tblCardList[i],true) ~= hua then
			return false
		end
	end
	return true
end
--顺子
function crazyLogic:IsShunZi( iCardList,iCardCount )
	if CARDCOUNT ~= iCardCount then
		return false
	end
	local tblCardList = table.copy(iCardList)
	tblCardList = self:SortCardList(tblCardList, iCardCount, enSortCardType.enDescend)
	local hs = -1
	local temp1,temp2,temp3,temp4,temp5
	temp1 = self:GetCardPoint(tblCardList[0])
	temp2 = self:GetCardPoint(tblCardList[1])
	temp3 = self:GetCardPoint(tblCardList[2])
	temp4 = self:GetCardPoint(tblCardList[3])
	temp5 = self:GetCardPoint(tblCardList[4])
	if temp1 == temp2+1 and temp2 == temp3+1 and temp3 == temp4+1 and temp4 == temp5+1 then
		return true
	elseif temp1==1 and temp2==13 and temp3==12 and temp4==11 and temp5==10 then
		return true
	end
	-- for i=0,iCardCount-1 do
	-- 	trace("=============",self:GetCardNum(tblCardList[i]) % 14,(self:GetCardNum(tblCardList[i+1]) + 1))
	-- 	if self:GetCardNum(tblCardList[i]) % 14 ~= (self:GetCardNum(tblCardList[i+1]) + 1) then 
	-- 		if temp1==1 and temp2==13 and temp3==12 and temp4==11 and temp5==10 then
	-- 			return true
	-- 		else
	-- 			return false
	-- 		end
	-- 	end
	-- end
	return false
end

--是否是单牌
function crazyLogic:IsOnlyOne( iCardList, iCardCount)
	return iCardCount == 1
end
--是否是对子
function crazyLogic:IsDouble( iCardList, iCardCount)
	if CARDCOUNT ~= iCardCount then
		return false
	end
	--判断是否对子
	if self:GetCountBySpecifyNumCount(iCardList,iCardCount,2) == 1 then
		return true
	end
	return false
end
--是否是双对
function crazyLogic:IsTwoDouble( iCardList, iCardCount)
	if CARDCOUNT ~= iCardCount then
		return false
	end
	--判断是否两对
	if self:GetCountBySpecifyNumCount(iCardList,iCardCount,2) == 2 then
		return true
	end
	return false
end
--是否是3带
function crazyLogic:IsThreeX( iCardList, iCardCount)
	if CARDCOUNT ~= iCardCount then
		return false
	end
	if self:GetCountBySpecifyNumCount(iCardList,iCardCount, 3) == 1 then
		return true
	end
	return false
end

function crazyLogic:GetCardShapeStr( iCardType )
	local str
	if iCardType == CARD_TYPE.UG_BULL_WUXIAONIU then
		str = "五小"
	elseif iCardType == CARD_TYPE.UG_BULL_WUHUANIU then
		str = "五花"
	elseif iCardType == CARD_TYPE.UG_BULL_SIZHA then
		str = "四炸"
	elseif iCardType == CARD_TYPE.UG_BULL_BULL then
		str = "双十"
	elseif iCardType == CARD_TYPE.UG_BULL_ONE then
		str = "十带一"
	elseif iCardType == CARD_TYPE.UG_BULL_TWO then
		str = "十带二"
	elseif iCardType == CARD_TYPE.UG_BULL_THREE then
		str = "十带三"
	elseif iCardType == CARD_TYPE.UG_BULL_FOUR then
		str = "十带四"
	elseif iCardType == CARD_TYPE.UG_BULL_FIVE then
		str = "十带五"
	elseif iCardType == CARD_TYPE.UG_BULL_SIX then
		str = "十带六"
	elseif iCardType == CARD_TYPE.UG_BULL_SEVEN then
		str = "十带七"
	elseif iCardType == CARD_TYPE.UG_BULL_EIGHT then
		str = "十带八"
	elseif iCardType == CARD_TYPE.UG_BULL_NINE then
		str = "十带九"
	elseif iCardType == CARD_TYPE.UG_NO_POINT then
		str = "散牌"
	end
	return str
end

function crazyLogic:GetCardShape( iCardList, iCardCount, bExlVol)
	if self:IsWuXiaoBull(iCardList,iCardCount) then
		return CARD_TYPE.UG_BULL_WUXIAONIU
	elseif self:IsGoldBull(iCardList,iCardCount) then
		return CARD_TYPE.UG_BULL_WUHUANIU
	elseif self:IsFourBomb(iCardList,iCardCount)  then
		return CARD_TYPE.UG_BULL_SIZHA
	elseif self:IsBullBull(iCardList,iCardCount) then
		return CARD_TYPE.UG_BULL_BULL
	end
	if self:IsHaveNote(iCardList,iCardCount) == 1 then
		return CARD_TYPE.UG_BULL_ONE
	elseif self:IsHaveNote(iCardList,iCardCount) == 2 then
		return CARD_TYPE.UG_BULL_TWO
	elseif self:IsHaveNote(iCardList,iCardCount) == 3 then
		return CARD_TYPE.UG_BULL_THREE
	elseif self:IsHaveNote(iCardList,iCardCount) == 4 then
		return CARD_TYPE.UG_BULL_FOUR
	elseif self:IsHaveNote(iCardList,iCardCount) == 5 then
		return CARD_TYPE.UG_BULL_FIVE
	elseif self:IsHaveNote(iCardList,iCardCount) == 6 then
		return CARD_TYPE.UG_BULL_SIX
	elseif self:IsHaveNote(iCardList,iCardCount) == 7 then
		return CARD_TYPE.UG_BULL_SEVEN
	elseif self:IsHaveNote(iCardList,iCardCount) == 8 then
		return CARD_TYPE.UG_BULL_EIGHT
	elseif self:IsHaveNote(iCardList,iCardCount) == 9 then
		return CARD_TYPE.UG_BULL_NINE
	end
	return CARD_TYPE.UG_NO_POINT
end

function crazyLogic:GetTexasCardDesc( iCardType )
	local str = ""
	if iCardType == CARD_TEXAX_TYPE.TEXAX_TONG_HUA_SHUN then
		str = "同花顺"
	elseif iCardType == CARD_TEXAX_TYPE.TEXAX_TIE_ZHI then
		str = "四条"
	elseif iCardType == CARD_TEXAX_TYPE.TEXAX_HU_LU then
		str = "葫芦"
	elseif iCardType == CARD_TEXAX_TYPE.TEXAX_TONG_HUA then
		str = "同花"
	elseif iCardType == CARD_TEXAX_TYPE.TEXAX_SHUN_ZI then
		str = "顺子"
	elseif iCardType == CARD_TEXAX_TYPE.TEXAX_THREE_TIAO then
		str = "三条"
	elseif iCardType == CARD_TEXAX_TYPE.TEXAX_TWO_LONG then
		str = "两对"
	elseif iCardType == CARD_TEXAX_TYPE.TEXAX_ONE_LONG then
		str = "对子"
	-- elseif iCardType == CARD_TYPE.TEXAX_SINGLE then
	-- 	str = "单牌"
	end
	return str
end

function crazyLogic:GetTexasCardType( cbCardData, cbCardCount )
	if cbCardCount ~= CARDCOUNT then
		return 0
	end
	--扑克分析
	if self:IsSameHuaShun(cbCardData,cbCardCount) then
		return CARD_TEXAX_TYPE.TEXAX_TONG_HUA_SHUN
	elseif self:IsFourBomb(cbCardData,cbCardCount) then
		return CARD_TEXAX_TYPE.TEXAX_TIE_ZHI
	elseif self:IsHuLu(cbCardData,cbCardCount) then
		return CARD_TEXAX_TYPE.TEXAX_HU_LU
	elseif self:IsSameHua(cbCardData,cbCardCount) then
		return CARD_TEXAX_TYPE.TEXAX_TONG_HUA
	elseif self:IsShunZi(cbCardData,cbCardCount) then
		return CARD_TEXAX_TYPE.TEXAX_SHUN_ZI
	elseif self:IsThreeX(cbCardData,cbCardCount) then
		return CARD_TEXAX_TYPE.TEXAX_THREE_TIAO
	elseif self:IsTwoDouble(cbCardData,cbCardCount) then
		return CARD_TEXAX_TYPE.TEXAX_TWO_LONG
	elseif self:IsDouble(cbCardData,cbCardCount) then
		return CARD_TEXAX_TYPE.TEXAX_ONE_LONG
 	end
 	return CARD_TEXAX_TYPE.TEXAX_SINGLE
end

--得到手牌中最大的牌(含花色)
function crazyLogic:GetMaxCard( iCardList, iCardCount)
	local temp = 0
	local card = 0
	for i,v in pairs(iCardList) do
		if temp == 0 then
			temp = self:GetCardBulk(v)
			card = v
		else
			if temp < self:GetCardBulk(v) then
				temp = self:GetCardBulk(v)
				card = v
			elseif temp == self:GetCardBulk(v) then
				if self:GetCardHuaKind(card,true) < self:GetCardHuaKind(v,true) then
					temp = self:GetCardBulk(v)
					card = v
				end
			end
		end
	end
	return card
end
--得到手牌中最大的点数
function crazyLogic:GetMaxPoint( iCardList, iCardCount)
	if iCard == 0x00 then
		return 0
	end
	local tblCardList = table.copy(iCardList)
	self:SortCardList(tblCardList,iCardCount,enSortCardType.enDescend)
	local iMaxFirTemp = self:GetCardNum(tblCardList[0])
	if self:IsShunzi(iCardList, iCardCount) then
		if iMaxFirTemp == 14 and  self:GetCardNum(tblCardList[4]) == 5 then
			iMaxFirTemp = self:GetCardNum(tblCardList[4])
		elseif iMaxFirTemp == 14 then
			iMaxFirTemp = 14
		else
			iMaxFirTemp = self:GetCardNum(tblCardList[4])
		end
	else
		iMaxFirTemp = self:GetCardNum(tblCardList[4])
	end
	
	return iMaxFirTemp
end
--获取指定个数相同最大的牌 (含花色)
function crazyLogic:GetMaxCardByCount( iCardList,iCardCount,iSameCount )
	local card = {}
	local temp = {}
	for i,v in pairs(iCardList) do
		if temp[self:GetCardBulk(v)] == nil then
			temp[self:GetCardBulk(v)] = 0
		end
		if card[self:GetCardBulk(v)] == nil then
			card[self:GetCardBulk(v)] = {}
			-- card[self:GetCardBulk(v)][temp[self:GetCardBulk(v)] - 1] = 0
		end
		temp[self:GetCardBulk(v)] = temp[self:GetCardBulk(v)] + 1
		card[self:GetCardBulk(v)][temp[self:GetCardBulk(v)] - 1] = v
	end
	local cardComp = {}
	local iCompCount = 0
	local iTempCount = 0
	for i=0,17 do
		if temp[i] and temp == iSameCount then
			for k=0,iSameCount-1 do
				cardComp[iTempCount*iSameCount + k] = card[i][k]
				-- if cardComp[iTempCount*iSameCount + k] == nil then
				-- 	cardComp[iTempCount*iSameCount + k] = 0
				iCompCount = iCompCount + 1
				-- end
			end
			iTempCount = iTempCount + 1
		end
	end
	if iCompCount > 0 then
		return self:GetMaxCard(cardComp,iCompCount)
	end
	return 0
end
--比较牌型
function crazyLogic:CompareCardType( iFirstCardType, iSencondCardType,iFirstCard,iFirstCount,iSecondCard,iSecondCount)
	--比较牛牛牌型
	if iFirstCardType ~= iSencondCardType then
		if iFirstCardType - iSencondCardType > 0 then
			return 1
		else
			return 0
		end
	else
		local iFirstTexaCardType = self:GetTexasCardType(iFirstCard,iFirstCount)
		local iSecondTexaCardType = self:GetTexasCardType(iSecondCard,iSecondCount)
		if iFirstTexaCardType ~= iSecondTexaCardType then
			if iFirstTexaCardType - iSecondTexaCardType > 0 then
				return 1
			else
				return 0
			end
		end
		local MaxFir = self:GetMaxCard(iFirstCard,iFirstCount)
		local MaxSec = self:GetMaxCard(iSecondCard,iSecondCount)
		local compFir = table.copy(iFirstCard)
		local compSec = table.copy(iSecondCard)
		--散牌直接比较单张最大
		if iFirstCardType ~= CARD_TYPE.UG_NO_POINT then
			if iFirstTexaCardType == iSecondTexaCardType then
				if iFirstTexaCardType == CARD_TEXAX_TYPE.UG_BULL_SIZHA then
					local iMaxFirTemp = self:GetMaxCardByCount(iFirstCard,iFirstCount,4)
					local iMaxSecTemp = self:GetMaxCardByCount(iSecondCard,iSecondCount,4)
					if iMaxFirTemp > 0 and iMaxSecTemp > 0 then
						MaxFir = iMaxFirTemp
						MaxSec = iMaxSecTemp
					end
				elseif iFirstTexaCardType == CARD_TEXAX_TYPE.TEXAX_THREE_TIAO or iFirstTexaCardType == CARD_TEXAX_TYPE.TEXAX_HU_LU then
					local iMaxFirTemp = self:GetMaxCardByCount(iFirstCard,iFirstCount,3)
					local iMaxSecTemp = self:GetMaxCardByCount(iSecondCard,iSecondCount,3)
					if iMaxFirTemp > 0 and iMaxSecTemp > 0 then
						MaxFir = iMaxFirTemp
						MaxSec = iMaxSecTemp
					end
				elseif iFirstTexaCardType == CARD_TEXAX_TYPE.TEXAX_TONG_HUA_SHUN or FirstTexaCardType == CARD_TEXAX_TYPE.TEXAX_SHUN_ZI then
					local iMaxFirTemp = self:GetMaxPoint(iFirstCard,iFirstCount)
					local iMaxSecTemp = self:GetMaxPoint(iSecondCard,iSecondCount)
					if iMaxFirTemp > 0 and iMaxSecTemp > 0  then
						MaxFir = iMaxFirTemp
						MaxSec = iMaxSecTemp
					end
				elseif iFirstTexaCardType == CARD_TEXAX_TYPE.TEXAX_TWO_LONG then
					local iMaxFirTemp = self:GetMaxCardByCount(iFirstCard,iFirstCount,2)
					local iMaxSecTemp = self:GetMaxCardByCount(iSecondCard,iSecondCount,2)
					if iMaxFirTemp > 0 and iMaxSecTemp > 0 and self:GetCardBulk(iMaxFirTemp) ~= self:GetCardBulk(iMaxSecTemp) then
						MaxFir = iMaxFirTemp
						MaxSec = iMaxSecTemp
					elseif iMaxFirTemp > 0 and iMaxSecTemp > 0 and self:GetCardBulk(iMaxFirTemp) == self:GetCardBulk(iMaxSecTemp) then
						self:removeCardByValue(compFir, self:GetCardBulk(iMaxFirTemp))
						self:removeCardByValue(compSec, self:GetCardBulk(iMaxSecTemp))
						iMaxFirTemp = self:GetMaxCardByCount(compFir,table.nums(tblFir),2)
						iMaxSecTemp = self:GetMaxCardByCount(compSec,table.nums(tblSec),2)
						if iMaxFirTemp > 0 and iMaxSecTemp > 0 and self:GetCardBulk(iMaxFirTemp) ~= self:GetCardBulk(iMaxSecTemp) then
							MaxFir = iMaxFirTemp
							MaxSec = iMaxSecTemp
						elseif iMaxFirTemp > 0 and iMaxSecTemp > 0 and self:GetCardBulk(iMaxFirTemp) == self:GetCardBulk(iMaxSecTemp) then
							self:removeCardByValue(compFir, self:GetCardBulk(iMaxFirTemp))
							self:removeCardByValue(compSec, self:GetCardBulk(iMaxSecTemp))
							if self:CompareCardValue(compFir,compSec) == 1 then
								return 1
							elseif self:CompareCardValue(compFir,compSec) == 0 then
								return 0
							end
						end
					end
				elseif iFirstTexaCardType == CARD_TEXAX_TYPE.TEXAX_ONE_LONG then
					local iMaxFirTemp = self:GetMaxCardByCount(iFirstCard,iFirstCount,2)
					local iMaxSecTemp = self:GetMaxCardByCount(iSecondCard,iSecondCount,2)
					if iMaxFirTemp > 0 and iMaxSecTemp > 0 and self:GetCardBulk(iMaxFirTemp) ~= self:GetCardBulk(iMaxSecTemp) then
						MaxFir = iMaxFirTemp
						MaxSec = iMaxSecTemp
					elseif iMaxFirTemp > 0 and iMaxSecTemp > 0 and self:GetCardBulk(iMaxFirTemp) == self:GetCardBulk(iMaxSecTemp) then
						self:removeCardByValue(compFir, self:GetCardBulk(iMaxFirTemp))
						self:removeCardByValue(compSec, self:GetCardBulk(iMaxSecTemp))
						if self:CompareCardValue(compFir,compSec) == 1 then
							return 1
						elseif self:CompareCardValue(compFir,compSec) == 0 then
							return 0
						end
					end
				elseif iFirstTexaCardType == CARD_TEXAX_TYPE.TEXAX_SINGLE  then
					if self:CompareCardValue(compFir,compSec) == 1 then
						return 1
					elseif self:CompareCardValue(compFir,compSec) == 0 then
						return 0
					end
				end
			end
		end
		if self:GetCardBulk(MaxFir) ~= self:GetCardBulk(MaxSec) then
			if self:GetCardBulk(MaxFir) - self:GetCardBulk(MaxSec) > 0 then
				return 1
			else
				return 0
			end
		else
			if self:GetCardHuaKind(MaxFir,true) - self:GetCardHuaKind(MaxSec,true) > 0 then
				return 1
			else
				return 0
			end
		end
	end
end

function crazyLogic:removeCardByValue( cardList, cardValue )
	for i,v in ipairs(cardList) do
		if self:GetCardBulk(v) == cardValue then
			 table.remove(cardList,i)
		end
	end
end

function crazyLogic:CompareCardValue(iFirstCard, iSecondCard)
	self:SortCardList(iFirstCard, table.nums(iFirstCard), enSortCardType.enDescend)
	self:SortCardList(iSecondCard, table.nums(iSecondCard), enSortCardType.enDescend)
	for i,v in ipairs(iFirstCard) do
		if self:GetCardBulk(v) > self:GetCardBulk(iSecondCard[i]) then
			return 1
		elseif self:GetCardBulk(v) < self:GetCardBulk(iSecondCard[i]) then
			return 0
		end
	end
	return -1
end

return crazyLogic