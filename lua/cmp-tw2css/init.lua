local source = {}

-- Constructor function
source.new = function()
  local self = setmetatable({}, { __index = source })
  return self
end

-- Return whether this source is available in the current context or not (optional).
-- @return boolean
function source:is_available()
  -- it only works for files end with *.css, *.scss, and *.less
  local filename = vim.fn.expand("%:e")
  return filename == "css" or filename == "scss" or filename == "less"
end

-- Return the debug name of this source (optional).
-- @return string
function source:get_debug_name()
  return "cmp-tw2css"
end

-- Invoke completion (required).
-- @param params cmp.SourceCompletionApiParams
-- @param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
  -- load json file
  local classTable = vim.fn.json_decode(
    vim.fn.readfile(vim.fn.expand("./tw.json"))
  )

  local items = {}
  for key, value in pairs(classTable) do
    table.insert(items, {
      word = key,
      label = key,
      insertText = value,
      filterText = key,
      detail = value,
    })
  end

  -- custom sorting
  table.sort(items, function(a, b)
    return a.label < b.label
  end)

  callback(items)
end

return source
