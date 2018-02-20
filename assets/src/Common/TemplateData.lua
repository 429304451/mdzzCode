--
-- Author: Your Name
-- Date: 2015-07-13 14:03:00
--模板数据     所有模板数据这这边操作   不要加入玩家数据
local TemplateData = class("TemplateData")

function TemplateData.create()
	return TemplateData.new()
end

function TemplateData:ctor()
    self:loadCsvFileExchange()
    self:loadCsvFileCashredExc()
end

------------------------
--ddz
--房间信息
function TemplateData:getRoom(gameId)
    if not gameId or gameId == 10003300  then
        if not self.ddzRoomInfo then
            self.ddzRoomInfo = require("config.template.room")
        end
        assert(self.ddzRoomInfo~=nil , "TemplateData:getRoom nil")
        return self.ddzRoomInfo
    elseif gameId and gameId == 10900500 then
        if not self.bullRoomInfo then
            self.bullRoomInfo = require("config.template.bullroom")
        end
        assert(self.bullRoomInfo~=nil , "TemplateData:getRoom nil")
        return self.bullRoomInfo
    elseif gameId and gameId == 10902500 then
        if not self.crazyRoomInfo then
            self.crazyRoomInfo = require("config.template.CrazyTen")
        end
        assert(self.crazyRoomInfo~=nil , "TemplateData:getRoom nil")
        return self.crazyRoomInfo
    elseif gameId and gameId == 10901800 then
        if not self.hundredRoomInfo then
            self.hundredRoomInfo = require("config.template.hundredbullroom")
        end
        assert(self.hundredRoomInfo~=nil , "TemplateData:getRoom nil")
        return self.hundredRoomInfo
    elseif gameId and gameId == 10003400 then
        if not self.grabredsRoomInfo then
            self.grabredsRoomInfo = require("config.template.grabredroom")
        end
        assert(self.grabredsRoomInfo~=nil , "TemplateData:getRoom nil")
        return self.grabredsRoomInfo
    elseif gameId and gameId == 10801800 then
        if not self.fruitsRoomInfo then
            self.fruitsRoomInfo = require("config.template.fruitroom")
        end
        assert(self.fruitsRoomInfo~=nil , "TemplateData:fruitroom nil")
        return self.fruitsRoomInfo
    end
    return nil
end

--房间金币描述:如 1千~5千
function TemplateData:getRoomGoldDesc(gameId,id)
    local roomInfos = self:getRoom(gameId)
    local roomInfo = roomInfos[id]

    if  not roomInfo or roomInfo == nil  then
        return
    end
    local min = roomInfo.gold1
    local max = roomInfo.gold2

    local desc = util.numberFormat( min, nil ,0,true)
    if max > 0 then
        desc = desc.."~"..util.numberFormat( max, nil ,0,true)
    else
        desc = desc.."以上"
    end

    return desc
end

function TemplateData:getRoomBottomInfo(gameId,id )
    local roomInfos = self:getRoom(gameId)
    local roomInfo = roomInfos[id]
    return roomInfo.num2
end
----------------------------
function TemplateData:getGoods()
    if not self._goods then
        self._goods = require("config.template.prop")
    end
    assert(self._goods~=nil , "TemplateData:_goods nil")
    for id,info in pairs(self._goods) do
        self._goods[id].id = id
    end
    return self._goods
end

function TemplateData:getGoodsById(id)
    self:getGoods()
    return self._goods[id]
end

function TemplateData:getGoodsIconById(id)
    local info = self:getGoodsById(id)
    return info and info.picture and "img2/item/"..info.picture
end

function TemplateData:getGoodsNameById(id)
    local info = self:getGoodsById(id)
    return info and info.name
end

function TemplateData:getGoodsTimeById(id)
    local info = self:getGoodsById(id)
    return info and info.time and info.time*24*3600
end

function TemplateData:getShopGoods()
    if not self._shopgoods then
        self._shopgoods = require("config.template.MallProps")
    end
    assert(self._shopgoods~=nil , "TemplateData:getShopGoods nil")
    -- if util:isExamine() then
    --     self._shopgoods[FIRST_CHARGE_ID] = {
    --         system = 0,
    --         classify = 6,
    --         name = "33",
    --         gongneng = "购买后获得33门票加2万金币",
    --         type = 2,
    --         Price = 6,
    --         time = 0,
    --         tishi = "你想以6元购买33门票加2万金币？",
    --         bGive = 0,
    --     }
    -- else
    --     self._shopgoods[FIRST_CHARGE_ID] = nil
    -- end
    for id,info in pairs(self._shopgoods) do
        self._shopgoods[id].id = id
        --安卓跟IOS区分
        if (info.system == 1 and (__Platform__ == 4 or __Platform__ == 5)) or (info.system == 2 and (__Platform__ == 3 or __Platform__ == 0)) then
            self._shopgoods[id] = nil
        end
    end
    return self._shopgoods
end

function TemplateData:getShopGooldInfo(id,key)
    self:getShopGoods()
    return self._shopgoods and self._shopgoods[id] and self._shopgoods[id][key] or ""
end

function TemplateData:getGoodsPrice(id)
    self:getShopGoods()
    return self._shopgoods and self._shopgoods[id] and self._shopgoods[id].Price
end

function TemplateData:getGoodsclassify(id)
    self:getGoods()
    return self._goods and self._goods[id] and self._goods[id].classify
end

function TemplateData:getPriceType(id)
    self:getShopGoods()
    return self._shopgoods and self._shopgoods[id] and self._shopgoods[id].type
end

function TemplateData:getPriceIcon(id)
    local type = self:getPriceType(id)
    return R.moneyIcon[type]
end

--ios商品ID转为物品ID
function TemplateData:getGoodIdFromeIOSID(iosID)

    local isGold = string.find(iosID,"gold")
    local money = string.match(iosID,".*%.([0-9]+)")
    money = money and tonumber(money)

    -- if money == FIRST_CHARGE_PRICE and isGold then
    --     return FIRST_CHARGE_ID
    -- end
    self:getShopGoods()
    for id,info in pairs(self._shopgoods) do
            --trace("check id1,",id,self:getPriceType(id),PRICETYPE_MONEY , self:getGoodsPrice(id) , money)
        if self:getPriceType(id)==PRICETYPE_MONEY and self:getGoodsPrice(id) == money then
            local classify = self:getGoodsclassify(id)
            --trace("check id2,",not isGold or classify==5)
            if (isGold and (classify==5 or classify==6)) or (not isGold and classify~=5) then
                return id
            end
        end
    end
end
--ios商品ID转为物品ID
function TemplateData:getMoneyandTypeFromeIOSID(iosID)
    local isGold = string.find(iosID,"gold")
    local money = string.match(iosID,".*%.([0-9]+)")
    return money,isGold and 100 or 0
end

--返回需要的金币,钻,钱
function TemplateData:getGoodsPriceEx(id)
    self:getShopGoods()
    local price = self._shopgoods and self._shopgoods[id] and self._shopgoods[id].Price
    local priceType = self:getPriceType(id)
    return priceType == PRICETYPE_GOLD and price or 0,priceType == PRICETYPE_TREA and price or 0,priceType == PRICETYPE_MONEY and price or 0
end
function TemplateData:getGoodsValue(id)
    self:getShopGoods()
    local value = self._shopgoods and self._shopgoods[id] and self._shopgoods[id].name or ""
    -- value = string.gsub(value,"万","0000")
    value = string.gsub(value,"钻","")
    value = string.gsub(value,"门票","")
    if string.find(value,"万") then
       local str = string.gsub(value,"万","")
       value = tonumber(str)*10000
    end
    return tonumber(value)
end

function TemplateData:getGoodsValueFirstCharge(id)
    self:getShopGoods()
    local iGameCoin = self._shopgoods and self._shopgoods[id] and self._shopgoods[id].iGameCoinNum or 0
    local iGoldNum = self._shopgoods and self._shopgoods[id] and self._shopgoods[id].iGoldNum or 0
    return iGameCoin,iGoldNum
end

function TemplateData:getGoodsDesc(id)
    self:getShopGoods()
    return self._shopgoods and self._shopgoods[id] and self._shopgoods[id].tishi or ""
end

function TemplateData:getHongbao(id)
    if not self._hongbao then
        self._hongbao = require("config.template.red")
    end

    return id and self._hongbao[id] or self._hongbao
end

function TemplateData:getHongbaogold(id)
    local info = self:getHongbao(id)
    return info and info.CashMin
end

function TemplateData:loadCsvFileExchange()
    local data = cc.FileUtils:getInstance():getStringFromFile("img2/config/exchange.csv")
    if data then
        data = string.gsub(data,"^\239\187\191","")--去除UFT-8的BOM
        local lineStr = string.split(data, '\r\n')
        local titles = string.split(lineStr[1], ",")
        local ID = 1
        self._exchangeArr = {}
        for i = 2, #lineStr, 1 do  
            -- 一行中，每一列的内容  
            local content = string.split(lineStr[i], ",")
            -- 以标题作为索引，保存每一列的内容，取值的时候这样取：self._exchangeArr[1].Title  
            self._exchangeArr[ID] = {}
            for j = 1, #titles, 1 do  
                self._exchangeArr[ID][titles[j]] = content[j]
            end  
      
            ID = ID + 1
        end  
        return self._exchangeArr
    end
end

function TemplateData:getExchangeInfo( ... )
    return self._exchangeArr
end
function TemplateData:loadCsvFileCashredExc()
    local data = cc.FileUtils:getInstance():getStringFromFile("img2/config/cashredExc.csv")
    if data then
        data = string.gsub(data,"^\239\187\191","")--去除UFT-8的BOM
        local lineStr = string.split(data, '\r\n')
        local titles = string.split(lineStr[1], ",")
        local ID = 1
        self._cashredExc = {}
        for i = 2, #lineStr, 1 do  
            -- 一行中，每一列的内容  
            local content = string.split(lineStr[i], ",")
            -- 以标题作为索引，保存每一列的内容，取值的时候这样取：self._exchangeArr[1].Title  
            self._cashredExc[ID] = {}
            for j = 1, #titles, 1 do  
                self._cashredExc[ID][titles[j]] = content[j]
            end  
      
            ID = ID + 1
        end  
        return self._cashredExc
    end
end

function TemplateData:getCashredExcInfo( ... )
    if not self._cashredExc then
        self:loadCsvFileCashredExc()
    end
    return self._cashredExc
end
function TemplateData:getPalyerPochanCount( iTaskID )
    if not self._vipInfo then
        self._vipInfo = require("config.template.VIP")
    end
    if not self._taskInfo then
        self._taskInfo = require("config.template.task")
    end
    local count = 0
    if PlayerData:getPlayerInfo().bVipLevel > 0 and PlayerData:getPlayerInfo().bVipLevel <= 10 then
        count = self._vipInfo[PlayerData:getPlayerInfo().bVipLevel].frequency
    else
        count = self._taskInfo[iTaskID].frequency
    end
    return count
end
function TemplateData:getPalyerTaskCount( iTaskID )
    if not self._taskInfo then
        self._taskInfo = require("config.template.task")
    end
    local count = self._taskInfo[iTaskID].frequency or 0
    return count
end
function TemplateData:getVipLevel( iAmount )
    if not self._vipInfo then
        self._vipInfo = require("config.template.VIP")
    end
    local iMaxVip = table.nums(self._vipInfo) or 10
    local iMinVip = 1
    if  iAmount >= self._vipInfo[iMaxVip].mon then
        return self._vipInfo[iMaxVip].LV
    end
    if iAmount < self._vipInfo[iMinVip].mon then
        return 0
    end
    for i=1,iMaxVip-1 do
        if iAmount >= self._vipInfo[i].mon and iAmount < self._vipInfo[i+1].mon then
            return self._vipInfo[i].LV
        end
    end
end
function TemplateData:getVipLevelAmount( iLevel )
    if not self._vipInfo then
        self._vipInfo = require("config.template.VIP")
    end
    if self._vipInfo[iLevel] then
        return iLevel and self._vipInfo[iLevel].mon
    end
    return 0
end
function TemplateData:getVipLevelDesc( iLevel )
    if not self._vipInfo then
        self._vipInfo = require("config.template.VIP")
    end
    if self._vipInfo[iLevel] then
        return iLevel and self._vipInfo[iLevel].display
    end
    return "无"
end
function TemplateData:getVipLevelHbCount( iLevel )
    if not self._vipInfo then
        self._vipInfo = require("config.template.VIP")
    end
    if self._vipInfo[iLevel] then
        return iLevel and self._vipInfo[iLevel].Num
    end
    return 0
end
--根据vip获取vip抽奖次数
function TemplateData:getLotteryCountByVipLevel( iLevel )
    if not self._vipInfo then
        self._vipInfo = require("config.template.VIP")
    end
    if self._vipInfo[iLevel] then
        return iLevel and self._vipInfo[iLevel].lottery
    end
    return 5
end
function TemplateData:sortTask( tbl )
    for k,v in pairs(tbl) do
        if v then
           local iSort = self:getTaskInfoSort(v.iTaskID)
           v.iSort = iSort
        end
    end
    table.sort(tbl,function(a,b) return a.iSort<b.iSort end)
end
function TemplateData:getTaskInfoSort( iTask )
    if not self._taskinfo then
        self._taskinfo = require("config.template.task")
    end
    if self._taskinfo[iTask] then
        return iTask and self._taskinfo[iTask].order
    end
    return 0
end
function TemplateData:getResureTypeByType( iType )
    if not self._resureTypeInfo then
        self._resureTypeInfo = require("config.template.resurrectionConfig")
    end
    if self._resureTypeInfo[iType] then
        return iType and self._resureTypeInfo[iType]
    end
    return {}
end

--抽奖奖励
function TemplateData:getShareRewardInfo()
    if not self._ShareLottery then
        self._ShareLottery =  require("config.template.ShareLottery")

        local config = {
            [7] = "img2/share/choujiang/jiangpin/hongbao.png",
            [6] = "img2/share/choujiang/jiangpin/menpiao.png",
            [5] = "img2/share/choujiang/jiangpin/yaoshi.png",
        }

        for index,info in pairs(self._ShareLottery) do
            info.img = config[info.type]
        end
    end
    return self._ShareLottery
end
--描述
function TemplateData:getShareRewardName(index)
    local info = self:getShareRewardInfo()

    return info and info[index] and info[index].name
end
--图片
function TemplateData:getRewardIcon(index)
    local info = self:getShareRewardInfo()

    return info and info[index] and info[index].img
end
--类型
--5道具(钥匙)，6门票,7红包券
function TemplateData:getRewardType(index)
    local info = self:getShareRewardInfo()

    return info and info[index] and info[index].type
end
--数量
function TemplateData:getRewardNum(index)
    local info = self:getShareRewardInfo()

    return info and info[index] and info[index].num
end
--道具ID
function TemplateData:getRewardGoodsID(index)
    local info = self:getShareRewardInfo()

    return info and info[index] and info[index].goodsID
end

function TemplateData:getExchangeGoods()
    if not self._exchangegoods then
        self._exchangegoods = require("config.template.Exchange")
    end
    assert(self._exchangegoods~=nil , "TemplateData:getExchangeGoods nil")
   
    for id,info in pairs(self._exchangegoods) do
        self._exchangegoods[id].id = id
    end
    return self._exchangegoods
end


return TemplateData