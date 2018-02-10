
--游戏信息
local ONE_MAX_CARD_NUM = 5                          --游戏牌的张数
local _len_user_nickname = 16
---------------------------
--下注  --
MSG_GAME_STRUCT.BR_GameNote =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iArea"},			--下注区域
	{type = MSG_DATA_TYPE.BYTE, key = "iNoteIndex"},	--下注筹码索引
};
--上一秒下注情况  --
MSG_GAME_STRUCT.BR_NoteInfoMsg =
{
	{type = MSG_DATA_TYPE.short, key = "iNoteInfo",num = {4,5}}, --上一秒下注信息
};
--发牌
MSG_GAME_STRUCT.BR_SendCardRsg =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bCard",num = {ONE_MAX_CARD_NUM,ONE_MAX_CARD_NUM}},	--发牌数据
};
--游戏结束统计数据包
MSG_GAME_STRUCT.BR_GameEndMsg =
{
	{type = MSG_DATA_TYPE.int, key = "iTurePoint"},					    --玩家得分
	{type = MSG_DATA_TYPE.__int64, key = "iUserMoney"},					--用户金币刷新
	{type = MSG_DATA_TYPE.int, key = "iSeatUserTurePoint",num=8},		--座上玩家输赢钱
	{type = MSG_DATA_TYPE.__int64, key = "iSeatUserMoney",num=8},		--结算后座上玩家的金币
	{type = MSG_DATA_TYPE.int, key = "iNtTruePoint"},					--庄家输赢钱
	{type = MSG_DATA_TYPE.__int64, key = "iNtUserMoney"},				--庄家金币	
	{type = MSG_DATA_TYPE.__int64, key = "PrizePoolMoney"},				--奖池金额
	{type = MSG_DATA_TYPE.int, key = "bNtUserID"},				--庄家ID
};
--走势图
MSG_GAME_STRUCT.BR_GameTendenceMsg =
{
	{type = MSG_DATA_TYPE.BYTE, key = "GameTendenceList",num = {10,4}},	--发牌数据
};
--玩家列表
MSG_GAME_STRUCT.BR_UserInfoC =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bVipLevel"},	--VIP等级
	{type = MSG_DATA_TYPE.BYTE, key = "bLogoID"},	--系统头像ID
	{type = MSG_DATA_TYPE.bool, key = "bBoy"},	   --男女
	{type = MSG_DATA_TYPE.__int64, key = "dwMoney"},	--身上金币
	{type = MSG_DATA_TYPE.BYTE, key = "iNickNameLen"},	--昵称长度
	{type = MSG_DATA_TYPE.char, key = "nickName",num="iNickNameLen"},	--昵称，客户端用
	{type = MSG_DATA_TYPE.BYTE, key = "iHeadWebLen"},	--头像长度
	{type = MSG_DATA_TYPE.char, key = "szHeadWeb",num="iHeadWebLen"},	--头像
};
MSG_GAME_STRUCT.BR_UserList =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCount"},	--数量
	{type = MSG_DATA_TYPE.BYTE, key = "iSendFlag"},	--0 一次发完   1 开始 2未完，3发完
	{type = MSG_GAME_STRUCT.BR_UserInfoC, key = "userInfo",num="iUserCount"},	--用户信息
};
--玩家上坐(C----S)
MSG_GAME_STRUCT.BR_SeatUpC =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iSeatNo"},	--座位号
};
--玩家上坐(S----C)
MSG_GAME_STRUCT.BR_SeatUpS =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iSeatNo"},	--座位号
	{type = MSG_DATA_TYPE.int, key = "iUserID"},	--座位号
	{type = MSG_GAME_STRUCT.BR_UserInfoC, key = "userInfo"},	--用户信息
};
MSG_GAME_STRUCT.BR_SeatDown =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iSeatNo"},	--座位号
};
--边上座位上玩家下注
MSG_GAME_STRUCT.BR_GameSeatNote =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iSeatNo"},	--座位号
	{type = MSG_DATA_TYPE.BYTE, key = "iArea"},	    --下注区域
	{type = MSG_DATA_TYPE.BYTE, key = "iNoteIndex"},	--下注筹码索引
};
--休息期间玩家换庄
MSG_GAME_STRUCT.BR_NtInfo =
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},	--用户ID
	{type = MSG_GAME_STRUCT.BR_UserInfoC, key = "userInfo"},	--用户信息
};
MSG_GAME_STRUCT.BR_NtUp =
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},	--用户ID
	{type = MSG_DATA_TYPE.__int64, key = "iUserMoney"},	--用户金币
	{type = MSG_DATA_TYPE.char, key = "szNickName",num = _len_user_nickname},	--用户昵称
};
MSG_GAME_STRUCT.BR_NtDown =
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},	--用户ID
	{type = MSG_DATA_TYPE.BYTE, key = "iDownNtType"},	--用户ID
};
MSG_GAME_STRUCT.BR_NtList =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bNtUpCount"},	--个数
	{type = MSG_GAME_STRUCT.BR_NtUp, key = "ntUp",num="bNtUpCount"},	--用户信息
};
MSG_GAME_STRUCT.BR_PrizePool =
{
	{type = MSG_DATA_TYPE.__int64, key = "PrizePoolMoney"},	--奖池金额
	{type = MSG_DATA_TYPE.bool, key = "bSysNtGet"},	--是否系统获奖
	{type = MSG_DATA_TYPE.bool, key = "bUserGet"},	--获奖玩家
	{type = MSG_DATA_TYPE.time_t, key = "tmTime"},	--获奖时间
	{type = MSG_GAME_STRUCT.BR_UserInfoC, key ="userInfo"},	--用户信息

	{type = MSG_DATA_TYPE.bool, key = "bSuperSysNtGet"},	--是否系统获奖
	{type = MSG_DATA_TYPE.bool, key = "bSuperUserGet"},	--获奖玩家
	{type = MSG_DATA_TYPE.time_t, key = "tmSuperTime"},	--获奖时间
	{type = MSG_GAME_STRUCT.BR_UserInfoC, key ="superUserInfo"},	--用户信息
};
MSG_GAME_STRUCT.BR_ShowPrizeInfo =
{
	{type = MSG_DATA_TYPE.__int64, key = "PrizePoolMoney"},	--奖池金额
	{type = MSG_DATA_TYPE.bool, key = "bSysNtGet"},	--是否系统获奖
	{type = MSG_DATA_TYPE.bool, key = "bUserGet"},	--获奖玩家
	{type = MSG_DATA_TYPE.bool, key = "bSuperPrize"},	--是否系统获奖
	{type = MSG_DATA_TYPE.time_t, key = "tmTime"},	--获奖时间
	{type = MSG_GAME_STRUCT.BR_UserInfoC, key ="userInfo"},	--用户信息
};
MSG_GAME_STRUCT.BR_SeatUserList =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bCount"},	--个数
	{type = MSG_GAME_STRUCT.BR_SeatUpS,key ="seatUser",num="bCount"},	--用户信息
};

--百人牛牛游戏状态
MSG_GAME_STRUCT.BR_GameStation_3 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
	{type = MSG_DATA_TYPE.short, key = "iTempTotalNoteInfo",num = {4,5}}, --下注情况
	{type = MSG_DATA_TYPE.int, key = "iUserNotInfo",num=4},					--自己的下注情况
};
MSG_GAME_STRUCT.BR_GameStation_4 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
	{type = MSG_DATA_TYPE.short, key = "iLeaveTime"},					--重连定时器剩余时间
};
----------------------------------
--------------------------------------百人牛牛消息-----------------------------------------------
BR_ASS_GAME_BEGIN 				= 	501					--游戏开始
BR_ASS_NOTE 					= 	502					--玩家下注
BR_ASS_NOTEINFO 				= 	503              	--上一秒下注情况
BR_ASS_SEND_CARD 				= 	504              	--发牌
BR_ASS_CONTINUE_END				=	505					--结算
BR_ASS_NT_UP  					=	506
BR_ASS_NT_DOWN 					=	507
BR_ASS_NT_LIST 					=	508
BR_ASS_SEAT_UP 					=	509
BR_ASS_SEAT_DOWN 				=	510
BR_ASS_GAME_TENDENCE 			=	511
BR_ASS_REQUEST_USERLIST 		=	512
BR_ASS_REQUEST_PRIZEPOOL 		=	513
BR_ASS_SEAT_NOTE 				=	514
BR_ASS_NT_INFO 					= 	515
BR_ASS_SHOWP_RRIZE 				=	517
BR_ASS_SEAT_INFO 				=	516
BR_ASS_NT_DOWN_WAIT 			=	518
BR_ASS_EARLY_OVER_NOTE 			=	519
BR_ASS_NOTE_ERROR 				=	520
---------------------------------------百人牛牛玩家状态--------------------------------------------
BR_GS_GAME_BEGIN        		=	20
BR_GS_WAIT_SEND_CARD 			=	21
BR_GS_SEND_CARD					=	22
BR_GS_WAIT_NEXT					=	23
BR_GS_REST						=	24

MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY] = MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY] or {}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_GAME_BEGIN] = {send = nil,rec = nil,}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_NOTE] = {send = MSG_GAME_STRUCT.BR_GameNote,rec = MSG_GAME_STRUCT.BR_GameNote,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_NOTEINFO] = {send = nil,rec = MSG_GAME_STRUCT.BR_NoteInfoMsg,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_SEND_CARD] = {send = nil,rec = MSG_GAME_STRUCT.BR_SendCardRsg,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_CONTINUE_END] = {send = nil,rec = MSG_GAME_STRUCT.BR_GameEndMsg,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_GAME_TENDENCE] = {send = nil,rec = MSG_GAME_STRUCT.BR_GameTendenceMsg,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_REQUEST_USERLIST] = {send = nil,rec = MSG_GAME_STRUCT.BR_UserList}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_SEAT_UP] = {send = MSG_GAME_STRUCT.BR_SeatUpC,rec = MSG_GAME_STRUCT.BR_SeatUpS}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_SEAT_DOWN] = {send = nil,rec = MSG_GAME_STRUCT.BR_SeatDown,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_SEAT_NOTE] = {send = nil,rec = MSG_GAME_STRUCT.BR_GameSeatNote,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_NT_INFO] = {send = nil,rec = MSG_GAME_STRUCT.BR_NtInfo,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_NT_UP] = {send = nil,rec = MSG_GAME_STRUCT.BR_NtUp,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_NT_DOWN] = {send = nil,rec = MSG_GAME_STRUCT.BR_NtDown,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_NT_LIST] = {send = nil,rec = MSG_GAME_STRUCT.BR_NtList,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_REQUEST_PRIZEPOOL] = {send = nil,rec = MSG_GAME_STRUCT.BR_PrizePool,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_SHOWP_RRIZE] = {send = nil,rec = MSG_GAME_STRUCT.BR_ShowPrizeInfo,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_SEAT_INFO] = {send = nil,rec = MSG_GAME_STRUCT.BR_SeatUserList}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_NT_DOWN_WAIT] = {send = nil,rec = nil,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_EARLY_OVER_NOTE] = {send = nil,rec = nil,filter = true}
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY][BR_ASS_NOTE_ERROR] = {send = nil,rec = nil,filter = true}



