-- ID                               int                              场类型ID
-- name                             string                           斗地主场次名称
-- gold1                            int                              进入需要的欢乐豆数量下限
-- gold2                            int                              进入需要的欢乐豆数量上限
-- num1                             int                              佣金，每场比赛系统收取欢乐豆
-- num2                             int                              底注
-- base                             int                              基础倍数
-- win                              int                              每局赢取欢乐豆的上限
-- sunmin                           int                              太阳树奖励下限太阳树奖励上限
-- summax                           int                              太阳数

return {
	[1] = {
		name = "新手场",
		gold1 = 1000,
		gold2 = 7000,
		num1 = 150,
		num2 = 100,
		base = 1,
		win = 0,
		sunmin = 0,
		summax = 0,
	},
	[2] = {
		name = "初级场",
		gold1 = 6000,
		gold2 = 50000,
		num1 = 300,
		num2 = 400,
		base = 1,
		win = 0,
		sunmin = 0,
		summax = 0,
	},
	[3] = {
		name = "中级场",
		gold1 = 50000,
		gold2 = 0,
		num1 = 1500,
		num2 = 2000,
		base = 1,
		win = 0,
		sunmin = 0,
		summax = 0,
	},
	[4] = {
		name = "高级场",
		gold1 = 200000,
		gold2 = 0,
		num1 = 6000,
		num2 = 8000,
		base = 1,
		win = 0,
		sunmin = 0,
		summax = 0,
	},
}
