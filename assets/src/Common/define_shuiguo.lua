--
-- Author: Name
-- Date: 2017-04-13 15:08:42
--
--MDM_GM_GAME_NOTIFY					=	180		-- 水果机 
	_ASS_Syn_GameState_Play				=	600		-- 同步基础信息

	_ASS_Req_Start_Game					=	601		-- 请求开始游戏
	_ASS_RSP_LotteryResult				=	602		-- 返回摇奖结果
	_ASS_Syn_BalanceInfo				=	603		-- 同步结算信息

	_ASS_Syn_ShowUserInfo				=	604		-- 展示的玩家信息
	_ASS_Req_LastGetPrizePoolUserInfo	=	605		-- 请求最后一个获取奖池奖励的玩家
	_ASS_Rsp_LastGetPrizePoolUserInfo	=	606		-- 返回最后一个获取奖池奖励的玩家
	_ASS_Syn_ShowUserInfo_Change		=	607		-- 同步上位玩家信息变更

	-- eLottery_Succ   				=  0		-- 成功
	-- eLottery_GoldNotEnough		=  1		-- 金币不足

local _len_user_nickname = 16
local _len_head_web = 256

-- S->C 同步基础信息
MSG_GAME_STRUCT.ASS_Syn_GameState_Play = 
{
	{type = MSG_DATA_TYPE.int		, key = "iPerWinGold"},		-- 上局赢取金币数
	{type = MSG_DATA_TYPE.__int64	, key = "i64PrizePool"},	-- 奖池金额
}

MSG_GAME_STRUCT.ShowUserInfo = 
{
	{type = MSG_DATA_TYPE.int		, key = "nUserID"},								-- 用户ID
	{type = MSG_DATA_TYPE.__int64	, key = "n64UserMoney"},						--用户金币
	{type = MSG_DATA_TYPE.BYTE		, key = "iHeadID"},								--系统头像ID
	{type = MSG_DATA_TYPE.BYTE		, key = "iVipLevel"},							--VIP等级
	{type = MSG_DATA_TYPE.BYTE		, key = "iNickNameLen"},	--昵称长度
	{type = MSG_DATA_TYPE.char		, key = "szNickName",num ="iNickNameLen"},	--昵称
	{type = MSG_DATA_TYPE.BYTE		, key = "iHeadWebLen"},	--昵称长度
	{type = MSG_DATA_TYPE.char		, key = "szHeadWeb",num ="iHeadWebLen"},	--昵称
	{type = MSG_DATA_TYPE.bool		, key = "bBoy"},								--性别
}

MSG_GAME_STRUCT.LastGetPrizePoolPlayer = 
{
	{type = MSG_DATA_TYPE.int		, key = "nUserID"},								--用户ID
	{type = MSG_DATA_TYPE.int		, key = "nPrizePoolReward"},					--最后一次获得的奖池奖励
	{type = MSG_DATA_TYPE.__int64	, key = "n64PrizePool"},						--奖池金额
	{type = MSG_DATA_TYPE.time_t	, key = "tmTime"},						--奖池金额
	{type = MSG_DATA_TYPE.BYTE		, key = "iHeadID"},								--系统头像ID
	{type = MSG_DATA_TYPE.BYTE		, key = "iVipLevel"},							--VIP等级
	{type = MSG_DATA_TYPE.BYTE		, key = "iNickNameLen"},	--昵称长度
	{type = MSG_DATA_TYPE.char		, key = "szNickName",num ="iNickNameLen"},	--昵称
	{type = MSG_DATA_TYPE.BYTE		, key = "iHeadWebLen"},	--昵称长度
	{type = MSG_DATA_TYPE.char		, key = "szHeadWeb",num ="iHeadWebLen"},	--昵称
}

--请求开始游戏
MSG_GAME_STRUCT.ASS_Req_Start_Game =
{
	{type = MSG_DATA_TYPE.int, key = "nLineNum"},			-- 用户ID
	{type = MSG_DATA_TYPE.int, key = "nBet"},				--用户金币
}

--返回摇奖结果
MSG_GAME_STRUCT.ASS_RSP_LotteryResult =
{
	{type = MSG_DATA_TYPE.int,	key = "nErrCode"},			-- ELotteryErrCode
	{type = MSG_DATA_TYPE.int,	key = "nLineNum"},			-- 选中的连线数量
	{type = MSG_DATA_TYPE.int,	key = "nBet"},				-- 单线下注金额
	{type = MSG_DATA_TYPE.int,	key = "nBonusCount"},		-- BONUS数量
	{type = MSG_DATA_TYPE.int,	key = "n777Count"},			-- 777数量
	{type = MSG_DATA_TYPE.int,	key = "nWinRate"},			-- 中奖倍率
}

-- 同步结算信息
MSG_GAME_STRUCT.ASS_Syn_BalanceInfo = 
{
	{type = MSG_DATA_TYPE.BYTE,		key = "bFreeLotteryCount"},					-- 免费摇奖次数 
	{type = MSG_DATA_TYPE.__int64,	key = "nPrizePool"},						-- 奖池金币数量
	{type = MSG_DATA_TYPE.int,		key = "iWinGold"},							-- 赢取的金币数量
	{type = MSG_DATA_TYPE.int,		key = "iPrizePoolReward"},					-- 赢取奖池奖励
	{type = MSG_DATA_TYPE.__int64,	key = "nUserGold"},							-- 金币总量 
}

--请求最后一次获取奖池玩家信息
MSG_GAME_STRUCT.ASS_Req_LastGetPrizePoolUserInfo = 
{
}

--返回最后一次获取奖池玩家信息
MSG_GAME_STRUCT.ASS_Rsp_LastGetPrizePoolUserInfo = 
{
	{type = MSG_GAME_STRUCT.LastGetPrizePoolPlayer, key = "userInfo"},
	{type = MSG_GAME_STRUCT.LastGetPrizePoolPlayer, key = "superUserInfo"},
}

--同步展现玩家
MSG_GAME_STRUCT.ASS_Syn_ShowUserInfo = 
{
	{type = MSG_DATA_TYPE.BYTE			, key = "ucCount"},							--当前同步的数量
	{type = MSG_GAME_STRUCT.ShowUserInfo, key = "showUserInfo",num = "ucCount"},	--展现的玩家信息
}

--展现玩家信息变更
MSG_GAME_STRUCT.ASS_Syn_ShowUserInfo_Change = 
{
	{type = MSG_DATA_TYPE.int,				key = "nOfflineUserId"},			-- 离线玩家ID
	{type = MSG_DATA_TYPE.int,				key = "nGoldChange"},				-- 金币变化量
	{type = MSG_DATA_TYPE.int,				key = "nShowUserId",num = 4},		-- 当前在座玩家
	{type = MSG_GAME_STRUCT.ShowUserInfo,	key = "showUserInfo"},				-- 展现的玩家信息
}

MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY] = MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY] or {}

	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][_ASS_Syn_GameState_Play] = {send = nil,rec = MSG_GAME_STRUCT.ASS_Syn_GameState_Play}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][_ASS_Req_Start_Game] = {send = MSG_GAME_STRUCT.ASS_Req_Start_Game,rec = nil}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][_ASS_RSP_LotteryResult] = {send = nil,rec = MSG_GAME_STRUCT.ASS_RSP_LotteryResult}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][_ASS_Syn_BalanceInfo] = {send = nil,rec = MSG_GAME_STRUCT.ASS_Syn_BalanceInfo}

	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][_ASS_Req_LastGetPrizePoolUserInfo] = {send = MSG_GAME_STRUCT.ASS_Req_LastGetPrizePoolUserInfo,rec = nil}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][_ASS_Rsp_LastGetPrizePoolUserInfo] = {send = nil,rec = MSG_GAME_STRUCT.ASS_Rsp_LastGetPrizePoolUserInfo}

	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][_ASS_Syn_ShowUserInfo] = {send = nil,rec = MSG_GAME_STRUCT.ASS_Syn_ShowUserInfo}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][_ASS_Syn_ShowUserInfo_Change] = {send = nil,rec = MSG_GAME_STRUCT.ASS_Syn_ShowUserInfo_Change}
