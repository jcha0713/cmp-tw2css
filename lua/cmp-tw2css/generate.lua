local M = {}

M._read = function(path)
  return vim.fn.json_decode(vim.fn.readfile(path))
end

M._write = function(path, data)
  local writer = io.open(path, "w")
  writer:write(data)
  io.close(writer)
end

M.to_item = function(key, value)
  return (
    "{ word = '%s', label = '%s', insertText = [[%s]], filterText = '%s', detail = [[%s]] };\n"
  ):format(key, key, value, key, value)
end

M.update = function()
  -- load json file
  local classTable = vim.fn.json_decode(
    vim.fn.readfile(vim.fn.expand("%:p:h") .. "/tw.json")
  )

  local items = ""
  for key, value in pairs(classTable) do
    items = items .. M.to_item(key, value)
  end
  M._write("./items.lua", ("return function() return {\n%s} end"):format(items))
end

M.update()

return M
