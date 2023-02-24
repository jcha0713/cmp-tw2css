local source = {}
local opt = {
  fallback = true,
}

---@class cmp-tw2css.source
---@field public is_sorted boolean
---@field public items table<string, string>
source.new = function()
  local self = setmetatable({}, { __index = source })
  self.is_sorted = false
  self.items = {}
  return self
end

---@param user_opt table
source.setup = function(user_opt)
  if user_opt then
    vim.validate({ fallback = { user_opt.fallback, "boolean" } })
    opt = vim.tbl_deep_extend("force", opt, user_opt)
  end
end

--- Checks if the lang is css or scss
---@param lang string
---@return boolean
local function is_stylesheet(lang)
  return lang == "css" or lang == "scss"
end

--- Get the language set to the buffer
---@param bufnr number
local function get_buf_lang(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_get_option(bufnr, "ft")
end

---@return boolean
local function iter_tree(tree)
  local lang = tree:lang()

  if is_stylesheet(lang) then
    return true
  end

  if tree:children() ~= nil then
    for child_lang, child_tree in pairs(tree:children()) do
      if is_stylesheet(child_lang) then
        return true
      else
        return iter_tree(child_tree)
      end
    end
  end

  return false
end

--- Return whether this source is available in the current context or not.
---@return boolean
function source:is_available()
  local bufnr = vim.api.nvim_get_current_buf() or 0
  local buf_lang = get_buf_lang(bufnr)
  local ok, tree = pcall(vim.treesitter.get_parser, bufnr, buf_lang)

  -- if there is no treesitter parser then look at the file extension
  if not ok then
    local filename = vim.fn.expand("%:e")
    if not filename then
      return false
    end
    return is_stylesheet(filename)
  end

  return iter_tree(tree)
end

--- Return the debug name of this source.
---@return string
function source:get_debug_name()
  return "cmp-tw2css"
end

--- Copied from nvim-treesitter.ts_utils
--- Determines whether (line, col) position is in node range
-- @param node Node defining the range
-- @param line A line (0-based)
-- @param col A column (0-based)
local function is_in_node_range(node, line, col)
  local start_line, start_col, end_line, end_col = node:range()
  if line >= start_line and line <= end_line then
    if line == start_line and line == end_line then
      return col >= start_col and col < end_col
    elseif line == start_line then
      return col >= start_col
    elseif line == end_line then
      return col < end_col
    else
      return true
    end
  else
    return false
  end
end

--- Copied from nvim-treesitter.ts_utils
--- Get the root node of the tree
local function get_root_for_position(line, col, root_lang_tree)
  local lang_tree = root_lang_tree:language_for_range({ line, col, line, col })

  for _, tree in ipairs(lang_tree:trees()) do
    local root = tree:root()

    if root and is_in_node_range(root, line, col) then
      return root, tree, lang_tree
    end
  end

  return nil, nil, lang_tree
end

--- Get the items table and sort the items
--- If the table is already sorted, then simply return it
---@return table<string, string> items
function source:get_sorted_items()
  if not self.is_sorted then
    local KIND = require("cmp").lsp.CompletionItemKind
    -- if items table is not sorted, then sort it
    self.items = require("cmp-tw2css.items")()
    table.sort(self.items, function(a, b)
      local kind = KIND.Constant
      for _, val in ipairs({ "color", "stroke:", "fill:" }) do
        if (a.insertText):match(val) then
          kind = KIND.Color
          break
        end
      end
      a.kind = kind
      return a.label < b.label
    end)

    -- the table is now sorted
    self.is_sorted = true
  end

  return self.items
end

--- Invoke completion (required).
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
  local bufnr = vim.api.nvim_get_current_buf() or 0
  local buf_lang = get_buf_lang(bufnr)
  local ok, root_lang_tree = pcall(vim.treesitter.get_parser, bufnr, buf_lang)

  if not ok then
    if opt.fallback then
      local items = source:get_sorted_items()
      callback(items)
    else
      callback()
    end
    return
  end

  local cursor = params.context.cursor
  local cur_line = params.context.cursor_line

  local root = get_root_for_position(cursor.row, cursor.col, root_lang_tree)

  if not root then
    callback()
    return
  end

  local node_at_cursor = root:named_descendant_for_range(
    cursor.row - 1,
    cursor.col - 1,
    cursor.row - 1,
    cursor.col - 1
  )

  -- prevent loading items when the cursor is after the colon
  --- TODO: Allow users to write single line css
  local in_property_name = true
  local idx_colon = string.find(cur_line, ":%s*(%w+)")
  if idx_colon then
    if cursor.col > idx_colon then
      in_property_name = false
    end
  end

  local node_at_cursor_type = node_at_cursor:type()

  if node_at_cursor_type == "block" or node_at_cursor_type == "declaration" then
    if in_property_name then
      local items = source:get_sorted_items()
      callback(items)
      return
    end
  end
  callback()
end

-- require("cmp").register_source("cmp-tw2css", source.new())

return source
