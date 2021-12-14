--[[
    A short description.
    Copyright (C) 2021 Ocawesome101

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

k.log(k.L_INFO, "util")

do
  function k.common.pop(str, n)
    local ret = str:sub(1, n)
    str = str:sub(n + 1)
    return ret, str
  end

  function k.common.charize(str)
    local c = {}
    for _c in str:gmatch(".") do c[#c+1] = _c end
    return c
  end
end
