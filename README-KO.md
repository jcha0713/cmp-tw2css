# cmp-tw2css

`cmp-tw2css`는 [`nvim-cmp`](https://github.com/hrsh7th/nvim-cmp) 엔진을 사용하여 [tailwindcss](https://tailwindcss.com) 클래스를 css 코드로 완성해주는 플러그인입니다.
Neovim에 내장된 treesitter 라이브러리를 이용하여 파일 내의 css 코드 블록 여부를 확인하고 그에 따라 자동 완성 소스를 로드합니다.

## 기본 설정하기

### 플러그인을 설치하기 전에...

`cmp-tw2css`는 `nvim-cmp` 엔진을 통해 코드를 제공합니다. 플러그인 사용을 위해서는 `nvim-cmp`가 neovim에 설치된 상태여야 합니다. `nvim-cmp`를 설치하는 방법은 [nvim-cmp Github repo](https://github.com/hrsh7th/nvim-cmp)를 참고해주세요.

`cmp-tw2css`는 버전 1.0.0부터 css 파서(parser)를 이용하여 커서가 css 코드 블록 안에 있는지 확인합니다. 따라서 이 기능을 이용하기 위해서는 css 파서를 필요로 합니다. 더 자세한 내용은 [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)에서 찾을 수 있습니다.

### 설치 방법

선호하는 플러그인 매니저를 사용하여 간편하게 설치할 수 있습니다. 이 페이지의 예시는 가장 대중적으로 사용되는 [`packer.nvim`](https://github.com/wbthomason/packer.nvim)를 통해 설치하는 방법을 서술하고 있습니다.

```lua
use({
  "hrsh7th/nvim-cmp",
  requires = {
    "jcha0713/cmp-tw2css",
  },
})
```

`packer.nvim`을 통해 설치가 끝난 후에는 다음의 설정값을 `nvim-cmp`에 추가해주어야 합니다.

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

## 어떻게 사용하나요?

여기까지 설치를 무사히 완료했다면 `cmp-tw2css` 사용은 쉽습니다. CSS 블록을 포함하고 있는 파일을 열고 원하는 tailwindcss 클래스를 입력하면 CSS 코드로 변환이 가능합니다.

### 예시

![demo](https://user-images.githubusercontent.com/29053796/222915836-9b2e19d5-3ace-4419-b492-eb1b00b572ac.gif)

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

## 변수 설정

```lua
require('cmp-tw2css').setup({ ... })
```

### `fallback`

**type**: `boolean`
**default**: `true`

```lua
{
  fallback = true
}
```

treesitter 파서가 없을 때 자동 완성 소스를 로드할지 말지 정합니다. `true`로 설정하는 경우에는 css 파서 없이도 소스를 로드하지만 커서 위치에 관계없이 모든 상황에서 소스를 불러오게 됩니다. `false`로 설정하면 css 파서가 없는 상황에서는 완성 소스를 불러오지 않습니다.

## 사용 전에 알아야 할 주의 사항

`cmp-tw2css`는 tailwindcss 공식 문서를 스크래핑하여 만든 파일을 통해 완성 소스를 제공합니다. 따라서 공식 문서에 내용이 추가되거나 제외되는 부분을 바로 반영하기가 힘듭니다. 또한 미리 만들어진 파일을 통해 제공되는 소스이기 때문에 사용자가 원하는대로 값을 수정하는 게 불가능합니다. Tailwindcss 문서가 제공하는 내용과 다른 부분을 찾게 된다면 언제든지 issue를 생성해주세요.

추가적으로 같은 줄에 `:`이 두 번 이상 나올 경우 완성 소스를 로드하지 못하는 한계가 있으며 입력하는 css 코드가 두 줄 이상일 경우에 탭을 자동으로 삽입하지 않는 소소한 단점이 있습니다.

## 추가될 기능들

- [x] 커서가 css 코드 블록 안에 있을 때만 소스를 로드하기
- [x] treesitter 기능을 사용자가 제어할 수 있게 하기
- [x] 완성 소스를 고를 때 documentation 보여주기
- [ ] LSP를 이용하여 웹 스크래핑 없이 소스 제공하기

## 참고한 프로젝트

- [`cmp-emoji`](https://github.com/hrsh7th/cmp-emoji)
- [`cmp-npm`](https://github.com/David-Kunz/cmp-npm)
- [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
