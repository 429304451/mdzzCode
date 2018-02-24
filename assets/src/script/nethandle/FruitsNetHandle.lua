-- 水果机
local FruitsNetHandle = class(...,BaseNetHandle)

function FruitsNetHandle:ctor()
	FruitsNetHandle.super.ctor(self, NETHANDLE.FRUITS)
end

function FruitsNetHandle:fun_ResponseHandle(pActionName, pResponseData)
	if pActionName == _ASS_Syn_GameState_Play then 		--同步基础信息
		_pdm.fruitsMainData:initStartData(pResponseData)
	elseif pActionName == _ASS_RSP_LotteryResult then 	--返回摇奖 1
		_pdm.fruitsMainData:betDataHandle1(pResponseData)
	elseif pActionName == _ASS_Syn_BalanceInfo then 	--返回摇奖结算 2
		_pdm.fruitsMainData:betDataHandle2(pResponseData)
	elseif pActionName == _ASS_Rsp_LastGetPrizePoolUserInfo then 	--返回最后一个获取奖池奖励的玩家
		_pdm.fruitsMainData:updatePrizePoolUserInfo(pResponseData)
	elseif pActionName == _ASS_Syn_ShowUserInfo then 	--展示的玩家信息
		_pdm.fruitsMainData:initOnSetPlayer(pResponseData)
	elseif pActionName == _ASS_Syn_ShowUserInfo_Change then 		--同步上位玩家信息变更
		_pdm.fruitsMainData:updateOnSetPlayer(pResponseData)
	end
	return pResponseData
end

function FruitsNetHandle:fun_RequestFilter(pActionName, pRequestData)
	-- if pActionName == ProtobufModule.email.email_detail.name then -- 邮件详情请求
	-- 	return _pdm.mailData:existDetailData(pRequestData.playerEmailId)
	-- end

	return nil
end

return FruitsNetHandle

