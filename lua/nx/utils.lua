local _M = {}

_M.map = function(ls, fun)
  local out = {}

  for index, value in ipairs(ls) do
    table.insert(out, fun(value, index))
  end
  return out
end

_M.deepcopy = function(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[_M.deepcopy(orig_key)] = _M.deepcopy(orig_value)
    end
    setmetatable(copy, _M.deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

_M.keys = function(orig)
  local out = {}

  if not orig then
    return {}
  end

  for key, _ in pairs(orig) do
    table.insert(out, key)
  end

  return out
end

_M.dump = function(o, level)
  level = level or 1

  local indent = string.rep('  ', level)

  if type(o) == 'table' then
    local s = '{\n'
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s
          .. indent
          .. '['
          .. k
          .. '] = '
          .. _M.dump(v, level + 1)
          .. ',\n'
    end
    return s .. string.rep('  ', level - 1) .. '}'
  else
    return tostring(o)
  end
end

_M.pd = function(o)
  print(_M.dump(o))
end

function _M.split_on_space(str)
  local words = {}

  for word in str:gmatch '%w+' do
    table.insert(words, word)
  end

  return words
end

function _M.concat(lsa, lsb)
  for _, item in ipairs(lsb) do
    table.insert(lsa, item)
  end
  return lsa
end

function _M.merge(tba, tbb)
  local output = {}

  for key, item in pairs(tba) do
    table[key] = item
  end
  for key, item in pairs(tbb) do
    table[key] = item
  end

  return output
end

return _M
