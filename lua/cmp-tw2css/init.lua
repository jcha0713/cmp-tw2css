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
-- @param params cmp.SourceCompletionApiParamsi
-- @param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
  -- custom sorting
  local items = require("cmp-tw2css.items")()

  table.sort(items, function(a, b)
    return a.label < b.label
  end)

  callback(items)
end

return source
