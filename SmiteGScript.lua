LAUGH = 5
TAUNT = 4
JOKE = 6
current = -1
name = ""
function spamMacros()
  local f = true
  local first = true
  name = (current == LAUGH) and "Laugh" or (current == TAUNT) and "Taunt" or "Joke"
  while f do
    PlayMacro(name)
    if first then
      f = TaskSleep(250)
    else
      f = TaskSleep(10)
    end

  end
  return -1
end

function OnEvent(event, arg, family)
  local st = StateTimer
  if  event == "MOUSE_BUTTON_PRESSED" then
    if (arg == LAUGH or arg == TAUNT or arg == JOKE) then
      InitPolling() 
      current = arg
      RunTask("Test", spamMacros)
    end
  end
  if event == "MOUSE_BUTTON_RELEASED" then
    if (arg == LAUGH or arg == TAUNT or arg == JOKE) then
    AbortTask("Test")
    end
  end
  DoTasks()
  Poll(event, arg, family, st)
end

POLL_FAMILY = "mouse" -- current mice don't have M-states, so this is a good choice
POLL_INTERVAL = 10  -- delay (in milliseconds) before next loop, used to throttle polling rate
POLL_DEADTIME = 100 -- settling time (in milliseconds) during which old poll events are drained

function InitPolling()
  ActiveState = GetMKeyState_Hook(POLL_FAMILY)
  SetMKeyState_Hook(ActiveState, POLL_FAMILY)
end

function Poll(event, arg, family, st)
  if st == nil and StateTimer ~= nil then return end
  local t = GetRunningTime()
  if family == POLL_FAMILY then
    if event == "M_PRESSED" and arg ~= ActiveState then
      if StateTimer ~= nil and t >= StateTimer then StateTimer = nil end
      if StateTimer == nil then ActiveState = arg end
      StateTimer = t + POLL_DEADTIME
    elseif event == "M_RELEASED" and arg == ActiveState then
      Sleep(POLL_INTERVAL)
      SetMKeyState_Hook(ActiveState, POLL_FAMILY)
    end
  end
end

GetMKeyState_Hook = GetMKeyState
GetMKeyState = function(family)
  family = family or "kb"
  if family == POLL_FAMILY then
    return ActiveState
  else
    return GetMKeyState_Hook(family)
  end
end

SetMKeyState_Hook = SetMKeyState
SetMKeyState = function(mkey, family)
  family = family or "kb"
  if family == POLL_FAMILY then
    if mkey == ActiveState then return end
    ActiveState = mkey
    StateTimer = GetRunningTime() + POLL_DEADTIME
  end
  return SetMKeyState_Hook(mkey, family)
end


-- Task Management functions

TaskList = {}

function DoTasks()
  local t = GetRunningTime()
  for key, task in pairs(TaskList) do
    if t >= task.time then
      local s, d = coroutine.resume(task.task, task.run)
      if (not s) or ((d or -1) &lt; 0) then
        TaskList[key] = nil
      else
        task.time = task.time + d
      end
    end
  end
end

function RunTask(key, func, ...)
  AbortTask(key)
  local task = {}
  task.time = GetRunningTime()
  task.task = coroutine.create(func)
  task.run = true
  local s, d = coroutine.resume(task.task, ...)
  if (s) and ((d or -1) >= 0) then
    task.time = task.time + d
    TaskList[key] = task
  end
end

function StopTask(key)
  local task = TaskList[key]
  if task ~= nil then task.run = false end
end

function AbortTask(key)
  local task = TaskList[key]
  if task == nil then return end
  while true do
    local s, d = coroutine.resume(task.task, false)
    if (not s) or ((d or -1) &lt; 0) then
      TaskList[key] = nil
      return
    end
  end
end

function TaskRunning(key)
  local task = TaskList[key]
  if task == nil then return false end
  return task.run
end

function TaskSleep(delay)
  return coroutine.yield(delay)
end
