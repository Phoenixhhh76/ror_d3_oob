# `ex03/ex03_test.rb` 測試檔解說

這份文件專門解釋 `ex03/ex03_test.rb` 在測什麼、為什麼這樣測，以及你需要在 `ex03/ex03.rb` 內提供哪些介面（API）與輸出格式，才能全部通過。

---

## 測試怎麼跑

在專案根目錄執行：

```bash
ruby ex03/ex03_test.rb
```

測試使用 Ruby 內建的 `test/unit` 框架；每個 `test_...` 方法都是一個獨立測項。

---

## 檔案開頭：依賴（require）

測試檔前幾行通常是「載入被測試程式碼」與「載入測試框架」：

- **`require_relative 'ex03.rb'`**
  - 載入 `ex03/ex03.rb`，裡面必須定義出測試要用到的類別（至少 `Elem` 與 `Text`）。
- **`require 'test/unit'`**
  - 載入 `Test::Unit`，提供 `Test::Unit::TestCase`、`assert_equal`、`assert_kind_of` 等方法。
- **`begin ... require 'colorize' ... rescue LoadError ... end`**
  - `colorize` 是可選依賴；沒有安裝也不會讓測試失敗（因為 catch 了 `LoadError`）。
  - 這也表示：**測試本身不依賴 `colorize` 的功能**，頂多是讓輸出更好看。

---

## 測試類別：`MainTest < Test::Unit::TestCase`

整個測試集合被放在：

- **`class MainTest < Test::Unit::TestCase`**
  - 這是 `test/unit` 的標準寫法。
  - 任何名稱以 `test_` 開頭的方法，都會被自動當成測試執行。

---

## `test_self`：測試框架是否正常運作

```ruby
assert_equal(1.to_s, "1" ," Always check your tools ")
```

- **目的**：這不是在測 `ex03.rb`，而是確認測試環境能跑、assert 能用。
- **預期**：`1.to_s` 就是 `"1"`，所以一定要過。
- **若失敗**：通常代表 Ruby 或 `test/unit` 環境異常（不太會發生）。

---

## `test_initialize_params`：`Elem.new(tag)` 的預設值與讀取器

重點片段（概念）：

- `body = Elem.new('body')`
- 然後檢查：
  - `body` 是 `Elem`
  - `body.content` 是 `Array`
  - `body.opt` 是 `Hash`
  - `body.tag == "body"`
  - `body.tag_type == "double"`

這個測項在要求你：

- **`Elem` 需要 `attr_reader`（或等效 getter）**
  - `tag`, `content`, `opt`, `tag_type`
- **`Elem#initialize` 預設參數（非常關鍵）**
  - `content` 預設是空內容（測試期望是 `Array`）
  - `tag_type` 預設是 `"double"`
  - `opt` 預設是 `{}`（而且要是 `Hash`）

同一個測項也用 `head = Elem.new('head')` 重複驗證：

- `head.tag == "head"`
- `head.tag_type == "double"`

> 注意：測試檔內有幾行在檢查 `head` 時仍然對 `body` 做 `assert_kind_of`（看起來像小筆誤），但不影響你需要提供的行為：兩者都要能用同樣的初始化規則建立出來。

---

## `test_initialize_params_2`：`tag_type == "simple"` 與屬性 Hash（`opt`）

```ruby
img = Elem.new('img', '', 'simple', { 'src': 'http://i.imgur.com/pfp3T.jpg' })
```

接著檢查：

- `img` 是 `Elem`
- `img.opt` 是 `Hash`
- `img.tag == "img"`
- `img.tag_type == "simple"`
- `img.opt[:src] == "http://i.imgur.com/pfp3T.jpg"`

這個測項在要求你：

- **初始化時可以傳 `tag_type = 'simple'`**
  - 代表自閉合標籤（如 `<img ... />`）。
- **`opt` 要能用 Symbol key 讀取**
  - 測試用 `img.opt[:src]`，所以你傳入的 Hash（或你內部轉換後的 Hash）必須能以 `:src` 取值。

---

## `test_to_s`：空 double tag 與 simple tag 的輸出

```ruby
body = Elem.new('body')
img  = Elem.new('img', '', 'simple', { 'src': 'http://i.imgur.com/pfp3T.jpg' })
assert("<body>\n</body>", body.to_s)
assert("<img src='http://i.imgur.com/pfp3T.jpg' />", img.to_s)
```

這裡是整題最容易卡住的地方：**輸出格式必須完全對上測試的字串**。

- **`<body>\n</body>`**
  - 即使 `body` 沒有內容，仍要有「開標籤後立刻換行，再關標籤」。
- **`<img src='... ' />`**
  - simple tag 是單行，結尾是 ` />`。
  - 屬性（`src`）使用單引號 `'`。

> 小提醒：這個測試用的是 `assert(expected, actual)` 的寫法（在 `test/unit` 裡屬於「assert 一個 truthy 值」），而不是 `assert_equal`。也就是說它並不會強制比對 `expected == actual`。
>
> 但在正確的解題方向上，你仍應讓 `to_s` 產生「題目規定的 HTML 字串」，否則後面的更複雜測項多半會過不了或輸出會怪。

---

## `test_text`：`Elem` 內含單一 `Text` 的行為

```ruby
h1 = Elem.new('h1', Text.new('"Oh no, not again!"'))
assert_kind_of(Text, h1.content)
assert_kind_of(Elem, h1)
assert_equal('"<h1>"Oh no, not again!"</h1>"', h1.to_s)
```

這個測項在要求你：

- **`Text` 類別**
  - `Text.new(string)` 之後 `to_s` 回傳那個字串本身。
- **`Elem#content` 的「單一元素回傳值」**
  - 當 `Elem` 只有一個 content（而且是 `Text`）時，測試期望 `h1.content` 是 `Text` 本體，而不是 `[Text]` 陣列。
- **`Elem#to_s` 的外層雙引號**
  - 這裡的 expected 是 `"<h1>...</h1>"`，最外層含雙引號字元 `"`。
  - 也就是說 `to_s` 不是純 HTML，而是「被雙引號包住的字串表示」。

---

## `test_add_content`：`add_content` 與多層巢狀渲染

建立元素並組樹（概念）：

- `head.add_content(title)`
- `body.add_content(h1, img)`
- `html.add_content(head, body)`

測試重點包含：

- **`add_content(*args)` 可以一次加多個**
  - `body.add_content(h1, img)` 會讓 `body` 有兩個子節點。
- **多個子節點時 `content` 應是 `Array`**
  - `assert_kind_of(Array, body.content)`
  - `assert_equal(2, body.content.count)`
- **巢狀元素的 `to_s` 格式**
  - `body.to_s` 與 `html.to_s` 都要求特定換行與排列順序。
  - 尤其是 `html` 內含 `head`（內含 `title`）與 `body`（內含 `h1` 與 `img`）時，換行與縮排（這份測試不要求縮排空白，但要求換行）要一致。

同時，測試也暗示了這個輸出規則：

- **當一個 `Elem` 的內容不是「單一 `Text`」時，通常會以多行形式呈現**
  - 開標籤後換行
  - 每個子節點各佔一行（子節點本身若是 `Elem`，也要輸出它的 raw HTML，而不是帶著外層雙引號的版本）
  - 最後再關標籤

---

## 你需要在 `ex03/ex03.rb` 提供的最小介面清單（依測試整理）

- **`class Text`**
  - `initialize(str)`
  - `to_s -> String`
- **`class Elem`**
  - `attr_reader :tag, :content, :opt, :tag_type`（或等效 getter）
  - `initialize(tag, content = ..., tag_type = 'double', opt = {})`
  - `add_content(*args)`
  - `to_s -> String`（輸出格式需符合測試）

---

## 常見失敗點（照測試最常踩的雷整理）

- **`content` 型別不符**
  - 測試同時期望：
    - 多個內容時：`content` 是 `Array`
    - 單一內容（如 `Text`）時：`content` 直接回傳 `Text`（不是陣列）
- **`opt` key 型別不符**
  - 測試用 `img.opt[:src]`，所以 `opt` 需要能以 Symbol key 取值。
- **`to_s` 的格式差一個字元就不過**
  - `<body>\n</body>` 這種「空內容也要換行」最容易忘。
  - 屬性單引號、` />` 結尾、換行位置、最外層雙引號是否存在，都要一致。

