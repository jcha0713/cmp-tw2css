# cmp-tw2css

A source for [`nvim-cmp`](https://github.com/hrsh7th/nvim-cmp) to convert [tailwindcss](https://tailwindcss.com) classes to pure css codes.

## Setup
----------

### Prerequisites:

`cmp-tw2css` uses `nvim-cmp` to provide the code. You first need to have `nvim-cmp` installed in your neovim. To install `nvim-cmp`, please visit the [Github repo](https://github.com/hrsh7th/nvim-cmp).

### Installation

To install `cmp-tw2css`, I recommend using [`packer.nvim`](https://github.com/wbthomason/packer.nvim).

```lua
use({
  "hrsh7th/nvim-cmp",
  requires = {
    "jcha0713/cmp-tw2css",
  },
})
```

And to add source, go to `nvim-cmp` configuration and add the following

```lua
require('cmp').setup {
  -- ...
  sources = {
    { name = 'cmp-tw2css' },
    -- other sources ...
  },
  -- ...
}
```

## Usage
----------

Using `cmp-tw2css` is simple. Open any file with `.css`, `.scss`, or `.less` extension and start typing tailwindcss class that you want to convert to css codes.

### Example

```css
body {
  /* flex -> display: flex; */
  /* p-6 -> padding: 1.5rem; */
  /* ... */
}
```

## Limitation
----------

There are a number of limitations to `cmp-tw2css`. First, the source of this plugin is a result of web scraping. This means that you might find some items are missing while using. If this happens to you, please let me know by submitting an issue so that I can update the source accordingly. Another downside is that it can't be dynamically generated and only provides the code from the official website. 

## Roadmap
----------

- Load the source only when the cursor is in the code block
- Let the users to decide which type of file they want to use (css / scss / less)

## Credit
----------

- [`cmp-emoji`](https://github.com/hrsh7th/cmp-emoji)
- [`cmp-npm`](https://github.com/David-Kunz/cmp-npm)

----------
Last updated date of tailwindcss class lists: 8/6/2022
