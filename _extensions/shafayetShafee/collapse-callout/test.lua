local my_key_values = {}

function Meta(meta)
  for key, value in pairs(meta.mymeta) do
    my_key_values[key] = value
  end
end

-- thank you copilot
local function by_sorted_keys(t)
  local keys = {}
  for k in pairs(t) do table.insert(keys, k) end
  table.sort(keys)
  local i = 0      -- iterator variable
  local iter = function ()   -- iterator function
    i = i + 1
    if keys[i] == nil then return nil
    else return keys[i], t[keys[i]]
    end
  end
  return iter
end

function Header(element)
  if element.level == 1 then
    local plain = pandoc.Para({})

    for key, value in by_sorted_keys(my_key_values) do
      plain.content:insert(pandoc.Strong(pandoc.Str(key .. ": ")))
      plain.content:extend(value)
      plain.content:insert(pandoc.SoftBreak())
    end
    local placeholder = pandoc.Note(plain)
    element.content:insert(placeholder)

    return element
  else
    return nil
  end
end

return {
  {Meta = Meta},
  {Header = Header}
}