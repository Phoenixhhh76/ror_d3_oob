# ex03：HTML 物件引擎（`Elem` / `Text`）說明書

本練習要用**物件導向**表示 HTML，並讓 `to_s` 把物件樹「渲染」成題目/測試指定格式的 HTML 字串。

---

## 你要完成什麼（對齊 `ex03/ex03_test.rb`）

- **`Text` 類別**
  - 用一個 `String` 建構：`Text.new("...")`
  - 覆寫 `to_s`：回傳純文字內容（字串）

- **`Elem` 類別**
  - 建構參數（依序）：
    - `tag`：標籤名稱（例如 `"body"`, `"img"`）
    - `content`：內容（預設 `[]`；可以是 `Text`、`Elem`、或陣列）
    - `tag_type`：標籤型別（`"double"` 或 `"simple"`；預設 `"double"`）
    - `opt`：屬性 Hash（預設 `{}`；用來表示 `src/style/data-*` 等標籤屬性）
  - 必須有 `add_content`：能把 `Text` / `Elem`（或陣列）加入內容
  - 必須有 `attr_reader`：`tag`, `content`, `opt`, `tag_type`
  - 覆寫 `to_s`：輸出產生的 HTML（格式需**完全**符合測試）

---

## 核心概念：HTML 是一棵樹（Tree）

`Elem` 的 `content` 可以包含另一個 `Elem`，因此可以堆出巢狀 HTML：

```ruby
html  = Elem.new('html')
head  = Elem.new('head')
body  = Elem.new('body')
title = Elem.new('title', Text.new('"Hello ground!"'))

head.add_content(title)
html.add_content(head, body)

puts html
```

---

## `opt` 是什麼？

`opt` 通常是 **options** 的縮寫；在這題代表「HTML attributes（標籤屬性）」的 Hash。

例如：

```ruby
img = Elem.new('img', '', 'simple', { src: 'http://i.imgur.com/pfp3T.jpg' })
```

渲染時會變成：
- `<img src='http://i.imgur.com/pfp3T.jpg' />`

> 測試用的是 `img.opt[:src]`，所以常見寫法是用 Symbol 當 key（`{ src: '...' }`）。

---

## `content` 的相容規則（測試重點）

為了符合測試，你的 `Elem#content` 需要符合：

- 若內部 `@content.length == 1`：回傳單一元素本身（不是陣列）
- 若 `@content.length > 1`：回傳陣列

因此：

- `h1 = Elem.new('h1', Text.new(...))` 時，`h1.content` 應是 `Text`
- `body.add_content(h1, img)` 後，`body.content` 應是 `Array`

---

## `add_content(*args)` 的行為

`add_content` 用來追加子節點到內容：

- `add_content(elem1, elem2, ...)`
- 若參數本身是陣列（例如 `add_content([elem1, elem2])`），應把陣列展開/合併進內容

---

## `to_s` 的輸出格式（最重要）

測試期待 `to_s` 回傳「一個字串」，但外觀有兩層規則：

- **最外層要包雙引號 `"`**
- 內部若有換行，字串內容必須是字面上的 `\n`
  - 常見做法：先產生「真換行」的 raw HTML，再 `gsub("\n", "\\n")` 轉成 `\n`

### `tag_type == "simple"`（自閉合 / orphan）

- 單行輸出：`<img ... />`

### `tag_type == "double"`（成對標籤）

- 即使內容為空也必須有換行：
  - `<body>\n</body>`
- 多個子節點時，每個子節點各一行，最後關閉標籤再一行：
  - `<body>\n<h1>...</h1>\n<img ... />\n</body>`

---

## 底線 `_` 開頭的方法是什麼意思？

像 `_to_s_raw` / `_content_array` 這種命名是 Ruby 的**慣例**：表示「內部 helper」，提醒使用者不要把它當公開 API。

它不會自動變成 `private`；若要真的限制外部呼叫，需要用 `private`。

---

## 如何執行測試

在專案根目錄執行：

```bash
ruby ex03/ex03_test.rb
```

全部通過代表 `Text` / `Elem` 的 API 與輸出格式符合題目要求。

