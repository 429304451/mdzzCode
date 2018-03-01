local UpGradeLogic = class("UpGradeLogic")
local bit = require "bit"
UG_HUA_MASK			=		0xF0			
UG_VALUE_MASK		=		0x0F

--扑克花色
CARD_POKER_COLOR ={}
CARD_POKER_COLOR.UG_FANG_KUAI				= 0x00			--方块	0000 0000
CARD_POKER_COLOR.UG_MEI_HUA					= 0x10			--梅花	0001 0000
CARD_POKER_COLOR.UG_HONG_TAO				= 0x20			--红桃	0010 0000
CARD_POKER_COLOR.UG_HEI_TAO					= 0x30			--黑桃	0011 0000
CARD_POKER_COLOR.UG_NT_CARD					= 0x40			--主牌	0100 0000
CARD_POKER_COLOR.UG_ERROR_HUA				= 0xF0			--错误  1111 0000

--扑克出牌类型
CARD_TYPE = {}
CARD_TYPE.UG_ERROR_KIND						=	0				--错误
CARD_TYPE.UG_ONLY_ONE						=	1				--单张
CARD_TYPE.UG_DOUBLE							=	2				--对牌
CARD_TYPE.UG_STRAIGHT						=	4               --单顺， 顺子,5+张连续牌
CARD_TYPE.UG_THREE							=	7				--三张
CARD_TYPE.UG_THREE_ONE						=	8               --3 带 1
CARD_TYPE.UG_THREE_DOUBLE					=	10				-- 带1对
CARD_TYPE.UG_DOUBLE_SEQUENCE				=	12				--双顺  连对,2+个连续的对子
CARD_TYPE.UG_THREE_SEQUENCE					=	14				--三顺  连三张，2+个连续的三张
CARD_TYPE.UG_THREE_ONE_SEQUENCE				=	16              --连续的三带一  飞机带翅膀1
CARD_TYPE.UG_THREE_DOUBLE_SEQUENCE			=	20				--连续的三带对  飞机带翅膀2
CARD_TYPE.UG_FOUR_TWO						=	24				--四带二张
CARD_TYPE.UG_FOUR_TWO_DOUBLE				=	26				--四带二对
CARD_TYPE.UG_BOMB							=	39              --炸弹>=4張
CARD_TYPE.UG_KING_BOMB						=	41				--王炸(最大炸弹)

KING_COUNT = 2 				--王的个数

TOTAL_CARD_CNT = 54
local m_cbCardArray = 
{
	[0] = 0x01,[15] = 0x13,[30] = 0x25,[45] = 0x37,
	[1] = 0x02,[16] = 0x14,[31] = 0x26,[46] = 0x38,
	[2] = 0x03,[17] = 0x15,[32] = 0x27,[47] = 0x39,
	[3] = 0x04,[18] = 0x16,[33] = 0x28,[48] = 0x3A,
	[4] = 0x05,[19] = 0x17,[34] = 0x29,[49] = 0x3B,
	[5] = 0x06,[20] = 0x18,[35] = 0x2A,[50] = 0x3C,
	[6] = 0x07,[21] = 0x19,[36] = 0x2B,[51] = 0x3D,
	[7] = 0x08,[22] = 0x1A,[37] = 0x2C,[52] = 0x4E,
	[8] = 0x09,[23] = 0x1B,[38] = 0x2D,[53] = 0x4F,
	[9] = 0x0A,[24] = 0x1C,[39] = 0x31,
	[10] = 0x0B,[25] = 0x1D,[40] = 0x32,
	[11] = 0x0C,[26] = 0x21,[41] = 0x33,
	[12] = 0x0D,[27] = 0x22,[42] = 0x34,
	[13] = 0x11,[28] = 0x23,[43] = 0x35,
	[14] = 0x12,[29] = 0x24,[44] = 0x36,
}

function UpGradeLogic:ctor()

end

--按牌面数字从大到小排列扑克
function UpGradeLogic:SortCard( iCardList, bUp, iCardCount, bSysSort )
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
function UpGradeLogic:RemoveCard( iRemoveCard, iRemoveCount,iCardList,iCardCount )
	if iRemoveCount > iCardCount then
		return iCardList
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
	local iLeaveCard = table.copy(iCardList)
	iLeaveCard,iRecount = self:RemoveNummCard(iLeaveCard, iCardCount) --删除做了标记的牌
	if iDeleteCount ~= iRecount then
		return iCardList
	end
	iCardList = table.copy(iLeaveCard)
	return iCardList
end
--清除
function UpGradeLogic:RemoveNummCard( iCardList, iCardCount )
	local iRemoveCount = 0
	local iLeaveCount = 0
	local iTemp = {}
	for i=0,iCardCount-1 do
		if iCardList[i] ~= 0 then
			iTemp[iLeaveCount] = iCardList[i]
			iLeaveCount = iLeaveCount + 1
			-- iCardList[i - iRemoveCount] = iCardList[i]
		else
			iRemoveCount = iRemoveCount + 1
		end
	end
	return iTemp,iRemoveCount
end


--获取扑克数字
function UpGradeLogic:GetCardNum( iCard )
	return (math.floor(iCard%16))+1
 end

--获取扑克花色
function UpGradeLogic:GetCardHuaKind( iCard , bTrueHua)
 	local iHuaKind =  bit.band(iCard,UG_HUA_MASK)
	if not bTrueHua then
		iHuaKind = CARD_POKER_COLOR.UG_NT_CARD 
		return iHuaKind
	end
	return iHuaKind
 end

--获取扑克相对大小
function UpGradeLogic:GetCardBulk( iCard, bExtVal )
	if not iCard then
		return 0
	end
	if iCard == 0x4E or iCard == 0x4F then
		if bExtVal then
			return iCard-14
		else
			return iCard-62
		end
	end

	local iCardNum = self:GetCardNum(iCard)
	local iHuaKind = self:GetCardHuaKind(iCard, true)
	if iCardNum == 2 then
		if bExtVal then
			return  (iHuaKind/16+(15*4))
		else
			return 15
		end
	end

	if bExtVal then
		return (iHuaKind/16+(iCardNum*4))
	else
		return iCardNum
	end
end

--几张牌是否是相同数字
function UpGradeLogic:IsSameNumCard( iCardList, iCardCount,bExtVal)
	local temp = {}
	local nIndex = -1
	for i=0,iCardCount-1 do
		if temp[self:GetCardBulk(iCardList[i], false)] == nil then
			temp[self:GetCardBulk(iCardList[i], false)] = 0
		end
		temp[self:GetCardBulk(iCardList[i], false)] = temp[self:GetCardBulk(iCardList[i], false)]+1
	end
	for i=0,17 do
		if temp[i] ~=nil and temp[i] > 0 then
			nIndex = i
			break
		end
	end
	return (temp[nIndex]==iCardCount)
end

--获取指定张数牌个数
function UpGradeLogic:GetCountBySpecifyNumCount( iCardList, iCardCount, Num )
	local temp = {}
	local count = 0
	for i=0,iCardCount-1 do
		if temp[self:GetCardBulk(iCardList[i], bExtVal)] == nil then
			temp[self:GetCardBulk(iCardList[i], bExtVal)] = 0
		end
		temp[self:GetCardBulk(iCardList[i],false)] = temp[self:GetCardBulk(iCardList[i],false)]+1
	end
	for i=0,17 do
		if temp[i] ~= nil and temp[i] == Num then
			count = count + 1
		end
	end
	return count
end

--是否是顺子
function UpGradeLogic:IsSequence( iCardList, iCardCount,iCount )
	local temp = {}
	for i=0,iCardCount-1 do
		if temp[self:GetCardBulk(iCardList[i], false)] == nil then
			temp[self:GetCardBulk(iCardList[i], false)] = 0
		end
		temp[self:GetCardBulk(iCardList[i],false)] = temp[self:GetCardBulk(iCardList[i],false)] + 1
	end
	for i=0,14 do
		if temp[i] ~= nil and temp[i] ~= iCount then --非指定顺子
			return false
		end
	end
	local  len = iCardCount / iCount
	for i=0,14 do
		if temp[i] ~= nil then
			for j=i,i+len-1 do
				if temp[j] == nil or temp[j] ~= iCount or j >= 15 then
					return false
				end
			end
			return true
		end
	end
	return false
end

--提取1,2,3 or 4张相同数字的牌
function UpGradeLogic:TackOutBySepcifyCardNumCount( iCardList, iCardCount, iDoubleBuffer, bCardNum, bExtVal )
	local iCount = 0
	local temp = {}
	for i=0,iCardCount-1 do
		if temp[self:GetCardBulk(iCardList[i], false)] == nil then
			temp[self:GetCardBulk(iCardList[i], false)] = 0
		end
		temp[self:GetCardBulk(iCardList[i],false)] = temp[self:GetCardBulk(iCardList[i],false)] + 1
	end
	for i=0,17 do
		if temp[i] ~= nil and temp[i] == bCardNum then
			for j=0,iCardCount-1 do
				if iCardList[j] ~= nil and i == self:GetCardBulk(iCardList[j], false) then
					iDoubleBuffer[iCount] = iCardList[j]
					iCount = iCount + 1
				end
			end
		end
	end
	return iCount
end

--拆出（将手中的牌多的拆成少的）
function UpGradeLogic:TackOutMuchToFew( iCardList, iCardCount, iDoubleBuffer,iBufferCardCount, iCardMuch, iCardFew )
	iBufferCardCount = 1
	local count = 0
	local iBuffer = {}
	local iCount = self:TackOutBySepcifyCardNumCount(iCardList, iCardCount, iBuffer, iCardMuch, false)
	if iCount <= 0 then
		return count
	end
	for i=0,iCount-1,iCardMuch do
		for j=0,iCardFew-1 do
			iDoubleBuffer[iBufferCardCount] = iBuffer[i + j] 
			iBufferCardCount = iBufferCardCount + 1
		end
		count = count + 1
	end
	return count
end

--找出一个最小或最大的牌
function UpGradeLogic:GetBulkBySepcifyMinOrMax( iCardList, iCardCount, MinOrMax, bExtVal)
	local CardNum = self:GetCardBulk(iCardList[0], false)
	if MinOrMax == 1 then
		for i=1,iCardCount-1 do
			if iCardList[i] ~= nil and self:GetCardBulk(iCardList[i], false) < CardNum then
				CardNum = self:GetCardBulk(iCardList[i], false)
			end
		end
	elseif MinOrMax == 255 then
		for i=1,iCardCount-1 do
			if iCardList[i] ~= nil and self:GetCardBulk(iCardList[i], false) > CardNum then
				CardNum = self:GetCardBulk(iCardList[i], false)
			end
		end
	end
	return CardNum
end

--获取指定牌张数牌大小
function UpGradeLogic:GetBulkBySpecifyCardCount( iCardList, iCardCount, iCount )
	local temp = {}
	for i=0,iCardCount-1 do
		if iCardList[i] ~= nil and temp[self:GetCardBulk(iCardList[i], false)] == nil then
			temp[self:GetCardBulk(iCardList[i], false)] = 0
		end
		temp[self:GetCardBulk(iCardList[i],false)] = temp[self:GetCardBulk(iCardList[i],false)] + 1
	end
	for i=0,17 do
		if temp[i] ~= nil and temp[i] == iCount then
			return i
		end
	end
	return 0
end
--提取某张牌大小的张数
function UpGradeLogic:TackOutBySepcifyCardCount( iCardList, iCardCount, iResultCard,iResultCardCount, iCardNum, bCardNum )
	local iCount = 0
	local temp = {}
	for i=0,iCardCount-1 do
		if self:GetCardBulk(iCardList[i], false) == iCardNum then
			temp[iCount] = iCardList[i]
			iCount = iCount + 1
		end
	end
	if iCount >= bCardNum and iCount < 4 then
		for i=0,bCardNum-1 do
			iResultCard[iResultCardCount] = temp[i]
			iResultCardCount = iResultCardCount + 1
		end
		return true
	else
		return false
	end
end
--提取某张指定大小的牌
function UpGradeLogic:TackOutCardBySpecifyCardNum( iCardList, iCardCount, iBuffer, iBufferCardCount ,iCard, bExtVal)
	iBufferCardCount = 0
	local iCardNum = self:GetCardBulk(iCard, false)	--得到牌面点数
	if iCardNum <= 0 then
		iCardNum = self:GetBulkBySepcifyMinOrMax(iCardList, iCardCount, 1, false)
	end
	for i=0,iCardCount-1 do
		if self:GetCardBulk(iCardList[i], false) == iCardNum then
			iBuffer[iBufferCardCount] = iCardList[i]
			iBufferCardCount = iBufferCardCount + 1
		end
	end
	local Tmp = table.copy(iBuffer)
	if iBufferCardCount == 1 then
		for j=iCardNum+1,iCardNum+4 do
			local bFind = false
			for i=0,iCardCount-1 do
				
				if self:GetCardBulk(iCardList[i], false) == j and j < 15 then
					bFind = true
					Tmp[iBufferCardCount] = iCardList[i]
					iBufferCardCount = iBufferCardCount + 1
					break 
				end
			end
			if not bFind then
				break
			end
		end
		if iBufferCardCount == 5 then
			if self:IsStraight(Tmp, iBufferCardCount, bExtVal) then
				iBuffer = table.copy(Tmp)
			else
				iBufferCardCount = table.nums(iBuffer)
			end
		end
	elseif iBufferCardCount == 2 then
		Tmp = {}
		for i=1,2 do
			local iCardNumNext = iCardNum + i
			self:TackOutBySepcifyCardCount(iCardList,iCardCount,Tmp,table.nums(Tmp),iCardNumNext,iBufferCardCount)
		end
		if table.nums(Tmp) == 4 then
			for i=0,table.nums(Tmp)-1 do
				iBuffer[iBufferCardCount] = Tmp[i]
				iBufferCardCount = iBufferCardCount + 1
			end
		end
	elseif iBufferCardCount == 3 then
		Tmp = {}
		local iCardNumNext = iCardNum + 1
		self:TackOutBySepcifyCardCount(iCardList,iCardCount,Tmp,table.nums(Tmp),iCardNumNext,iBufferCardCount)
		if table.nums(Tmp) == iBufferCardCount then
			for i=0,table.nums(Tmp)-1 do
				iBuffer[iBufferCardCount] = Tmp[i]
				iBufferCardCount = iBufferCardCount + 1
			end
		end
	end
	return iBuffer
end
--查找大于iCard的单牌所在iCardList中的序号
function UpGradeLogic:GetSerialByMoreThanSpecifyCard( iCardList, iCardCount, iCard, iBaseCardCount, bExtValue)
	local Serial = 0
	local MaxCardNum = 255
	local BaseCardNum = self:GetCardBulk(iCard, false)
	for i=0,iCardCount-1,iBaseCardCount do
		local temp = self:GetCardBulk(iCardList[i], false)
		if temp < MaxCardNum and temp > BaseCardNum then
			MaxCardNum = temp
			Serial = i
			break
		end
	end
	return Serial
end

--获取指定顺子中牌点最小值(iSequence 代表顺子的牌数最多为
function UpGradeLogic:GetBulkBySpecifySequence( iCardList, iCardCount, iSequence )
	local temp = {}
	--for i=0,14 do
		--temp[i] = 0
	--end
	for i=0,iCardCount-1 do
		if temp[self:GetCardBulk(iCardList[i], bExtVal)] == nil then
			temp[self:GetCardBulk(iCardList[i], bExtVal)] = 0
		end
		temp[self:GetCardBulk(iCardList[i])] = temp[self:GetCardBulk(iCardList[i])] + 1
	end
	for i=0,14 do
		if temp[i] ~= nil and temp[i] == iSequence then
			return i
		end
	end
	return 0
end
--提取单个的三带0, 1 or 2 到底带的是几,由 iBaseCount-3 来决定
function UpGradeLogic:TackOutThreeX( iCardList, iCardCount, iBaseCard, iBaseCount, iResultCard, iResultCount,iValue)
	iResultCount =  0
	if iCardCount < iBaseCount then
		return {}
	end
	local iTempCard = {}
	local threecard = self:GetBulkBySpecifyCardCount(iBaseCard, iBaseCount, 3)
	local iCount = self:TackOutBySepcifyCardNumCount(iCardList, iCardCount, iTempCard, 3, false)
	if iCount > 0 then
		local byCardTemp = 0x00
		for i=0,iBaseCount-1 do
			if threecard == self:GetCardBulk(iBaseCard[i], false) then
				byCardTemp = iBaseCard[i]
				break
			end
		end
		if 0x00 == byCardTemp then
			return {}
		end
		local Step = self:GetSerialByMoreThanSpecifyCard(iTempCard, iCount, byCardTemp, 3, true)
		for i=0,2 do
			iResultCard[i] = iTempCard[Step+i]
		end
		if threecard >= self:GetBulkBySpecifyCardCount(iResultCard, 3, 3) then
			return {}
		end
	else
		return {}
	end
	--将原值移走
	local Tmp = {}
	local iTempCount = iCardCount
	Tmp = table.copy(iCardList)
	Tmp = self:RemoveCard(iResultCard,3,Tmp,iTempCount)
	iTempCount = iTempCount - 3
	local bFind = false
	local destCount = iBaseCount - 3
	if iValue == 1 or iValue == 2 then
		iCount=self:TackOutBySepcifyCardNumCount(Tmp,iTempCount,iTempCard,1)
		-- self:SortCard(iTempCount, {}, iCount,true)
		if iCount >= destCount then
			for i=0,destCount-1 do
				iResultCard[3+i] = iTempCard[i]
			end
			iResultCount = iBaseCount
			bFind = true
		end
		if not bFind then
			--拆对补单
			iCount = self:TackOutBySepcifyCardNumCount(Tmp,iTempCount,iTempCard,2)
			if iCount >= destCount then
				for i=0,destCount-1 do
					iResultCard[3+i] = iTempCard[i]
				end
				iResultCount = iBaseCount
				bFind = true
			end
		end
		if not bFind then
			--拆三张来补单
			iCount = self:TackOutBySepcifyCardNumCount(Tmp,iTempCount,iTempCard,3)
			if iCount >= 3 then
				for i=0,destCount-1 do
					iResultCard[3+i] = iTempCard[i]
				end
				iResultCount = iBaseCount
			end
		end
	elseif iValue == 3 then
		iCount = self:TackOutBySepcifyCardNumCount(Tmp,iTempCount,iTempCard,2)
		if iCount > 0 then
			for i=0,destCount-1 do
					iResultCard[3+i] = iTempCard[i]
				end
			iResultCount = iBaseCount
			bFind = true
		end
		if not bFind then
			--拆三张来补单牌
			iCount = self:TackOutBySepcifyCardNumCount(Tmp,iTempCount,iTempCard,3)
			if iCount >= 3 then
				for i=0,destCount-1 do
					iResultCard[3+i] = iTempCard[i]
				end
				iResultCount = iBaseCount
			end
		end
	else
		iResultCount = 0
	end
	if iResultCount == iBaseCount then
		return iResultCard
	end
	iResultCount = 0
	return {}
end

--查询用户手中炸弹数
function UpGradeLogic:GetBombCount( iCardList, iCardCount, iNumCount, bExtVal )
	local iCount = 0
	local temp = {}

	for i=0,iCardCount-1 do
		if temp[self:GetCardBulk(iCardList[i],false)] == nil  then
			temp[self:GetCardBulk(iCardList[i],false)] = 0
		end
		temp[self:GetCardBulk(iCardList[i],false)] = temp[self:GetCardBulk(iCardList[i],false)] + 1
	end
	for i=0,15 do
		if temp[i] ~= nil and temp[i] >= iNumCount then
			iCount = iCount + 1
		end
	end
	return iCount
end

--提取所有炸弹为提反单顺，双顺，三顺做准备
function UpGradeLogic:TackOutAllBomb( iCardList, iCardCount,iResultCard,iResultCardCount,iNumCount)
	iResultCard = {}
	iResultCardCount = 0
	local bCardBuffer = {}
	local bombcount = self:GetBombCount(iCardList, iCardCount, 4, false)
	if bombcount < 0 then
		return {}
	end
	for i=iNumCount,8 do
		local count = self:TackOutBySepcifyCardNumCount(iCardList, iCardCount, bCardBuffer, i, false)
		if count > 0 then
			for i=0,count-1 do
				iResultCard[iResultCardCount] = bCardBuffer[i]
				iResultCardCount = iResultCardCount + 1
			end
			break
		end
	end
	return iResultCard
end

--得到顺子的起始位置
function UpGradeLogic:GetSequenceStartPostion( iCardList, iCardCount, xSequence)
	local temp = {}
	local Postion = 0
	for i=0,iCardCount-1 do
		if temp[self:GetCardBulk(iCardList[i],false)] == nil  then
			temp[self:GetCardBulk(iCardList[i],false)] = 0
		end
		temp[self:GetCardBulk(iCardList[i],false)] = temp[self:GetCardBulk(iCardList[i],false)] + 1
	end
	for i=0,17 do
		if temp[i] ~= nil and temp[i] == xSequence then
			return i
		end
	end
	return Postion
end

--重写提取单张的顺子,连对 or 连三
function UpGradeLogic:TackOutSequence( iCardList, iCardCount, iBaseCard, iBaseCount, iResultCard, iResultCount,xSequence,bNoComp)
	iResultCount = 0
	local iTack = {}
	local iTackCount = iCardCount
	iTack = table.copy(iCardList)
	local iBuffer = {}
	local iBufferCount = 0
	local iBaseStart = 0
	local iDestStart = 0
	local iDestEnd = 0
	local iSequenceLen = iBaseCount
	local temp = {}
	
	local num = 0
	
	iBuffer = self:TackOutAllBomb(iTack,iTackCount,iBuffer,iBufferCount,4)
	iBufferCount = table.nums(iBuffer)
	iTack = self:RemoveCard(iBuffer,iBufferCount,iTack,iTackCount)
	iTackCount = iTackCount - iBufferCount
	self:SortCard(iTack, {}, iTackCount,true)
	for i=0,iTackCount-1 do
		if temp[self:GetCardBulk(iTack[i],false)] == nil  then
			temp[self:GetCardBulk(iTack[i],false)] = 0
		end
		temp[self:GetCardBulk(iTack[i],false)] = temp[self:GetCardBulk(iTack[i],false)] + 1
	end
	if xSequence == 1 then
		iSequenceLen = iBaseCount
		if not bNoComp then
			iBaseStart = self:GetSequenceStartPostion(iBaseCard,iBaseCount,1)
		else
			iBaseStart = 2
		end
		for i=iBaseStart+1,14 do
			if temp[i] ~= nil and temp[i] >= 1 then
				if iDestStart == 0 then
					iDestStart = i
				end
				iDestEnd = iDestEnd + 1
				if iDestEnd == iSequenceLen then
					break
				end
			else
				iDestStart = 0
				iDestEnd = 0
			end
		end
		if iDestEnd ~= iSequenceLen then
			iResultCard = {}
			return iResultCard
		end
		for j=0,iTackCount-1 do
			if self:GetCardBulk(iTack[j], false) == iDestStart then
				iResultCard[iResultCount] = iTack[j]
				iResultCount = iResultCount + 1
				iDestStart = iDestStart + 1
				iDestEnd = iDestEnd - 1
			end
			if iDestEnd == 0 then
				return iResultCard
			end
		end
	elseif xSequence == 2 then
		iSequenceLen = iBaseCount / 2
		if not bNoComp then
			iBaseStart = self:GetSequenceStartPostion(iBaseCard,iBaseCount,2)
		else
			iBaseStart = 2
		end
		for i= iBaseStart + 1,14 do
			if temp[i] ~= nil and temp[i] >= 2 then
				if iDestStart == 0 then
					iDestStart = i
				end
				iDestEnd = iDestEnd + 1
				if iDestEnd == iSequenceLen then
					break
				end
			else
				iDestStart = 0
				iDestEnd = 0
			end
		end
		if iDestEnd ~= iSequenceLen then
			iResultCard = {}
			return iResultCard
		end
		num = 0
		for j=0,iTackCount-1 do
			if self:GetCardBulk(iTack[j], false) == iDestStart then
				iResultCard[iResultCount] = iTack[j]
				iResultCount = iResultCount + 1
				num = num + 1
			end
			if num == 2 then
				num = 0
				iDestStart = iDestStart + 1
				iDestEnd = iDestEnd - 1
				if iDestEnd == 0 then
					return iResultCard
				end
			end
		end
	elseif xSequence == 3 then
		iSequenceLen = iBaseCount / 3
		if not bNoComp then
			iBaseStart = self:GetSequenceStartPostion(iBaseCard,iBaseCount,3)
		else
			iBaseStart = 2
		end
		for i = iBaseStart + 1,14 do
			if temp[i] ~= nil and temp[i] >= 3 then
				if iDestStart == 0 then
					iDestStart = i
				end
				iDestEnd = iDestEnd + 1
				if iDestEnd == iSequenceLen then
					break
				end
			else
				iDestStart = 0
				iDestEnd = 0
			end
		end
		if iDestEnd ~= iSequenceLen then
			iResultCard = {}
			return iResultCard
		end
		num = 0
		for j=0,iTackCount-1 do
			if self:GetCardBulk(iTack[j], false) == iDestStart then
				iResultCard[iResultCount] = iTack[j]
				iResultCount = iResultCount + 1
				num = num + 1
				if num == 3 then
					num = 0
					iDestStart = iDestStart + 1
					iDestEnd = iDestEnd - 1
					if iDestEnd == 0 then
						return iResultCard
					end
				end
			end
		end
	end
	iResultCard = {}
	return iResultCard
end

--提取指定三条带顺
function UpGradeLogic:TrackOut3XSequence( iCardList,iCardCount,iBaseCard,iBaseCount,iResultCard,iResultCardCount,xValue )
	iResultCard = {}
	iResultCardCount = 0
	if iCardCount < iBaseCount then
		iResultCard = {}
		return iResultCard
	end
	local tmpBaseCard = {}
	local tmpbaseCardCount = 0
	local destCardCount = 0
	tmpbaseCardCount = self:TackOutBySepcifyCardNumCount(iBaseCard, iBaseCount, tmpBaseCard, 3, false)
	if tmpbaseCardCount < 6 then
		iResultCard = {}
		return iResultCard
	end
	iResultCard = self:TackOutSequence(iCardList, iCardCount, tmpBaseCard, tmpbaseCardCount, iResultCard, iResultCardCount, 3, false)
	if table.nums(iResultCard) <= 0  then
		iResultCard = {}
		return iResultCard
	end
	local TMP = {}
	local TmpCount = iCardCount
	TMP = table.copy(iCardList)
	iResultCardCount = table.nums(iResultCard)
	TMP = self:RemoveCard(iResultCard, iResultCardCount, TMP, TmpCount)
	TmpCount = TmpCount - iResultCardCount
	destCardCount = iBaseCount - iResultCardCount
	if xValue == 1 or xValue == 2 then
		tmpbaseCardCount = self:TackOutBySepcifyCardNumCount(TMP, TmpCount, tmpBaseCard, 1, false)
		if tmpbaseCardCount >= destCardCount then
			for i=0,destCardCount-1 do
				iResultCard[iResultCardCount] = tmpBaseCard[i]
				iResultCardCount = iResultCardCount + 1
			end
		else
			for i=0,tmpbaseCardCount-1 do
				iResultCard[iResultCardCount] = tmpBaseCard[i]
				iResultCardCount = iResultCardCount + 1
			end
			destCardCount = destCardCount - tmpbaseCardCount
			tmpbaseCardCount = self:TackOutBySepcifyCardNumCount(TMP, TmpCount, tmpBaseCard, 2, false)
			if tmpbaseCardCount >= destCardCount then
				for i=0,destCardCount-1 do
					iResultCard[iResultCardCount] = tmpBaseCard[i]
					iResultCardCount = iResultCardCount + 1
				end
			else
				for i=0,tmpbaseCardCount-1 do
					iResultCard[iResultCardCount] = tmpBaseCard[i]
					iResultCardCount = iResultCardCount + 1
				end
				destCardCount = destCardCount - tmpbaseCardCount
				tmpbaseCardCount = self:TackOutBySepcifyCardNumCount(TMP, TmpCount, tmpBaseCard, 3, false)
				if tmpbaseCardCount >= destCardCount then
					for i=0,destCardCount-1 do
						iResultCard[iResultCardCount] = tmpBaseCard[i]
						iResultCardCount = iResultCardCount + 1
					end
				end
			end
		end
	elseif xValue == 3 then
		tmpbaseCardCount = self:TackOutBySepcifyCardNumCount(TMP, TmpCount, tmpBaseCard, 2, false)
		if tmpbaseCardCount >= destCardCount then
			for i=0,destCardCount-1 do
				iResultCard[iResultCardCount] = tmpBaseCard[i]
				iResultCardCount = iResultCardCount + 1
			end
		else
			for i=0,tmpbaseCardCount-1 do
				iResultCard[iResultCardCount] = tmpBaseCard[i]
				iResultCardCount = iResultCardCount + 1
			end
			destCardCount = destCardCount - tmpbaseCardCount
			self:TackOutMuchToFew(TMP, TmpCount, tmpBaseCard, tmpbaseCardCount, 3, 2)
			if tmpbaseCardCount >= destCardCount then
				for i=0,destCardCount-1 do
					iResultCard[iResultCardCount] = tmpBaseCard[i]
					iResultCardCount = iResultCardCount + 1
				end
			end
		end
	end
	if iResultCardCount == iBaseCount then
		return iResultCard
	end
	iResultCardCount = 0
	iResultCard = {}
	return iResultCard
end

--是否是单牌
function UpGradeLogic:IsOnlyOne( iCardList, iCardCount,bExtVal)
	return iCardCount == 1
end
--是否是对子
function UpGradeLogic:IsDouble( iCardList, iCardCount,bExtVal)
	if iCardCount ~= 2 then
		return false
	end
	return self:IsSameNumCard(iCardList, iCardCount, false)
end
--是否是3带0,1or2,or3
function UpGradeLogic:IsThreeX( iCardList, iCardCount, iX, bExtVal)
	if iCardCount > 5 or iCardCount < 3 then
		return false
	end
	if self:GetCountBySpecifyNumCount(iCardList,iCardCount, 3) ~= 1 then
		return false
	end
	if iX == 0 then
		return iCardCount == 3
	elseif iX == 1 then
		return iCardCount == 4
    elseif iX == 2 then
    	return iCardCount == 5
    elseif iX == 3 then
    	return self:GetCountBySpecifyNumCount(iCardList,iCardCount,2)==1
	end
end
--王炸
function UpGradeLogic:IsKingBomb( iCardList, iCardCount )
	if iCardCount ~= KING_COUNT then
		return false
	end
	for i=0,iCardCount-1 do
		if iCardList[i] ~= 0x4e and iCardList[i]~= 0x4f then
			return false
		end
	end
	return true
end
--炸弹
function UpGradeLogic:IsBomb( iCardList,iCardCount,bExtVal )
	if iCardCount < 4 then
		return false
	end
	return self:IsSameNumCard(iCardList, iCardCount, bExtVal)
end
--四带2对或2单
function UpGradeLogic:IsFourX( iCardList,iCardCount,iX )
	if iCardCount > 8 or iCardCount < 4 then
		return false
	end
	if self:GetCountBySpecifyNumCount(iCardList, iCardCount, 4) ~= 1 then
		return false
	end
	if iX == 0 then
		return iCardCount == 4
	elseif iX == 1 then
		return iCardCount == 5
    elseif iX == 2 then
    	return iCardCount == 6
    elseif iX == 3 then
    	return (iCardCount == 6 and 1 == self:GetCountBySpecifyNumCount(iCardList,iCardCount,2))
	elseif iX == 4 then
		return (iCardCount == 8 and 2 == self:GetCountBySpecifyNumCount(iCardList,iCardCount,2))
	end
	return false
end
--是否是顺子指定张数
function UpGradeLogic:IsStraight( iCardList,iCardCount,bExtVal )
	if iCardCount < 5 then
		return false
	end
	return self:IsSequence(iCardList,iCardCount,1)
end
--是否是连对
function UpGradeLogic:IsDoubleSequence( iCardList,iCardCount,bExtVal  )
	if iCardCount%2 ~= 0 or iCardCount < 6 then
		return false
	end
	return self:IsSequence(iCardList,iCardCount,2)
end
--连的三带
function UpGradeLogic:IsThreeXSequence( iCardList, iCardCount, iSeqX, bExtVal )
	if iCardCount < 6 then
		return false
	end
	local temp = {}
	local TackOutCount = 0
	if iSeqX == 0 then
		if iCardCount%3 ~= 0 then
			return false
		end
		return self:IsSequence(iCardList, iCardCount, 3)
	elseif iSeqX == 1 then
		TackOutCount=self:TackOutBySepcifyCardNumCount(iCardList,iCardCount,temp,3)
		if TackOutCount > 0 and TackOutCount / 3 *4 == iCardCount then
			return self:IsSequence(temp, TackOutCount, 3)
		end
	elseif iSeqX == 2 then
		TackOutCount=self:TackOutBySepcifyCardNumCount(iCardList,iCardCount,temp,3)
		if TackOutCount > 0 and TackOutCount / 3 *5 == iCardCount then
			return self:IsSequence(temp, TackOutCount, 3)
		end
	elseif iSeqX == 3 then
		TackOutCount=self:TackOutBySepcifyCardNumCount(iCardList,iCardCount,temp,3)
		if TackOutCount > 0 and TackOutCount / 3 *5 == iCardCount and self:GetCountBySpecifyNumCount(iCardList, iCardCount, 2) == TackOutCount/3 then
			return self:IsSequence(temp, TackOutCount, 3)
		end
	end
	return false
end

--获得牌型
function UpGradeLogic:GetCardShape( iCardList, iCardCount, bExtVal)
	if self:IsOnlyOne(iCardList, iCardCount, bExtVal) then
		return CARD_TYPE.UG_ONLY_ONE
	end
	if self:IsDouble(iCardList, iCardCount, bExtVal) then
		return CARD_TYPE.UG_DOUBLE
	end
	if self:IsThreeX(iCardList, iCardCount, 0, bExtVal) then
		return CARD_TYPE.UG_THREE
	end
	if self:IsKingBomb(iCardList, iCardCount) then
		return CARD_TYPE.UG_KING_BOMB
	end
	if self:IsBomb(iCardList, iCardCount, bExtVal) then
		return CARD_TYPE.UG_BOMB
	end
	if self:IsThreeX(iCardList, iCardCount, 3, bExtVal) then
		return CARD_TYPE.UG_THREE_DOUBLE
	end
	if self:IsThreeX(iCardList, iCardCount, 1, bExtVal) then
		return CARD_TYPE.UG_THREE_ONE
	end
	if self:IsFourX(iCardList, iCardCount, 4) then
		return CARD_TYPE.UG_FOUR_TWO_DOUBLE
	end
	if self:IsFourX(iCardList, iCardCount, 2) then
		return CARD_TYPE.UG_FOUR_TWO
	end
	if self:IsStraight(iCardList, iCardCount, bExtVal) then
		return CARD_TYPE.UG_STRAIGHT
	end
	if self:IsDoubleSequence(iCardList, iCardCount, bExtVal) then
		return CARD_TYPE.UG_DOUBLE_SEQUENCE
	end
	if self:IsThreeXSequence(iCardList, iCardCount, 3, bExtVal) then
		return CARD_TYPE.UG_THREE_DOUBLE_SEQUENCE
	end
	if self:IsThreeXSequence(iCardList, iCardCount, 1, bExtVal) then
		return CARD_TYPE.UG_THREE_ONE_SEQUENCE
	end
	if self:IsThreeXSequence(iCardList, iCardCount, 0, bExtVal) then
		return CARD_TYPE.UG_THREE_SEQUENCE
	end
	return CARD_TYPE.UG_ERROR_KIND
end

--是否可以出牌:1、要出的牌，2，要压的牌 3、手中的牌
function UpGradeLogic:CanOutCard( iOutCard, iOutCount,  iBaseCard, iBaseCount, HandCard, iHandCount, bFirstOut )
	local iOutCardShape = self:GetCardShape(iOutCard, iOutCount, false)
	if iOutCardShape == CARD_TYPE.UG_ERROR_KIND then
		return false
	end
	if bFirstOut then
		return true
	end
	local iBaseCardShape = self:GetCardShape(iBaseCard, iBaseCount, false)--要压的牌型
	if iBaseCardShape > iOutCardShape then
		return false
	end
	if iBaseCardShape < iOutCardShape then
		if CARD_TYPE.UG_BOMB <= iOutCardShape then
			return true
		end
		return false
	end
	--处理牌型一致
	if iBaseCardShape == CARD_TYPE.UG_ONLY_ONE or iBaseCardShape == CARD_TYPE.UG_DOUBLE or iBaseCardShape == CARD_TYPE.UG_THREE then
		return self:GetBulkBySepcifyMinOrMax(iBaseCard, iBaseCount, 1, false) < self:GetBulkBySepcifyMinOrMax(iOutCard, iOutCount, 1, false)
	elseif iBaseCardShape == CARD_TYPE.UG_BOMB then
		if iBaseCount > iOutCount  then
			return false
		end
		if iBaseCount == iOutCount then
			return self:GetBulkBySepcifyMinOrMax(iBaseCard, iBaseCount, 1) < self:GetBulkBySepcifyMinOrMax(iOutCard, iOutCount, 1)
		end
	elseif iBaseCardShape == CARD_TYPE.UG_STRAIGHT or iBaseCardShape == CARD_TYPE.UG_DOUBLE_SEQUENCE or iBaseCardShape == CARD_TYPE.UG_THREE_SEQUENCE then
		if iBaseCount ~= iOutCount then
			return false
		end
		return self:GetBulkBySepcifyMinOrMax(iBaseCard, iBaseCount, 1) < self:GetBulkBySepcifyMinOrMax(iOutCard, iOutCount, 1)
	elseif iBaseCardShape == CARD_TYPE.UG_THREE_ONE or iBaseCardShape == CARD_TYPE.UG_THREE_DOUBLE then
		return self:GetBulkBySpecifyCardCount(iBaseCard, iBaseCount,3) < self:GetBulkBySpecifyCardCount(iOutCard, iOutCount,3)
	elseif iBaseCardShape == CARD_TYPE.UG_FOUR_TWO or iBaseCardShape == CARD_TYPE.UG_FOUR_TWO_DOUBLE then
		return self:GetBulkBySpecifyCardCount(iBaseCard, iBaseCount,4) < self:GetBulkBySpecifyCardCount(iOutCard, iOutCount,4)
	elseif iBaseCardShape == CARD_TYPE.UG_THREE_ONE_SEQUENCE or iBaseCardShape == CARD_TYPE.UG_THREE_DOUBLE_SEQUENCE then
		if iBaseCount ~= iOutCount then
			return false
		end
		return (self:GetBulkBySpecifySequence(iBaseCard, iBaseCount,3) < self:GetBulkBySpecifyCardCount(iOutCard, iOutCount,3))
	end
	return false
end

--自动找出可以出的牌
function UpGradeLogic:AutoOutCard( iHandCard, iHandCardCount, iBaseCard, iBaseCardCount, iResultCard, iResultCardCount, bFirstOut )
	iResultCard = {}
	local iResultCardCount = 0
	if bFirstOut then
		iResultCard = self:TackOutCardBySpecifyCardNum(iHandCard, iHandCardCount, iResultCard, iResultCardCount, iHandCard[iHandCardCount-1],false)
	else -- 跟牌
		iResultCard = self:TackOutCardMoreThanLast(iHandCard, iHandCardCount, iBaseCard, iBaseCardCount, iResultCard, iResultCardCount, false)
		if not self:CanOutCard(iResultCard, table.nums(iResultCard), iBaseCard, iBaseCardCount, iHandCard, iHandCardCount) then
			iResultCardCount = 0
			iResultCard = {} 
			return iResultCard
		end
	end
	return iResultCard
end

--比较单张
function UpGradeLogic:CompareOnlyOne( iFirstCard, iNextCard )
	return self:GetCardBulk(iFirstCard,false) < self:GetCardBulk(iNextCard,false)
end

--拆大
function UpGradeLogic:TackOutCardByNoSameShape( iCardList, iCardCount, iResultCard, iResultCardCount, iBaseCard, iBaseCardCount )
	iResultCard = {}
	iResultCardCount = 0
	local temp = {}
	local t = self:GetCardBulk(iBaseCard[0], false)
	for i=0,iCardCount-1 do
		if temp[self:GetCardBulk(iCardList[i], false)] == nil then
			temp[self:GetCardBulk(iCardList[i], false)] = 0
		end
		temp[self:GetCardBulk(iCardList[i], false)] = temp[self:GetCardBulk(iCardList[i], false)]+1
	end
	for i=0,17 do
		if temp[i] ~= nil and temp[i] < 4 and temp[i] > iBaseCardCount and i > t then
			for j=0,iCardCount-1 do
				if self:GetCardBulk(iCardList[j], false) == i then
					iResultCard[iResultCardCount] = iCardList[j]
					iResultCardCount = iResultCardCount + 1
					if iResultCardCount == iBaseCardCount then
						return iResultCard
					end
				end
			end
		end
	end
	iResultCard = {}
	return iResultCard
end
--提取指定牌返回找到牌個數
function UpGradeLogic:TackOutBySpecifyCard( iCardList, iCardCount, bCardBuffer, iResultCardCount, bCard)
	iResultCard = {}
	iResultCardCount = 0
	for i=0,iCardCount-1 do
		if self:GetCardBulk(iCardList[i],false) == bCard  then
			bCardBuffer[iResultCardCount] = iCardList[i]
			iResultCardCount = iResultCardCount + 1
		end
	end
	return iResultCardCount
end

--提取炸弹
function UpGradeLogic:TackOutBomb( iCardList, iCardCount, iResultCard, iResultCardCount, iNumCount )
	iResultCard = {}
	iResultCardCount = 0
	local bCardBuffer = {}
	local bombcount = self:GetBombCount(iCardList, iCardCount, 4, false)
	if bombcount < 0 then
		iResultCard = {}
		return iResultCard
	end

	for i=iNumCount, 8 do
		local count = self:TackOutBySepcifyCardNumCount(iCardList, iCardCount, bCardBuffer, i, false)
		if count > 0 then
			for j=0,i-1 do
				iResultCard[iResultCardCount] = bCardBuffer[j]
				iResultCardCount = iResultCardCount + 1
			end
			break
		end
	end
	if iResultCardCount == 0 then
		iResultCard = self:TackOutKingBomb(iCardList,iCardCount,iResultCard,iResultCardCount)
	end
	return iResultCard
end

--提取王炸
function UpGradeLogic:TackOutKingBomb( iCardList, iCardCount, iResultCard, iResultCardCount )
	iResultCard = {}
	iResultCardCount = 0
	local bCardBuf = {}
	local kingcount = 0
	local SingKing = KING_COUNT / 2
	local count = self:TackOutBySpecifyCard(iCardList, iCardCount, bCardBuf, kingcount, self:GetCardBulk(0x4e,false))
	kingcount = table.nums(bCardBuf)
	if count ~= SingKing then
		iResultCard = {}
		return iResultCard
	end
	for i=0,count-1 do
		iResultCard[i] = bCardBuf[i]
	end
	bCardBuf = {}
	count = self:TackOutBySpecifyCard(iCardList, iCardCount, bCardBuf, kingcount, self:GetCardBulk(0x4f,false))
	kingcount = table.nums(bCardBuf)
	if count ~= SingKing then
		iResultCard = {}
		return iResultCard
	end
	for i=0,count-1 do
		iResultCard[SingKing + i] = bCardBuf[i]
	end
	return iResultCard
end

--直接提取比桌面上大的牌型
function UpGradeLogic:TackOutMoreThanLastShape( iCardList, iCardCount, iResultCard, iResultCardCount, iBaseCard , iBaseCardCount )
	iResultCardCount = 0
	iResultCard = self:TackOutBomb(iCardList, iCardCount, iResultCard, iResultCardCount, 4)
	return iResultCard
end

--查找一个比当前大的
function UpGradeLogic:TackOutCardMoreThanLast( iHandCard, iHandCardCount, iBaseCard, iBaseCardCount, iResultCard, iResultCardCount, bExtVal)
	local iTempCard = {}
	iResultCard = {}
	iResultCardCount = 0
	local iBaseShape = self:GetCardShape(iBaseCard, iBaseCardCount) --桌面上牌的牌型
	if iBaseShape == CARD_TYPE.UG_ONLY_ONE or iBaseShape == CARD_TYPE.UG_DOUBLE or iBaseShape == CARD_TYPE.UG_THREE or iBaseShape == CARD_TYPE.UG_BOMB then
		local iCount = self:TackOutBySepcifyCardNumCount(iHandCard, iHandCardCount, iTempCard, iBaseCardCount, false)
		if iCount > 0 then
			local Step = self:GetSerialByMoreThanSpecifyCard(iTempCard, iCount, iBaseCard[0], iBaseCardCount, false)
			for i=0,iBaseCardCount-1 do
				iResultCard[i] = iTempCard[Step+i]
			end
			if self:CompareOnlyOne(iBaseCard[0], iResultCard[0]) then
				iResultCardCount = iBaseCardCount
				return iResultCard
			else
				iResultCardCount = 0
			end
		end
	elseif iBaseShape == CARD_TYPE.UG_THREE_ONE then
		iResultCard = self:TackOutThreeX(iHandCard, iHandCardCount, iBaseCard, iBaseCardCount, iResultCard, iResultCardCount, 1)
		if table.nums(iResultCard) > 0 then
			return iResultCard
		end
	elseif iBaseShape == CARD_TYPE.UG_THREE_DOUBLE then
		iResultCard = self:TackOutThreeX(iHandCard, iHandCardCount, iBaseCard, iBaseCardCount, iResultCard, iResultCardCount,3)
		if table.nums(iResultCard) > 0 then
			return iResultCard
		end
	elseif iBaseShape == CARD_TYPE.UG_STRAIGHT then
		iResultCard = self:TackOutSequence(iHandCard, iHandCardCount, iBaseCard, iBaseCardCount, iResultCard, iResultCardCount,1,false)
		if table.nums(iResultCard) > 0 then
			return iResultCard
		end
	elseif iBaseShape == CARD_TYPE.UG_DOUBLE_SEQUENCE then
		iResultCard = self:TackOutSequence(iHandCard, iHandCardCount, iBaseCard, iBaseCardCount, iResultCard, iResultCardCount,2,false)
		if table.nums(iResultCard) > 0 then
			return iResultCard
		end
	elseif iBaseShape == CARD_TYPE.UG_THREE_SEQUENCE then
		iResultCard = self:TackOutSequence(iHandCard, iHandCardCount, iBaseCard, iBaseCardCount, iResultCard, iResultCardCount,3,false)
		if table.nums(iResultCard) > 0 then
			return iResultCard
		end
	elseif iBaseShape == CARD_TYPE.UG_THREE_ONE_SEQUENCE then
		iResultCard = self:TrackOut3XSequence(iHandCard, iHandCardCount, iBaseCard, iBaseCardCount, iResultCard, iResultCardCount,1)
		if table.nums(iResultCard) > 0 then
			return iResultCard
		end
	elseif iBaseShape == CARD_TYPE.UG_THREE_DOUBLE_SEQUENCE then
		iResultCard = self:TrackOut3XSequence(iHandCard, iHandCardCount, iBaseCard, iBaseCardCount, iResultCard, iResultCardCount,3)
		if table.nums(iResultCard) > 0 then
			return iResultCard
		end
	else 
		iResultCardCount = 0
	end
	--没找到同牌型的大牌，就找大一点的牌型
	if iResultCardCount == 0 then
		iResultCard = {}
		if iBaseShape == CARD_TYPE.UG_ONLY_ONE or iBaseShape == CARD_TYPE.UG_DOUBLE then
			iResultCard = self:TackOutCardByNoSameShape(iHandCard, iHandCardCount, iResultCard, iResultCardCount, iBaseCard, iBaseCardCount)
			if table.nums(iResultCard) > 0 then
				return iResultCard
			end
		elseif iBaseShape == CARD_TYPE.UG_BOMB then
			iResultCard = self:TackOutKingBomb(iHandCard, iHandCardCount, iResultCard, iResultCardCount)
			if table.nums(iResultCard) > 0 then
				return iResultCard
			end
		else
			iResultCardCount = 0
		end
	end
	if iResultCardCount == 0 then
		iResultCard = {}
		iResultCard =  self:TackOutMoreThanLastShape(iHandCard, iHandCardCount, iResultCard, iResultCardCount, iBaseCard, iBaseCardCount)
	end
	return iResultCard
end

--获取初始的没有排序的所有牌
function UpGradeLogic:GetInitNoSortCard( iCard,iCardCount,bHaveKing)
	local step
	if bHaveKing then
		step = 54
	else
		step = 52
	end
	for i=0,iCardCount-1 do
		iCard[i] = m_cbCardArray[i]
	end
	return iCard
end

--获取指定的数的张数
function UpGradeLogic:GetCountBySpecifyCard( iCardList, iCardCount,iResultCard, iResultCount, Num, iCount )
	local temp = {}
	local count = 0
	for i=0,iCardCount-1 do
		if self:GetCardBulk(iCardList[i], false) == Num  then
			temp[count] = iCardList[i] 
			count = count + 1
		end
	end
	if count >= iCount and count < 4 then
		for i=0,iCount-1 do
			iResultCard[iResultCount] = temp[i]
			iResultCount = iResultCount + 1
		end
		return true
	end
	return false
end

--获取最大的数
function UpGradeLogic:GetMaxCard( iCardList, iCardCount )
	local max = iCardList[0]
	for i=1,iCardCount-1 do
		if self:GetCardBulk(iCardList[i], false) > self:GetCardBulk(max, fasle) then
			max = iCardList[i]
		end
	end
	return max
end

--是否符合顺子条件
function UpGradeLogic:IsConformStraight( iCardList,iCardCount )
	if iCardCount < 2 or iCardCount >= 5 then
		return false
	end
	return self:IsSequence(iCardList,iCardCount,1)
end

--是否包含对子
function UpGradeLogic:IsConformDouble(iHandCard,iHandCardCount, iCardList,iCardCount ,iResultCard)
	if iCardCount ~= 3 then
		iResultCard = {}
		return iResultCard
	end
	local temp = {}
	local nIndex = -1
	for i=0,iCardCount-1 do
		if temp[self:GetCardBulk(iCardList[i], false)] == nil then
			temp[self:GetCardBulk(iCardList[i], false)] = 0
		end
		temp[self:GetCardBulk(iCardList[i], false)] = temp[self:GetCardBulk(iCardList[i], false)]+1
	end
	local m = 0
	local n = 0
	for i=0,17 do
		if temp[i] ~=nil and temp[i] == 2 then
			m = i
		elseif temp[i] ~=nil and temp[i] == 1 then
			n = i
		end
	end
	if m - n > 2 or m - n < -2 then
		iResultCard = {}
		return iResultCard
	end
	local tmp = table.copy(iHandCard)
	iResultCard = table.copy(iCardList)
	local iResultCardCount = table.nums(iResultCard)
	tmp = self:RemoveCard(iCardList,iCardCount,tmp,table.nums(tmp))
	local iStart
	if m > n then
		iStart = n
	else
		iStart = m
	end
	local iCurChaxun = {}
	for i=iStart,iStart+2 do
		if i == m then
		elseif i == n then
			if self:GetCountBySpecifyCard(tmp, table.nums(tmp),iCurChaxun,table.nums(iCurChaxun),i,1) == false then
				iCurChaxun = {}
				break
			end
		else
			if self:GetCountBySpecifyCard(tmp, table.nums(tmp),iCurChaxun,table.nums(iCurChaxun),i,2) == false then
				iCurChaxun = {}
				break
			end
		end
	end
	if table.nums(iCurChaxun) == 3 then
		for k,v in pairs(iCurChaxun) do
			iResultCard[iResultCardCount] = v
			iResultCardCount = iResultCardCount + 1
		end
	else
		iResultCard = {}
	end
	if self:IsDoubleSequence(iResultCard, table.nums(iResultCard), false) == false then
		iResultCard = {}
	end
	return iResultCard
end

--是否包含该3条 
function UpGradeLogic:IsConformSequen( iHandCard,iHandCardCount,iBaseCard,iBaseCardCount,iResultCard)
	if iBaseCardCount ~= 4 then
		iResultCard = {}
		return iResultCard
	end
	local temp = {}
	local nIndex = -1
	for i=0,iBaseCardCount-1 do
		if temp[self:GetCardBulk(iBaseCard[i], false)] == nil then
			temp[self:GetCardBulk(iBaseCard[i], false)] = 0
		end
		temp[self:GetCardBulk(iBaseCard[i], false)] = temp[self:GetCardBulk(iBaseCard[i], false)]+1
	end
	local m = 0
	local n = 0
	for i=0,17 do
		if temp[i] ~=nil and temp[i] == 3 then
			m = i
		elseif temp[i] ~=nil and temp[i] == 1 then
			n = i
		end
	end
	if m - n > 1 or m - n < -1 then
		iResultCard = {}
		return iResultCard
	end
	local tmp = table.copy(iHandCard)
	iResultCard = table.copy(iBaseCard)
	local iResultCardCount = table.nums(iResultCard)
	tmp = self:RemoveCard(iBaseCard,iBaseCardCount,tmp,table.nums(tmp))
	local iStart
	local iCurChaxun = {}
	if self:GetCountBySpecifyCard(tmp, table.nums(tmp),iCurChaxun,table.nums(iCurChaxun),n,2) == false then
		iCurChaxun = {}
	end
	if table.nums(iCurChaxun) == 2 then
		for k,v in pairs(iCurChaxun) do
			iResultCard[iResultCardCount] = v
			iResultCardCount = iResultCardCount + 1
		end
	else
		iResultCard = {}
		return iResultCard
	end
	if self:IsThreeXSequence(iResultCard, table.nums(iResultCard), 0, false) == false then
		iResultCard = {}
	end

	return iResultCard
end

function UpGradeLogic:AutoFirstChooseBrand( iHandCard, iHandCardCount, iBaseCard, iBaseCardCount, iResultCard)
	iResultCard = {}
	local iResultCardCount = 0
	if iBaseCardCount < 1 then
		return
	end
	--符合顺子条件
	if iBaseCardCount >= 2 and iBaseCardCount < 5  and self:IsConformStraight(iBaseCard,iBaseCardCount) then
		local iMax = self:GetMaxCard(iBaseCard,iBaseCardCount)
		local iMaxCard = self:GetCardBulk(iMax, false)
		for i=0,4-iBaseCardCount do
			if iMaxCard+i+1 < 15 and self:GetCountBySpecifyCard(iHandCard, iHandCardCount,iBaseCard,table.nums(iBaseCard),iMaxCard+i+1,1) == false then
				break
			end
		end
		if table.nums(iBaseCard) < 5 then
			iResultCard = {}
		else
			iResultCard = table.copy(iBaseCard)
		end
	elseif iBaseCardCount == 4 then
		iResultCard = self:IsConformSequen(iHandCard,iHandCardCount,iBaseCard,iBaseCardCount,iResultCard)
		if table.nums(iResultCard) < 6 then
			iResultCard = {}
		end
		--判断是否为飞机
	elseif iBaseCardCount == 3 then
		iResultCard = self:IsConformDouble(iHandCard,iHandCardCount,iBaseCard,iBaseCardCount,iResultCard)
		if table.nums(iResultCard) < 6 then
			iResultCard = {}
		end
	elseif iBaseCardCount >= 5 then

		iResultCard = {}
		for i=iBaseCardCount,5,-1 do
			iResultCard = self:TackOutSequence(iBaseCard, iBaseCardCount, {}, i, iResultCard, table.nums(iResultCard), 1, true)
			if table.nums(iResultCard) > 0 then
				return iResultCard
			end
		end
		if iBaseCardCount >= 6 then
			local mCount = iBaseCardCount
			if mCount % 2 ~= 0 then
				mCount = mCount - 1
			end
			for i=mCount,6,-2 do
				iResultCard = self:TackOutSequence(iBaseCard, iBaseCardCount, {}, i, iResultCard, table.nums(iResultCard), 2, true)
				if table.nums(iResultCard) > 0 then
					return iResultCard
				end
			end
		end
		if iBaseCardCount >=6 then
			local mCount = iBaseCardCount
			if mCount % 3 == 1 then 
				mCount = mCount - 1
			elseif mCount % 3 == 2 then
				mCount = mCount - 2
			end
			for i=mCount,6,-3 do
				iResultCard = self:TackOutSequence(iBaseCard, iBaseCardCount, {}, i, iResultCard, table.nums(iResultCard), 3, true)
				if table.nums(iResultCard) > 0 then
					return iResultCard
				end
			end
		end
		return {}
	end
	return iResultCard
end

function UpGradeLogic:AutoChooseBrand( iHandCard, iHandCardCount, iBaseCard, iBaseCardCount,iCardList,iCardCount,iResultCard)
	if iBaseCardCount > iCardCount  then
		iResultCard = self:TackOutCardMoreThanLast(iBaseCard, iBaseCardCount, iCardList, iCardCount, iResultCard, table.nums(iResultCard), false)
		if not self:CanOutCard(iResultCard, table.nums(iResultCard), iCardList, iCardCount, iBaseCard, iBaseCardCount) then
			iResultCard = {} 
		end
		return iResultCard
	elseif iBaseCardCount >= 1 then
		local iBaseShape = self:GetCardShape(iCardList, iCardCount) --桌面上牌的牌型
		if iBaseShape == CARD_TYPE.UG_ONLY_ONE or iBaseShape == CARD_TYPE.UG_DOUBLE or iBaseShape == CARD_TYPE.UG_THREE or iBaseShape == CARD_TYPE.UG_BOMB then
			local bCardBuf = {}
			local iCount = self:TackOutBySpecifyCard(iBaseCard, iBaseCardCount, bCardBuf, table.nums(bCardBuf), self:GetCardBulk(iBaseCard[0], false))
			if iCount == iBaseCardCount and self:CompareOnlyOne(iCardList[0],iBaseCard[0]) then
				iResultCard = table.copy(iBaseCard)
				local iResultCardCount = table.nums(iResultCard)
				if iCount < iCardCount then
					local tmp = table.copy(iHandCard)
					tmp = self:RemoveCard(iBaseCard,iBaseCardCount,tmp,table.nums(tmp))
					if self:GetCountBySpecifyCard(tmp, table.nums(tmp),bCardBuf,table.nums(bCardBuf),self:GetCardBulk(iBaseCard[0], false),iCardCount-iCount) == false then
						bCardBuf = {}
						iResultCard = {}
						return iResultCard
					else
						for k,v in pairs(bCardBuf) do
							iResultCard[iResultCardCount] = v
							iResultCardCount = iResultCardCount + 1
						end
					end
				elseif iCardCount == iCount then
					return {}
				elseif iCardCount < iCount and iCount < 4 then
					for k,v in pairs(iResultCard) do
						if k >= iCardCount  then
							table.remove(iResultCard,k)
						end
					end
				end
				return iResultCard
			else
				iResultCard = self:TackOutCardMoreThanLast(iHandCard, iHandCardCount, iCardList, iCardCount, iResultCard, table.nums(iResultCard), false)
				if not self:CanOutCard(iResultCard, table.nums(iResultCard), iCardList, iCardCount, iBaseCard, iBaseCardCount) then
					iResultCard = {} 
					return iResultCard
				end
			end
		else
			iResultCard = self:TackOutCardMoreThanLast(iHandCard, iHandCardCount, iCardList, iCardCount, iResultCard, table.nums(iResultCard), false)
			if not self:CanOutCard(iResultCard, table.nums(iResultCard), iCardList, iCardCount, iBaseCard, iBaseCardCount) then
				iResultCard = {} 
				return iResultCard
			end
		end
	end

	return iResultCard
end

--获取初始的没有排序的所有牌
function UpGradeLogic:GetLevelCard( iCardList )
	local step = {}
	local index = 0
	for i=0,table.nums(iCardList)-1 do
		if iCardList[i] > 0 then
			step[index] = iCardList[i]
			index = index + 1
		end
	end
	return step
end

return UpGradeLogic