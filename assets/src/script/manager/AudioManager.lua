--音效管理
AudioManager = {}
_am = AudioManager
_am.__cname = "AudioManager"

function AudioManager:fun_init()
	self.Audio = {}
	-- self.Audio.musicVol = _gm.DynamicConfig.musicVol or 1
	-- self.Audio.soundVol = _gm.DynamicConfig.soundVol or 1

	self.Audio.musicEnable = util.getEnableMusic()
	self.Audio.soundEnable = util.getEnableSound()

	--当前播放背景声
	self.playingMusic = ""

	-- self:setMusicVolume(self.Audio.musicVol)
	-- self:setEffectsVolume(self.Audio.soundVol)
end

--保存配置
function AudioManager:saveAudioSetting()
 	_gm.DynamicConfig.musicVol = self.Audio.musicVol
 	_gm.DynamicConfig.soundVol = self.Audio.soundVol
 	_gm.DynamicConfig.musicEnable = self.Audio.musicEnable
 	_gm.DynamicConfig.soundEnable = self.Audio.soundEnable
	_gm.DynamicConfig:saveAccount()
end

--设置音乐
function AudioManager:setMusicName(pName)
	self.playingMusic = pName
end

--设置音乐开关
function AudioManager:setEnableMusic(enable)
	self.Audio.musicEnable = enable
	if self.Audio.musicEnable then
		self:playMusic(self.playingMusic ,true)
	else
		self:stopMusic()
	end
	-- self:saveAudioSetting()
end

--设置音效开关
function AudioManager:setEnableSound(enable)
	self.Audio.soundEnable = enable
	if not self.Audio.soundEnable then
		self:stopAllEffects()
	end
	-- self:saveAudioSetting()
end

--播放背景声音
function AudioManager:playMusic(pName ,pLoop)
	self.playingMusic = pName
	if self.Audio.musicEnable then
	    cc.SimpleAudioEngine:getInstance():playMusic(pName, true)
        trace("lw AudioManager.playMusic " .. pName .. "  is Loop " .. toint(pLoop))
	end
end

--播放音效
function AudioManager:playEffect(pName ,pLoop)
	if self.Audio.soundEnable then
	    local pLoop = false
	    if nil ~= isLoop then
	        pLoop = isLoop
	    end
	    return cc.SimpleAudioEngine:getInstance():playEffect(pName, pLoop)
	end
end

--设置背景乐音量
function AudioManager:setMusicVolume(volume)
	self.Audio.musicVol = volume
	cc.SimpleAudioEngine:getInstance():setMusicVolume(volume)
end

--设置音效音量
function AudioManager:setEffectsVolume(volume)
	self.Audio.soundVol = volume
	cc.SimpleAudioEngine:getInstance():setEffectsVolume(volume)
end

--关闭背景声音
function AudioManager:closeMusic()
	self.playingMusic = ""
    local releaseDataValue = false
    if nil ~= isReleaseData then
        releaseDataValue = isReleaseData
    end
    cc.SimpleAudioEngine:getInstance():stopMusic(releaseDataValue)
end

--暂停背景乐
function AudioManager:pauseMusic()
    cc.SimpleAudioEngine:getInstance():pauseMusic()
end

--恢复背景乐
function AudioManager:resumeMusic()
    cc.SimpleAudioEngine:getInstance():resumeMusic()
end

--关闭所有音效
function AudioManager:stopAllEffects()
	cc.SimpleAudioEngine:getInstance():stopAllEffects()
end	

--预加载背景声音
function AudioManager:preloadMusic(pName, func)
	cc.SimpleAudioEngine:getInstance():preloadMusic(string.format("audio/%s", pName))
	func()
end

--预加载音效
function AudioManager:preloadEffect(pName, func)
	cc.SimpleAudioEngine:getInstance():preloadEffect(string.format("audio/%s", pName))
	func()
end

function AudioManager:pauseEffect(handle)
    cc.SimpleAudioEngine:getInstance():pauseEffect(handle)
end

function AudioManager:resumeAllEffects(handle)
    cc.SimpleAudioEngine:getInstance():resumeAllEffects()
end

function AudioManager:resumeEffect(handle)
    cc.SimpleAudioEngine:getInstance():resumeEffect(handle)
end

function AudioManager:stopEffect(handle)
    cc.SimpleAudioEngine:getInstance():stopEffect(handle)
end

function AudioManager:stopMusic(isReleaseData)
    local releaseDataValue = false
    if nil ~= isReleaseData then
        releaseDataValue = isReleaseData
    end
    cc.SimpleAudioEngine:getInstance():stopMusic(releaseDataValue)
end
