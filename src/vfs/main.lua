-- a fairly smart filesystem mounting arrangement --

do
  local mounts = {}

  local function split_path(path)
    local segments = {}
    for part in path:gmatch("[^/]+") do
      if part == ".." then
        segments[#segments] = nil
      elseif part ~= "." then
        segments[#segments + 1] = part
      end
    end
    return segments
  end

  local function clean_path(path)
    if path:sub(1,1) ~= "/" then
      path = k.syscall.getcwd() .. "/" .. path
    end
    return "/" .. table.concat(split_path(path), "/")
  end

  local function find_node(path)
    path = clean_path(path)
    local node, longest = nil, 0
    for _path, _node in pairs(mounts) do
      if path:sub(1, #_path) == _path and #_path > longest then
        longest = #_path
        node = _node
      end
    end
    if not node then
      return nil, k.errno.ENOENT
    end
  end

  local fds = {}

  function k.syscall.creat(path, mode)
    checkArg(1, path, "string")
    checkArg(2, mode, "number")
    return k.syscall.open(path, {
      creat = true,
      wronly = true,
      trunc = true
    }, mode)
  end

  function k.syscall.mkdir()
  end

  function k.syscall.link()
  end

  function k.syscall.open(path, flags, mode)
    checkArg(1, path, "string")
    checkArg(2, flags, "table")
    local node, err = find_node(path)
    if node and flags.creat and flags.excl then
      return nil, k.errno.EEXIST
    end
    if not node then
      if flags.creat then
        checkArg(3, mode, "number")
        local parent, err = find_node(path:match("(.+)/..-$"))
        if not parent then
          return nil, err
        end
        local fd, err = parent:creat(clean_path(err .. "/"
          .. path:match(".+/(..-)$")), mode)
        if not fd then
          return nil, err
        end
        parent:close(fd)
      else
        return nil, err
      end
    end
  end

  function k.syscall.read()
  end

  function k.syscall.write()
  end

  function k.syscall.seek()
  end

  function k.syscall.close()
  end

  function k.syscall.mount(source, target, fstype, mountflags, fsopts)
    checkArg(1, source, "string")
    checkArg(2, target, "string")
    checkArg(3, fstype, "string")
    checkArg(4, mountflags, "table", "nil")
    checkArg(5, fsopts, "table", "nil")
  end

  function k.syscall.mount(target)
    checkArg(1, target, "string")
  end
end