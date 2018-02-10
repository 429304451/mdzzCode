
--游戏信息
local PLAY_COUNT = 5								--游戏人数
local ONE_MAX_CARD_NUM = 5                          --游戏牌的张数
--游戏状态定义
local play_sation = {}
play_sation.GS_WAIT_SETGAME = 0				--等待东家设置状态
play_sation.GS_WAIT_ARGEE = 1				--等待同意设置
play_sation.GS_FAPAI = 20				--发牌状态
play_sation.GS_XUANZHUANG = 21				--选庄状态
play_sation.GS_XIAZHU = 22				--下注状态
play_sation.GS_FALASTPAI = 23				--发最后一张牌状态
play_sation.GS_XUANPAI = 24				--选牌状态
play_sation.GS_BIPAI = 25				--比牌状态
play_sation.GS_WAIT_NEXT = 26				--等待下一盘开始 
play_sation.ASS_MAIN_GAME = 180							--/< 游戏专用消息主ID
play_sation.ASS_GM_AGREE_GAME = 1									--/< 同意游戏
---------------------------
--抢庄响应  --
MSG_GAME_STRUCT.NoteUserQiangNTRsp =
{
	{type = MSG_DATA_TYPE.BYTE, key = "uDeskStation"},
	{type = MSG_DATA_TYPE.BYTE, key = "cbQiangMultiple"},	--抢庄倍数
};

--抢庄结果  --
MSG_GAME_STRUCT.NoteNTMsg =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iNtStation"}, --庄家的位置
	{type = MSG_DATA_TYPE.BYTE, key = "iNtMultiple"}, --抢庄倍数
};
--下注  			--
MSG_GAME_STRUCT.UserXiaZhu =
{
	{type = MSG_DATA_TYPE.BYTE, key = "cbMultiple"},	--下注倍数
};
--下注结果  			--
MSG_GAME_STRUCT.UserXiaZhuResult =
{
	{type = MSG_DATA_TYPE.BYTE, key = "cbStation"},		--下注玩家位置
	{type = MSG_DATA_TYPE.BYTE, key = "cbMultiple"},	--下注倍数
};
--发牌消息(只把自己的牌发下去)	--
MSG_GAME_STRUCT.NoteSendCardRsg =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bCard",num = 4},
};
--发最后张牌消息(只把自己的牌发下去) --
MSG_GAME_STRUCT.NoteSendLastCardRsg =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bCard"},
};
--显示玩家牌的信息
MSG_GAME_STRUCT.ShowCardInfo =
{
	{type = MSG_DATA_TYPE.BYTE, key = "uDeskStation"},
	{type = MSG_DATA_TYPE.BYTE, key = "bCard",num = 5},
};
--游戏结束统计数据包  --
MSG_GAME_STRUCT.WBGameEndStruct =
{
	{type = MSG_DATA_TYPE.int, key = "iTurePoint",num = PLAY_COUNT},					--玩家得分
	{type = MSG_DATA_TYPE.BYTE, key = "iStraightWins",num = PLAY_COUNT},				--玩家现在连胜值
};

--斗牛游戏状态
MSG_GAME_STRUCT.WB_GameStation_2 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
	{type = MSG_DATA_TYPE.BYTE, key = "iStraightWins"},					--当前连胜值
	{type = MSG_DATA_TYPE.BYTE, key = "iBoxGameCount"},					--当前已经进行的宝箱局数
};
MSG_GAME_STRUCT.WB_GameStation_3 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
	{type = MSG_DATA_TYPE.BYTE, key = "iStraightWins"},					--当前连胜值
	{type = MSG_DATA_TYPE.BYTE, key = "iBoxGameCount"},					--当前已经进行的宝箱局数
};
MSG_GAME_STRUCT.WB_GameStation_4 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardList",num=4},			--用户手上的扑克
	{type = MSG_DATA_TYPE.BYTE, key = "iStraightWins"},					--当前连胜值
	{type = MSG_DATA_TYPE.BYTE, key = "iBoxGameCount"},					--当前已经进行的宝箱局数
};
MSG_GAME_STRUCT.WB_GameStation_5 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},						--重连定时器剩余时间
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardList",num=4},			--用户手上的扑克
	{type = MSG_DATA_TYPE.BYTE, key = "iQiangNtMultiple",num=5},		--抢庄情况
	{type = MSG_DATA_TYPE.BYTE, key = "iStraightWins"},					--当前连胜值
	{type = MSG_DATA_TYPE.BYTE, key = "iBoxGameCount"},					--当前已经进行的宝箱局数
};
MSG_GAME_STRUCT.WB_GameStation_6 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardList",num=4},			--用户手上的扑克
	{type = MSG_DATA_TYPE.BYTE, key = "iNtMultiple"},					--抢庄倍数
	{type = MSG_DATA_TYPE.BYTE, key = "iNtStation"},					--庄家位置
	{type = MSG_DATA_TYPE.BYTE, key = "iStraightWins"},					--当前连胜值
	{type = MSG_DATA_TYPE.BYTE, key = "iBoxGameCount"},					--当前已经进行的宝箱局数
};
MSG_GAME_STRUCT.WB_GameStation_7 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardList",num=4},			--用户手上的扑克
	{type = MSG_DATA_TYPE.BYTE, key = "iNtMultiple"},					--抢庄倍数
	{type = MSG_DATA_TYPE.BYTE, key = "iNtStation"},					--庄家位置
	{type = MSG_DATA_TYPE.BYTE, key = "iXiaZhuNum",num=5},				--下注情况
	{type = MSG_DATA_TYPE.BYTE, key = "iStraightWins"},					--当前连胜值
	{type = MSG_DATA_TYPE.BYTE, key = "iBoxGameCount"},					--当前已经进行的宝箱局数
};
MSG_GAME_STRUCT.WB_GameStation_8 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardList",num = {5,5}},		--用户手上的扑克
	{type = MSG_DATA_TYPE.BYTE, key = "iNtMultiple"},					--抢庄倍数
	{type = MSG_DATA_TYPE.BYTE, key = "iNtStation"},					--庄家位置
	{type = MSG_DATA_TYPE.int, key = "bIsDo"},							--自己是否操作了
	{type = MSG_DATA_TYPE.BYTE, key = "iStraightWins"},					--当前连胜值
	{type = MSG_DATA_TYPE.BYTE, key = "iBoxGameCount"},					--当前已经进行的宝箱局数
};
MSG_GAME_STRUCT.WB_GameStation_9 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
	{type = MSG_DATA_TYPE.int, key = "iTurePoint",num=PLAY_COUNT},		--当前连胜值
	{type = MSG_DATA_TYPE.int, key = "iStraightWins",num=PLAY_COUNT},		--当前连胜值
	{type = MSG_DATA_TYPE.BYTE, key = "iBoxGameCount"},					--当前已经进行的宝箱局数
};
MSG_GAME_STRUCT.WB_GameStation_10 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
	{type = MSG_DATA_TYPE.BYTE, key = "iStraightWins"},					--当前连胜值
	{type = MSG_DATA_TYPE.BYTE, key = "iBoxGameCount"},					--当前已经进行的宝箱局数
};
----------------------------------
WB_ASS_GAME_BEGIN 				= 	401					--游戏开始
WB_ASS_SEND_CARD_MSG 			= 	402					--发牌（四张）
WB_ASS_GAME_NOTE_QIANGZHUANG 	= 	403              	--通知抢庄开始
WB_ASS_QIANGZHUANG_RSP 			= 	404              	--抢庄
WB_ASS_NT_RESULT				=	405					--抢庄完成
WB_ASS_SEND_BEGIN_XIAZHU 		= 	406              	--下注开始时间
WB_ASS_XIAZHU 					= 	407              	--下注
WB_ASS_XIAZHU_RSP 				= 	408              	--下注响应
WB_ASS_SEND_LAST_CARD			=	409					--发最后一张牌
WB_ASS_SHOW_CARD				=	410					--开牌
WB_ASS_CONTINUE_END				=	411					--结算

WB_GS_WAIT_ARGEE				=	11
WB_GS_GAME_BEGIN        		=	12
WB_GS_FAPAI						=	13
WB_GS_QIANGZHUANG				=	14
WB_GS_QIANGZHUANG_FINISH		=	15
WB_GS_XIAZHU					=	16
WB_GS_XUANPAI					=	17
WB_GS_GAME_END					=	18
WB_GS_WAIT_NEXT					=	19

MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY] = MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY] or {}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_GAME_BEGIN] = {send = nil,rec = nil,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_SEND_CARD_MSG] = {send = nil,rec = MSG_GAME_STRUCT.NoteSendCardRsg,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_GAME_NOTE_QIANGZHUANG] = {send = nil,rec = nil,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_QIANGZHUANG_RSP] = {send = MSG_GAME_STRUCT.NoteUserQiangNTRsp,rec = MSG_GAME_STRUCT.NoteUserQiangNTRsp}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_NT_RESULT] = {send = nil,rec = MSG_GAME_STRUCT.NoteNTMsg,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_SEND_BEGIN_XIAZHU] = {send = nil,rec = nil,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_XIAZHU] = {send = MSG_GAME_STRUCT.UserXiaZhu,rec = nil}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_XIAZHU_RSP] = {send = nil,rec = MSG_GAME_STRUCT.UserXiaZhuResult,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_SEND_LAST_CARD] = {send = nil,rec = MSG_GAME_STRUCT.NoteSendLastCardRsg,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_SHOW_CARD] = {send = nil,rec = MSG_GAME_STRUCT.ShowCardInfo,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_CONTINUE_END] = {send = nil,rec = MSG_GAME_STRUCT.WBGameEndStruct,}

		--[[
MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY] = MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY] or {}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_GAME_BEGIN] = {send = nil,rec = nil,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_SEND_CARD_MSG] = {send = nil,rec = MSG_GAME_STRUCT.NoteSendCardRsg,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_GAME_NOTE_QIANGZHUANG] = {send = nil,rec = nil,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_QIANGZHUANG_RSP] = {send = MSG_GAME_STRUCT.NoteUserQiangNTRsp,rec = MSG_GAME_STRUCT.NoteUserQiangNTRsp}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_NT_RESULT] = {send = nil,rec = MSG_GAME_STRUCT.NoteNTMsg,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_SEND_BEGIN_XIAZHU] = {send = nil,rec = nil,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_XIAZHU] = {send = MSG_GAME_STRUCT.UserXiaZhu,rec = nil}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_XIAZHU_RSP] = {send = nil,rec = MSG_GAME_STRUCT.UserXiaZhuResult,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_SEND_LAST_CARD] = {send = nil,rec = MSG_GAME_STRUCT.NoteSendLastCardRsg,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_SHOW_CARD] = {send = nil,rec = MSG_GAME_STRUCT.ShowCardInfo,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][WB_ASS_CONTINUE_END] = {send = nil,rec = MSG_GAME_STRUCT.WBGameEndStruct,}]]--



