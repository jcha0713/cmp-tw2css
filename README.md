# cmp-tw2css

A source for [`nvim-cmp`](https://github.com/hrsh7th/nvim-cmp) to convert [tailwindcss](https://tailwindcss.com) classes to pure css codes.
It uses treesitter to find out whether any css code block exists in the code and load the completion source.

## Setup

### Prerequisites:

`cmp-tw2css` uses `nvim-cmp` to provide the code. You first need to have `nvim-cmp` installed in your neovim. To install `nvim-cmp`, please visit the [nvim-cmp Github repo](https://github.com/hrsh7th/nvim-cmp).

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

Using `cmp-tw2css` is simple. Open any file that contains css code blocks and start typing tailwindcss classes that you want to convert into css codes.

### Example

![demo](./extra/demo.gif)

- `*.css`:

```css
body {
  /* flex -> display: flex; */
  /* p-6 -> padding: 1.5rem; */
  /* ... */
}
```

- `*.html`:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <style>
      body {
        /* m-2 -> margin: 0.5rem; */
      }
    </style>
  </head>
  <body>
    <!-- body -->
  </body>
</html>
```

## Limitation

There are a number of limitations to `cmp-tw2css`. First, the source of this plugin is a result of web scraping. This means that you might find some items are missing while using. If this happens to you, please let me know by submitting an issue so that I can update the source accordingly. Another downside is that it can't be dynamically generated and only provides the code from the official website. 

Currently `cmp-tw2css` does not automatically add tabs for the additional lines when the insert text is more than one line. And also when there are more than one colon(`:`), `cmp-tw2css` cannot properly load its completion source.

## Roadmap

- [x] Load the source only when the cursor is inside the code block
- [ ] Provide ways to configure with treesitter
- [ ] Show documentation when selecting an item...?

## Credit

- [`cmp-emoji`](https://github.com/hrsh7th/cmp-emoji)
- [`cmp-npm`](https://github.com/David-Kunz/cmp-npm)
- [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
