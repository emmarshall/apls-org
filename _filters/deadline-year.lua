--- deadline-year.lua --------------------------------------------------------
--- Pandoc/Quarto filter that appends the correct year to "Month Day"
--- deadline strings found in  submission-info.deadline  YAML metadata.
---
--- Logic (mirrors the original inline-R):
---   If today is past the deadline date this year  ->  show next year
---   Otherwise                                     ->  show this year
---
--- Supports both single-value and list deadlines, and preserves any
--- trailing note such as "(Pre-proposal)".
--- Strings that already contain a four-digit year are left untouched.
--------------------------------------------------------------------------

local months = {
  January = 1, February = 2, March = 3, April = 4,
  May = 5, June = 6, July = 7, August = 8,
  September = 9, October = 10, November = 11, December = 12
}

--- Return the next upcoming year for a Month + Day deadline.
local function next_deadline_year(month_name, day)
  local m = months[month_name]
  if not m then return nil end
  local d = tonumber(day)
  if not d then return nil end

  local now = os.date("*t")
  if now.month > m or (now.month == m and now.day > d) then
    return now.year + 1
  else
    return now.year
  end
end

--- Append the computed year to a deadline string.
--- "December 15"               ->  "December 15, 2026"
--- "October 15 (Pre-proposal)" ->  "October 15, 2026 (Pre-proposal)"
--- "December 15, 2025"         ->  left unchanged (already has a year)
local function process_deadline(text)
  -- Already has a 4-digit year? Leave it alone.
  if text:match("%d%d%d%d") then return text end

  local month_name, day_str = text:match("^(%a+)%s+(%d+)")
  if not month_name then return text end

  local year = next_deadline_year(month_name, tonumber(day_str))
  if not year then return text end

  -- Split into "Month Day" prefix and any remaining suffix
  local prefix = month_name .. " " .. day_str
  local suffix = text:sub(#prefix + 1) or ""

  return prefix .. ", " .. tostring(year) .. suffix
end

--- Walk the submission-info.deadline metadata and transform each entry.
function Meta(meta)
  local si = meta["submission-info"]
  if not si then return meta end

  local deadlines = si.deadline
  if not deadlines then return meta end

  local dtype = pandoc.utils.type(deadlines)

  if dtype == "Inlines" then
    local text = pandoc.utils.stringify(deadlines)
    local result = process_deadline(text)
    if result ~= text then
      si.deadline = pandoc.MetaInlines({ pandoc.Str(result) })
    end

  elseif dtype == "List" then
    for i, item in ipairs(deadlines) do
      local text = pandoc.utils.stringify(item)
      local result = process_deadline(text)
      if result ~= text then
        deadlines[i] = pandoc.MetaInlines({ pandoc.Str(result) })
      end
    end
  end

  return meta
end
