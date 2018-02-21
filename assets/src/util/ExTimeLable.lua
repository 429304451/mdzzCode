
--
-- Author: Your Name
-- Date: 2015-07-30 16:22:54
--
local ExTimeLable = {}


function ExTimeLable.extend(object)
	if object._timeTick or tolua.isnull(object) then
        if tolua.isnull(object) then
            trace("error:ExTimeLable.extend object is nil")
        end
	    return
	end
	object._timeTick = nil
	object._time = 0
	object._timeFormat =nil


	--[[function object:setTime(time,headFormat,timeformat,ctime,callbackFunc)
		if not time or (ctime == object._ctime and object._ctime~=nil) then
			return 
		end

		object._time = time
		object._headFormat = headFormat or "%s"
		object._timeFormat = timeformat

		local tickFunc = function()
			object._time = object._time -1
			if object._time <=-1 then 
				object:dispose()
				if callbackFunc then
					callbackFunc()
				end
				return 
			end
			object:setString(string.format(object._headFormat,util.timeFormat(object._time,object._timeFormat)))
		end

		object:dispose()

		if time > 0 then 
			object:setString(string.format(object._headFormat,util.timeFormat(object._time,object._timeFormat)))
			object._timeTick = scheduler.scheduleGlobal(tickFunc,1)
		else
			object:setString("")
		end
		--自动清除
		object:registerScriptHandler(function(state)
	        if state == "exit" then
	            object:dispose()
	        end
	    end)
	end]]
    function object:removeTimeCallBacks()
        if tolua.isnull(object) then
            return
        end
        object._repeatTicks = nil
        object._callbacks = nil
    end
    --添加某时刻的回调,time为时间数或函数,Repeat为真是,time为间隔时间,一直循环
    function object:addTimeCallBack(time,callbackFunc,Repeat)
        if tolua.isnull(object) then
            return
        end
        if Repeat then
            object._repeatTicks = object._repeatTicks or {}
            table.insert(object._repeatTicks,{time = time,fun = callbackFunc})
        else
            object._callbacks = object._callbacks or {}
            object._callbacks[time] = callbackFunc
        end
        object:doCallBacks()
    end
    
    function object:doCallBacks()
        if tolua.isnull(object) then
            return
        end
        if object._timeRemain then
            if object._callbacks then
                for i,j in pairs(object._callbacks) do
                    local time = type(i)=="function" and i() or i
                    if type(j)=="function" and time>=object._timeRemain then
                        object._callbacks[i] = nil
                        j()
                    end
                end
            end
            if object._repeatTicks then
                for i,j in pairs(object._repeatTicks) do
                    local time = j.time
                    if type(time)=="function" then
                        time = time()
                    end
                    local now = PlayerData:getServerTime()
                    j.lastTime = j.lastTime or now
                    if now - j.lastTime >= time then
                        j.lastTime = now
                        j.fun()
                    end
                end
            end
        end
    end

    function object:resetTime(time)
        object.endtime = time + PlayerData:getServerTime()
    end
    --上面可能时间上有误差,重写个--timeformat弃用
   function object:setTime(time,headFormat,timeformat,callbackFunc)
        if not time or type(time)~="number" then
			return 
		end
		headFormat = headFormat or "%s"
       object.endtime = time + PlayerData:getServerTime()
       local tickFunc = function()
            if tolua.isnull(object) then
                return
            end
			object._timeRemain = object.endtime - PlayerData:getServerTime()
            object:doCallBacks()
			if object._timeRemain <=0 and not tolua.isnull(object) then 
				object:dispose()
				if callbackFunc then
					callbackFunc()
				end
				return 
			end
			object:setString(string.format(headFormat,math.ceil(object._timeRemain)))
            --object:setString(math.floor(object._timeRemain))
		end

        object:dispose()
        --tickFunc()--这个引起死循环?
       object._timeRemain = object.endtime - PlayerData:getServerTime()
        if object._timeRemain>0 then
            object:setString(string.format(headFormat,math.ceil(object._timeRemain)))
            --object:setString(math.floor(object._timeRemain))
        end

        object._timeTick = scheduler.scheduleGlobal(tickFunc,0.1)
        		--自动清除
		object:registerScriptHandler(function(state)
	        if state == "exit" then
	            object:dispose()
	        end
	    end)
    end

    function object:getTime()
		return  object._timeRemain or 0
	end

	function object:reset()
		object:dispose()
	end

	function object:dispose()
        object._timeRemain = nil
        object._callbacks = nil
		object:setString("")
		if object._timeTick ~=nil then
			scheduler.unscheduleGlobal(object._timeTick)
		end
	end

end

return ExTimeLable