--[[
License : GLPv3, see LICENCE in root of repository

Authors : Nikolay Fiykov, v1
--]]
local lu = require("luaunit")
local nodemcu = require("nodemcu")

function testFireOnceTimer()
  nodemcu.reset()
  local fncCalled = 0
  local t = tmr.create()
  t:register(
    1,
    tmr.ALARM_SINGLE,
    function(timerObj)
      fncCalled = 1
      timerObj:unregister()
    end
  )
  lu.assertTrue(t:start())
  nodemcu.advanceTime(100)
  lu.assertEquals(fncCalled, 1)
end

function testFileOnceStaticTimer()
  nodemcu.reset()
  local fncCalled = 0
  tmr.register(
    3,
    1,
    tmr.ALARM_SINGLE,
    function(timerObj)
      fncCalled = 2
      tmr.unregister(3)
    end
  )
  lu.assertTrue(tmr.start(3))
  nodemcu.advanceTime(100)
  lu.assertEquals(fncCalled, 2)
end

function testAlarmMethod()
  nodemcu.reset()
  local fncCalled = 0
  lu.assertTrue(
    tmr.create():alarm(
      1,
      tmr.ALARM_SINGLE,
      function(timerObj)
        fncCalled = 1
        timerObj:unregister()
      end
    )
  )
  nodemcu.advanceTime(100)
  lu.assertEquals(fncCalled, 1)
end

function testAlarmmethofForStatisTimer()
  nodemcu.reset()
  local fncCalled = 0
  lu.assertTrue(
    tmr.alarm(
      5,
      1,
      tmr.ALARM_SINGLE,
      function(timerObj)
        fncCalled = 1
        tmr.unregister(5)
      end
    )
  )
  nodemcu.advanceTime(100)
  lu.assertEquals(fncCalled, 1)
end

function testReoccurringAlarm()
  nodemcu.reset()
  local fncCalled = 0
  local t = tmr.create()
  t:register(
    1,
    tmr.ALARM_AUTO,
    function(timerObj)
      fncCalled = fncCalled + 1
      timerObj:start()
    end
  )
  nodemcu.advanceTime(5)
  lu.assertEquals(fncCalled, 0)
  lu.assertTrue(t:start())
  nodemcu.advanceTime(5)
  lu.assertEquals(fncCalled, 5)
  t:unregister()
end

function testSemiTimer()
  nodemcu.reset()
  local cnt = 0
  local t = tmr.create()
  t:register(
    2,
    tmr.ALARM_SEMI,
    function()
      cnt = cnt + 1
    end
  )
  nodemcu.advanceTime(10)
  lu.assertEquals(cnt, 0)
  t:start()
  nodemcu.advanceTime(10)
  lu.assertEquals(cnt, 1)
  t:start()
  nodemcu.advanceTime(10)
  lu.assertEquals(cnt, 2)
end

os.exit(lu.run())
