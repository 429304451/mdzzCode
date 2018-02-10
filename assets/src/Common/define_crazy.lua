--------------------------------------------------------------------------------------------
--------------------------------------------疯狂双十----------------------------------------
--------------------------------------------------------------------------------------------
--游戏信息
local PLAY_ALL_COUNT = 5                          --游戏牌的张数
local CARD_COUNT_START = 4
---------------------------

MSG_GAME_STRUCT.CR_GameStarPackage = 
{
	{type = MSG_DATA_TYPE.int, key = "iUserBetMax"},			--每局玩家可下注最大值
};
--发牌消息
MSG_GAME_STRUCT.CR_MSG_S_SendCardRsg =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bCard",num = {CARD_COUNT_START}},			--下注区域
};
--通知玩家下注
MSG_GAME_STRUCT.CR_MSG_S_NoteUserBet =
{
	{type = MSG_DATA_TYPE.BYTE, key = "uDeskStation"},		--玩家座位号
	{type = MSG_DATA_TYPE.int, key = "iAntesMoney"},		--玩家底注金额
};
-- --玩家弃牌
-- MSG_GAME_STRUCT.CR_MSG_S_UserDisCard =
-- {
-- 	{type = MSG_DATA_TYPE.BYTE, key = "uDeskStation"},	    --玩家座位号
-- };
--用户下注结果
MSG_GAME_STRUCT.CR_MSG_C_UserBetResult =
{
	{type = MSG_DATA_TYPE.BYTE, key = "UserXiaZhuType"},	--下注类型（UserOperationType）
	{type = MSG_DATA_TYPE.int, key = "iAmount"},	        --下注金额
};
--返回用户下注结果
MSG_GAME_STRUCT.CR_MSG_S_UserBetResult =
{
	{type = MSG_DATA_TYPE.BYTE, key = "uDeskStation"},	    --下注玩家座位号
	{type = MSG_DATA_TYPE.BYTE, key = "UserXiaZhuType"},	--下注类型
	{type = MSG_DATA_TYPE.int, key = "iAmount"},	        --下注金额
};
MSG_GAME_STRUCT.CR_MSG_S_SendBackCard =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bBackCard"},	                --底牌
	{type = MSG_DATA_TYPE.int, key = "SelementiMoney", num = PLAY_ALL_COUNT},	--金币分堆情况
};
--发全部底牌
MSG_GAME_STRUCT.CR_MSG_S_SendAllBackCard =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bBackCard", num = 2},	                --底牌
	{type = MSG_DATA_TYPE.int, key = "SelementiMoney", num = PLAY_ALL_COUNT},	--金币分堆情况
};
--游戏结束统计数据包
MSG_GAME_STRUCT.CR_MSG_S_GameEnd =
{
	{type = MSG_DATA_TYPE.int, key = "SelementiMoney", num = PLAY_ALL_COUNT},	--金币分堆情况
	{type = MSG_DATA_TYPE.int, key = "iUserWinMoney", num = PLAY_ALL_COUNT},			--玩家输赢金钱
	{type = MSG_DATA_TYPE.BYTE, key = "bSeleMoneyToUserIndex", num = PLAY_ALL_COUNT},		--分堆金币飞向玩家情况（数组下标为分堆下标,数组数值为玩家下标）
	{type = MSG_DATA_TYPE.BYTE, key = "iWinUserCardData", num = PLAY_ALL_COUNT},		--全赢玩家牌型数据
	{type = MSG_DATA_TYPE.BYTE, key = "iWinStation"},		            --全赢玩家下标
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardData",num = {PLAY_ALL_COUNT,CARD_COUNT_START}},		--玩家底牌数据
	{type = MSG_DATA_TYPE.__int64, key = "iUserNowMoney",num = PLAY_ALL_COUNT},		--玩家身上金额
	{type = MSG_DATA_TYPE.int, key = "iUserPoint", num = PLAY_ALL_COUNT},						--玩家之前已下注总金额
};
MSG_GAME_STRUCT.MSG_S_GameEndEarly =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iGameEarlyFlag"},		--//0表示无效，1表示第一轮提早，2表示第二轮提早结束，3表示第三轮提早结束
	{type = MSG_DATA_TYPE.int, key = "iUserWinMoney"},			--玩家输赢金钱
	{type = MSG_DATA_TYPE.BYTE, key = "iWinUserCardData", num = PLAY_ALL_COUNT},		--全赢玩家牌型数据
	{type = MSG_DATA_TYPE.BYTE, key = "iWinStation"},		            --全赢玩家下标
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardData",num = CARD_COUNT_START},		--玩家底牌数据
	{type = MSG_DATA_TYPE.__int64, key = "iUserNowMoney",num = PLAY_ALL_COUNT},		--玩家身上金额
};
MSG_GAME_STRUCT.UserWinInfo =
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},			--玩家输赢金钱
	{type = MSG_DATA_TYPE.int, key = "iUserPoint"},		--全赢玩家牌型数据
};
MSG_GAME_STRUCT.UserWinList =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCount"},			--玩家输赢金钱
	{type = MSG_GAME_STRUCT.UserWinInfo, key = "winInfo",num = "iUserCount"},		--全赢玩家牌型数据
};


-------------------------------------------------------------------------------------------------
--------------------------------------疯狂双十消息-----------------------------------------------
-------------------------------------------------------------------------------------------------
CR_ASS_GAME_BEGIN 				= 	655					--游戏开始
CR_ASS_SEND_CARD_MSG 			= 	656					--发牌
CR_ASS_SEND_BEGIN_XIAZHU 		= 	657              	--通知玩家下注
CR_ASS_USER_XIAZHU_RSULT		=	661					--玩家下注结果
CR_ASS_SEND_BACKCARD  			=	659   				--发一张底牌
CR_ASS_SEND_AllBACKCARD 		=	660 				--发两张底牌
CR_ASS_CONTINUE_END 			=	651 				--游戏正常结算
CR_ASS_AHEAD_END 				=	654  				--游戏提早结算（剩一个玩家没弃牌）
CR_ASS_GAME_FISH 				=	663
CR_ASS_USER_WIN_LIST 			=	662

CR_GS_WAIT_WAITE				=	30
CR_GS_GAME_BEGIN        		=	31
CR_GS_XIAZHU					=	32
CR_GS_SEANDBACKCARD 			=	33
CR_GS_GAMEEND					=	34
-----------------------------------疯狂双十玩家(场景消息）---------------------------------------
MSG_GAME_STRUCT.CR_XiaZhuInfoPart =
{
	{type = MSG_DATA_TYPE.int, key = "iNowBetMoney"},			--当前玩家下注金额
	{type = MSG_DATA_TYPE.BYTE, key = "iUserHandleType"},		--当前玩家操作类型
	-- {type = MSG_DATA_TYPE.bool, key = "bIsSelement"},		    --是否已经分堆
	-- {type = MSG_DATA_TYPE.int, key = "iSelementGold"},			--分堆金币
};
--疯狂双十游戏状态
--等待游戏开始状态
MSG_GAME_STRUCT.CR_GameStation_2 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
};

MSG_GAME_STRUCT.CR_GameStation_3 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
	{type = MSG_DATA_TYPE.int, key = "iMaxUserBet"},					--当前用户可下最大值
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardList", num = CARD_COUNT_START},					--用户手上的扑克
};

MSG_GAME_STRUCT.CR_GameStation_4 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},														--游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},													--重连定时器剩余时间
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardList", num = CARD_COUNT_START},							--用户手上的扑克
	{type = MSG_DATA_TYPE.BYTE, key = "iBackCard", num = 2},											--底牌
	{type = MSG_DATA_TYPE.int, key = "iAntesMoney"},													--当前下注玩家位置
	{type = MSG_DATA_TYPE.int, key = "iMaxUserBet"},					--当前用户可下最大值
	{type = MSG_DATA_TYPE.BYTE, key = "iNowBetPostion"},												--当前下注玩家位置
	{type = MSG_GAME_STRUCT.CR_XiaZhuInfoPart, key = "arrXiaZhuInfo", num = PLAY_ALL_COUNT},			--本轮玩家下注情况
	{type = MSG_DATA_TYPE.int, key = "iMoneyDiaspark", num = PLAY_ALL_COUNT},							--本轮金币分堆情况
};

MSG_GAME_STRUCT.CR_GameStation_5 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},														--游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},													--重连定时器剩余时间
	-- {type = MSG_DATA_TYPE.int, key = "iUserTotalBetMoney", num = PLAY_ALL_COUNT},						--玩家之前已下注总金额
};

MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY] = MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY] or {}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][CR_ASS_GAME_BEGIN] = {send = nil,rec = MSG_GAME_STRUCT.CR_GameStarPackage,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][CR_ASS_SEND_CARD_MSG] = {send = nil,rec = MSG_GAME_STRUCT.CR_MSG_S_SendCardRsg}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][CR_ASS_SEND_BEGIN_XIAZHU] = {send = nil,rec = MSG_GAME_STRUCT.CR_MSG_S_NoteUserBet}
	-- MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][CR_ASS_USER_DISCARD] = {send = nil,rec = MSG_GAME_STRUCT.CR_MSG_S_UserDisCard,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][CR_ASS_USER_XIAZHU_RSULT] = {send = MSG_GAME_STRUCT.CR_MSG_C_UserBetResult,rec = MSG_GAME_STRUCT.CR_MSG_S_UserBetResult,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][CR_ASS_SEND_BACKCARD] = {send = nil,rec = MSG_GAME_STRUCT.CR_MSG_S_SendBackCard,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][CR_ASS_SEND_AllBACKCARD] = {send = nil,rec = MSG_GAME_STRUCT.CR_MSG_S_SendAllBackCard}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][CR_ASS_CONTINUE_END] = {send = nil,rec = MSG_GAME_STRUCT.CR_MSG_S_GameEnd}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][CR_ASS_AHEAD_END] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_GameEndEarly}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][CR_ASS_GAME_FISH] = {send = nil,rec = nil}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][CR_ASS_USER_WIN_LIST] = {send = nil,rec = MSG_GAME_STRUCT.UserWinList}
	



