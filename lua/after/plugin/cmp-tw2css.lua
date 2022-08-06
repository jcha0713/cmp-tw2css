local ok, cmp = pcall(require, "cmp")
if ok then
  cmp.register_source("cmp-tw2css", require("cmp-tw2css").new())
end
