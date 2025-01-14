--[[
    Main kernel source file
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

local k = {}
--#include "src/cmdline.lua"
--#include "src/printk.lua"
--#include "src/checkArg.lua"
--#include "src/errno.lua"
--@[{bconf.BIT32 == 'y' and '#include "src/bit32.lua"' or ''}]
--#include "src/urls/main.lua"
--#include "src/tty.lua"
--#include "src/ttyprintk.lua"
--#include "src/buffer.lua"
--#include "src/filedesc.lua"
--#include "src/fs/main.lua"
--#include "src/scheduler/main.lua"
--#include "src/exec/main.lua"
--#include "src/syscalls.lua"
k.scheduler_loop()
panic("init exited")
