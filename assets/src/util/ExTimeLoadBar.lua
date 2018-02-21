--
-- Author: Your Name
-- Date: 2015-07-30 16:22:54
--
local ExTimeLoadBar = {}


function ExTimeLoadBar.extend(object)
	if tolua.isnull(object) then
        trace("error:ExTimeLoadBar.extend object is nil")
	    return
	end
	object._timeTick = nil
	object._time = 0
	object._timeMax = 0
	object._timeFormat =nil
	function object:setBar(time)


	end
    --[[
	function object:setTime(time,ctime)
		if not time or (ctime == object._ctime and object._ctime~=nil) then
			return 
		end

		object._ctime = ctime
		object._timeMax = time

		util.bar(object,object._time,object._timeMax)
		local tickFunc = function()
			object._time = object._time + 1
			util.bar(object,object._time,object._timeMax)
			if object._time > object._timeMax then 
				object:dispose()
				return 
			end
		end

		if object._timeTick ~=nil then
			scheduler.unscheduleGlobal(object._timeTick)
		end

		object._timeTick = scheduler.scheduleGlobal(tickFunc,1)

		--自动清除
		object:registerScriptHandler(function(state)
	        if state == "exit" then
	            object:dispose()
	        end
	    end)
	end]]
	
    --加入总时间,以保存进度
    function object:setEndTime(endTime,maxTime)
        if maxTime == 0 then
            object:setTime(endTime,maxTime)
            return
        end
        if endTime == object.endTime and maxTime == object.maxTime then
			return 
		end

        object.endTime = endTime
        object.starttime = endTime - maxTime

        local tickFunc = function()
			local timepass = PlayerData:getServerTime() - object.starttime
			util.bar(object,timepass,maxTime) 	
			if timepass == nil or (timepass >= maxTime) then 
				object:dispose()
                --object.starttime = nil
				return 
			end
		end

		object:dispose()
        local timepass = PlayerData:getServerTime() - object.starttime
		util.bar(object,timepass,maxTime)	
		object._timeTick = scheduler.scheduleGlobal(tickFunc,1)

		--自动清除
		object:registerScriptHandler(function(state)
	        if state == "exit" then
	            object:dispose()
	        end
	    end)
    end
    --上面可能时间上有误差,重写个
    function object:setTime(time,ctime)
		if not time or (ctime == object._ctime and object._ctime~=nil) then
			return 
		end

		object._ctime = ctime

        object.starttime = object.starttime or PlayerData:getServerTime()

		local tickFunc = function()
			local timepass = object.starttime and PlayerData:getServerTime() - object.starttime
			util.bar(object,timepass,time)
			if timepass == nil or (timepass >= time) then 
				object:dispose()
                object.starttime = nil
				return 
			end
		end

		object:dispose()
        local timepass = PlayerData:getServerTime() - object.starttime
		util.bar(object,timepass,time)			
		object._timeTick = scheduler.scheduleGlobal(tickFunc,1)

		--自动清除
		object:registerScriptHandler(function(state)
	        if state == "exit" then
	            object:dispose()
	        end
	    end)
	end

	function object:setTimeExt(time,ctime)
	
		object._time = ctime
		object._timeMax = time

		util.bar(object,object._time,object._timeMax)
		local tickFunc = function()
			object._time = object._time + 1
			util.bar(object,object._time,object._timeMax)
			if object._time > object._timeMax then 
				object:dispose()
				return 
			end
		end

		if object._timeTick ~=nil then
			scheduler.unscheduleGlobal(object._timeTick)
		end

		object._timeTick = scheduler.scheduleGlobal(tickFunc,1)

		--自动清除
		object:registerScriptHandler(function(state)
	        if state == "exit" then
	            object:dispose()
	        end
	    end)
	end

	function object:dispose()
		if object._timeTick ~=nil then
			scheduler.unscheduleGlobal(object._timeTick)
		end
	end

end

return ExTimeLoadBar