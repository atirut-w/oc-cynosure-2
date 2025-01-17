--[[
    Main process implementation
    Copyright (C) 2022 Ocawesome101

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
  ]]--

printk(k.L_INFO, "scheduler/process")

do
  -- Much of the heavy lifting is done in scheduler/thread.lua in
  -- thread:resume().  The process's job is to act like a mini-scheduler of
  -- sorts.
  local process = {}
  local default = {n = 0}
  function process:resume(sig, ...)
    if self.stopped then return end

    local resumed = false
    if sig and #self.queue < 256 then
      self.queue[#self.queue + 1] = sig
    end

    local signal = default
    if #self.queue > 0 then
      signal = table.remove(self.queue, 1)
    end

    for i, thread in pairs(self.threads) do
      local result = thread:resume(table.unpack(signal, 1, signal.n))
      resumed = resumed or not not result

      if result == 1 then
        self.threads[i] = nil
        table.insert(self.queue, {"thread_died", i})
      end
    end

    return resumed
  end

  function process:add_thread(thread)
    self.threads[self.pid + self.thread_count] = thread
    self.thread_count = self.thread_count + 1
  end

  function process:deadline()
    local deadline = math.huge
    for i, thread in pairs(self.threads) do
      if thread.deadline < deadline then
        deadline = thread.deadline
      end
      if thread.status == "S" or thread.status == "y" then
        return -1
      end
      if thread.status == "w" and #self.queue > 0 then
        return -1
      end
    end
    return deadline
  end

  local process_mt = { __index = process }

  local default = {handles = {}, _G = {}, pid = 0}

  function k.create_process(pid, parent)
    parent = parent or default
    return setmetatable({
      -- local signal queue
      queue = {},
      -- whether this process is stopped
      stopped = false,
      -- all the threads
      threads = {},
      
      -- process ID
      pid = pid,
      -- parent process ID
      ppid = parent.pid,
      
      -- process group ID
      pgid = parent.pgid or 0,
      -- session ID
      sid = parent.sid or 0,

      -- real user ID
      uid = parent.uid or 0,
      -- real group ID
      gid = parent.gid or 0,
      -- effective user/group ID
      euid = parent.euid or 0,
      egid = parent.egid or 0,
      -- saved user/group ID
      suid = parent.uid or 0,
      sgid = parent.gid or 0,

      -- controlling TTY
      tty = false,
    }, process_mt)
  end
end
