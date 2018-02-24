-- ID                               int                              竞赛ID
-- GameType                         int                              游戏类型，1斗地主，2斗牛-经典看牌
-- Name                             string                           竞赛类型的名称
-- Object                           int                              允许参赛的对象，1为任何玩家，2为月卡玩家
-- GoodId1                          int                              报名需要的物品&资源ID 1金币，2钻石
-- Num1                             int                              需要的数量
-- GoodId2                          int                              报名需要的物品&资源ID 1金币，2钻石
-- Num2                             int                              需要的数量
-- TypeNum                          int                              报名条件类型数量，填1表示只要1种，填2表示同时需要多种
-- NumMin                           int                              人数下限，开赛所需要的最少人数，开赛条件之一
-- NumMax                           int                              人数上限，开赛所需要报名的最多人数，不填表示无上限，开赛条件之一
-- OpenTime                         string                           开赛时间，写具体时间点，填0表示无固定时间，与Interval字段二选一
-- Interval                         int                              开赛间隔（秒），表示多久开赛一次，填0表示不限制或该字段无效
-- CloseTime                        string                           结束时间，竞赛结束时间，填0表示本字段无效
-- FirstReward                      string                           首名奖励，用于竞赛二级界面显示
-- BaseScore                        int                              竞赛初始积分
-- Gold                             int                              每局金币底注，填0表示本竞赛不结算金币，只结算分数
-- LeftScore                        int                              前半段时间每局分数底注，填0表示该字段无效
-- AfterScore                       int                              后半段时间每局分数底注，填0表示该字段无效

return {
	[1] = {
		GameType = 1,
		TypeKind = 1,
		Name = "1万金币即时赛",
		Object = 1,
		GoodId1 = 1,
		Num1 = 2000,
		GoodId2 = 0,
		Num2 = 0,
		TypeNum = 1,
		NumMin = 6,
		NumMax = 6,
		OpenTime = "0",
		Interval = 0,
		CloseTime = "0",
		FirstReward = "3000金币",
		FirstRewardType = 1,
		FirstRewardNum = 1000,
		BaseScore = 3000,
		Gold = 0,
		LeftScore = 0,
		AfterScore = 0,
		iMatchID =	30,
		iAllTime = 18,
		describe = "满3人开赛",
		OpenNumTime = 0,
		Rule = "1轮2副\n3→冠军",
		iPaixu = 1
	},
	[2] = {
		GameType = 1,
		TypeKind = 2,
		Name = "50万金币定时赛",
		Object = 1,
		GoodId1 = 1,
		Num1 = 3000,
		GoodId2 = 0,
		Num2 = 0,
		TypeNum = 1,
		NumMin = 0,
		NumMax = 0,
		OpenTime = "12:00",
		Interval = 0,
		CloseTime = "12:30",
		FirstReward = "50万金币，50钻石",
		FirstRewardType = 3,
		FirstRewardNum = 2,
		BaseScore = 3000,
		Gold = 200,
		LeftScore = 20,
		AfterScore = 40,
		iMatchID =	17,
		iAllTime = 30,
		describe = "12:00-12:30",
		OpenNumTime = 43200,
		Rule = "根据积分结算最终排名",
		iPaixu = 2
	},
	[3] = {
		GameType = 1,
		TypeKind = 2,
		Name = "50万金币定时赛",
		Object = 1,
		GoodId1 = 1,
		Num1 = 3000,
		GoodId2 = 0,
		Num2 = 0,
		TypeNum = 1,
		NumMin = 0,
		NumMax = 0,
		OpenTime = "18:00",
		Interval = 0,
		CloseTime = "18:30",
		FirstReward = "50万金币，50钻石",
		FirstRewardType = 3,
		FirstRewardNum = 5,
		BaseScore = 3000,
		Gold = 200,
		LeftScore = 20,
		AfterScore = 40,
		iMatchID =	19,
		iAllTime = 30,
		describe = "18:00-18:30",
		OpenNumTime = 64800,
		Rule = "根据积分结算最终排名",
		iPaixu = 3
	},
	[4] = {
		GameType = 1,
		TypeKind = 2,
		Name = "50万金币定时赛",
		Object = 1,
		GoodId1 = 1,
		Num1 = 3000,
		GoodId2 = 0,
		Num2 = 0,
		TypeNum = 1,
		NumMin = 0,
		NumMax = 0,
		OpenTime = "20:00",
		Interval = 0,
		CloseTime = "20:30",
		FirstReward = "50万金币，50钻石",
		FirstRewardType = 3,
		FirstRewardNum = 8,
		BaseScore = 3000,
		Gold = 200,
		LeftScore = 20,
		AfterScore = 40,
		iMatchID =	21,
		iAllTime = 30,
		describe = "20:00-20:30",
		OpenNumTime = 72000,
		Rule = "根据积分结算最终排名",
		iPaixu = 4
	},
}
