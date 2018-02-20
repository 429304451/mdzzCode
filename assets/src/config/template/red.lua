-- ID                               int                              红包ID
-- Type                             int                              红包类型，1常规红包，2提示红包
-- CashMin                          int                              单个红包金额下限,若是常规红包，cashmin和cashmax必须相同
-- CashMax                          int                              单个红包金额上限,填0表示无上限
-- RobTimes                         int                              最多可被抢的次数
-- ShowTimes                        int                              可显示的次数,填0表示无限制
-- NumMin                           int                              可被抢的最小金额
-- NumMax                           int                              可被抢的最大金额
-- DelayTime                        int                              红包可保留最长时间，秒

return {
	[1] = {
		Type = 1,
		CashMin = 2000,
		CashMax = 2000,
		RobTimes = 4,
		ShowTimes = 6,
		NumMin = 1,
		NumMax = 1800,
		DelayTime = 1800,
	},
	[2] = {
		Type = 1,
		CashMin = 10000,
		CashMax = 10000,
		RobTimes = 15,
		ShowTimes = 15,
		NumMin = 1,
		NumMax = 8000,
		DelayTime = 3600,
	},
	[3] = {
		Type = 1,
		CashMin = 50000,
		CashMax = 50000,
		RobTimes = 75,
		ShowTimes = 75,
		NumMin = 1,
		NumMax = 25000,
		DelayTime = 10800,
	},
	[4] = {
		Type = 2,
		CashMin = 500,
		CashMax = 2000,
		RobTimes = 4,
		ShowTimes = 4,
		NumMin = 100,
		NumMax = 1000,
		DelayTime = 1800,
	},
	[5] = {
		Type = 2,
		CashMin = 2001,
		CashMax = 10000,
		RobTimes = 10,
		ShowTimes = 10,
		NumMin = 100,
		NumMax = 2000,
		DelayTime = 1800,
	},
	[6] = {
		Type = 2,
		CashMin = 10001,
		CashMax = 50000,
		RobTimes = 50,
		ShowTimes = 50,
		NumMin = 100,
		NumMax = 3000,
		DelayTime = 3600,
	},
	[7] = {
		Type = 2,
		CashMin = 50001,
		CashMax = 0,
		RobTimes = 100,
		ShowTimes = 100,
		NumMin = 100,
		NumMax = 4000,
		DelayTime = 10800,
	},
}
