# ex04: Dejavu 說明

## 題目要求

恭喜！你現在已經能夠生成任何 HTML 元素及其內容。但是，每次實例化時都要指定每個屬性有點繁瑣。這是一個使用繼承來創建更易用的小類的機會。

### 實現要求

通過繼承 `Elem` 類，創建以下類來簡化 HTML 元素的創建：

1. **結構類**：Html, Head, Body
2. **文本類**：Title, H1, H2, P
3. **媒體類**：Img, Meta
4. **表格類**：Table, Th, Tr, Td
5. **列表類**：Ul, Ol, Li
6. **容器類**：Div, Span
7. **分隔類**：Hr, Br

### 重要要求

- 所有類必須繼承自 `Elem`
- 標籤名稱必須使用**大寫字母**（如 `Html`, `Head`, `Body` 等）
- 這些類應該簡化使用，不需要每次都指定標籤名和類型
- 字串內容應該自動轉換為 `Text` 對象

### 預期輸出格式

執行以下代碼：
```ruby
puts Html.new([Head.new([Title.new("Hello ground!")]),
               Body.new([H1.new("Oh no, not again!"),
                        Img.new([], {'src' => 'http://i.imgur.com/pfp3T.jpg'})])])
```

應該輸出：
```html
<Html>
<Head>
<Title>Hello ground!</Title>
</Head>
<Body>
<H1>Oh no, not again!</H1>
<Img src='http://i.imgur.com/pfp3T.jpg' />
</Body>
</Html>
```

---

## Ruby 繼承基礎知識

### 類繼承
```ruby
class Child < Parent
  def initialize(param)
    super(param)  # 調用父類的構造函數
  end
end
```

- `< Parent` 表示繼承自 `Parent` 類
- `super` 調用父類的方法（通常是構造函數）

### 為什麼使用繼承？

1. **代碼重用**：不需要重複實現 `to_s`、`add_content` 等方法
2. **簡化使用**：不需要每次都指定標籤名和類型
3. **類型安全**：每個類對應特定的 HTML 元素
4. **易於維護**：修改 `Elem` 會自動影響所有子類

---

## 程式碼說明

### 第 1-6 行
```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true
# warn_indent: true

# 需要先載入 ex03 的 Elem 和 Text 類
require_relative '../ex03/ex03.rb'
```
**文件頭部和依賴**：
- 標準的 shebang 和警告標誌
- `require_relative '../ex03/ex03.rb'`：載入 ex03 中的 `Elem` 和 `Text` 類
- 使用相對路徑，因為 ex04 和 ex03 在同一個父目錄下

---

### 第 8-15 行：結構類

```ruby
class Html < Elem
  def initialize(content = [])
    super('Html', content)
  end
end

class Head < Elem
  def initialize(content = [])
    super('Head', content)
  end
end

class Body < Elem
  def initialize(content = [])
    super('Body', content)
  end
end
```

**結構類**：HTML 文檔的主要結構元素

- `class Html < Elem`：`Html` 類繼承自 `Elem`
- `def initialize(content = [])`：構造函數，只接受內容參數
- `super('Html', content)`：調用父類 `Elem` 的構造函數
  - 第一個參數：標籤名（大寫）
  - 第二個參數：內容（默認為空數組）
  - 第三個參數：標籤類型（默認為 'double'，由父類處理）
  - 第四個參數：屬性（默認為空 Hash，由父類處理）

**使用範例**：
```ruby
html = Html.new([head, body])
head = Head.new([title])
body = Body.new([h1, img])
```

---

### 第 17-22 行：Title 類

```ruby
class Title < Elem
  def initialize(content)
    # 如果 content 是字串，轉換為 Text
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('Title', text_content)
  end
end
```

**Title 類**：頁面標題元素

- `def initialize(content)`：接受內容參數（必需，不能為空）
- `content.is_a?(String) ? Text.new(content) : content`：
  - 如果 `content` 是字串，轉換為 `Text` 對象
  - 否則直接使用（可能是 `Text` 對象或其他類型）
- `super('Title', text_content)`：調用父類構造函數，標籤名為 'Title'

**使用範例**：
```ruby
title = Title.new("Hello ground!")  # 字串自動轉換為 Text
title = Title.new(Text.new("Hello"))  # 也可以直接傳入 Text
```

---

### 第 24-28 行：Meta 類

```ruby
class Meta < Elem
  def initialize(opt = {})
    super('Meta', [], 'simple', opt)
  end
end
```

**Meta 類**：元數據標籤（自閉合）

- `def initialize(opt = {})`：只接受屬性參數
- `super('Meta', [], 'simple', opt)`：
  - 標籤名：'Meta'
  - 內容：空數組（自閉合標籤沒有內容）
  - 標籤類型：'simple'（自閉合）
  - 屬性：傳入的 `opt` Hash

**使用範例**：
```ruby
meta = Meta.new({'charset' => 'UTF-8'})
# 生成：<Meta charset='UTF-8' />
```

---

### 第 30-34 行：Img 類

```ruby
class Img < Elem
  def initialize(content = [], opt = {})
    super('Img', content, 'simple', opt)
  end
end
```

**Img 類**：圖片標籤（自閉合）

- `def initialize(content = [], opt = {})`：接受內容和屬性
- `super('Img', content, 'simple', opt)`：
  - 標籤名：'Img'
  - 內容：雖然是自閉合標籤，但為了兼容性接受內容參數
  - 標籤類型：'simple'（自閉合）
  - 屬性：傳入的 `opt` Hash

**使用範例**：
```ruby
img = Img.new([], {'src' => 'http://example.com/image.jpg'})
# 生成：<Img src='http://example.com/image.jpg' />
```

---

### 第 36-40 行：Table 類

```ruby
class Table < Elem
  def initialize(content = [])
    super('Table', content)
  end
end
```

**Table 類**：表格元素

- 與 `Html`、`Head`、`Body` 類似，是容器元素
- 可以包含 `Tr`（表格行）元素

---

### 第 42-47 行：Th 類

```ruby
class Th < Elem
  def initialize(content)
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('Th', text_content)
  end
end
```

**Th 類**：表格標題單元格

- 與 `Title` 類似，接受字串並自動轉換為 `Text`
- 用於表格的標題行

---

### 第 49-53 行：Tr 類

```ruby
class Tr < Elem
  def initialize(content = [])
    super('Tr', content)
  end
end
```

**Tr 類**：表格行

- 容器元素，可以包含 `Th` 或 `Td` 元素

---

### 第 55-60 行：Td 類

```ruby
class Td < Elem
  def initialize(content)
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('Td', text_content)
  end
end
```

**Td 類**：表格數據單元格

- 與 `Th` 類似，接受字串並自動轉換為 `Text`

---

### 第 62-67 行：列表類

```ruby
class Ul < Elem
  def initialize(content = [])
    super('Ul', content)
  end
end

class Ol < Elem
  def initialize(content = [])
    super('Ol', content)
  end
end

class Li < Elem
  def initialize(content)
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('Li', text_content)
  end
end
```

**列表類**：
- `Ul`：無序列表（容器）
- `Ol`：有序列表（容器）
- `Li`：列表項（接受字串內容）

---

### 第 69-79 行：標題類

```ruby
class H1 < Elem
  def initialize(content)
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('H1', text_content)
  end
end

class H2 < Elem
  def initialize(content)
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('H2', text_content)
  end
end
```

**標題類**：HTML 標題元素

- `H1`：一級標題
- `H2`：二級標題
- 都接受字串並自動轉換為 `Text`

---

### 第 81-86 行：P 類

```ruby
class P < Elem
  def initialize(content)
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('P', text_content)
  end
end
```

**P 類**：段落元素

- 接受字串並自動轉換為 `Text`

---

### 第 88-98 行：容器類

```ruby
class Div < Elem
  def initialize(content = [])
    super('Div', content)
  end
end

class Span < Elem
  def initialize(content)
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('Span', text_content)
  end
end
```

**容器類**：
- `Div`：塊級容器（可以包含多個元素）
- `Span`：行內容器（通常包含文本）

---

### 第 100-110 行：分隔類

```ruby
class Hr < Elem
  def initialize(opt = {})
    super('Hr', [], 'simple', opt)
  end
end

class Br < Elem
  def initialize(opt = {})
    super('Br', [], 'simple', opt)
  end
end
```

**分隔類**：自閉合標籤

- `Hr`：水平分隔線
- `Br`：換行符
- 都只接受屬性參數

---

### 第 112-117 行：測試代碼

```ruby
if $PROGRAM_NAME == __FILE__
  # 測試代碼：執行題目要求的命令
  puts Html.new([Head.new([Title.new("Hello ground!")]),
                 Body.new([H1.new("Oh no, not again!"),
                          Img.new([], {'src' => 'http://i.imgur.com/pfp3T.jpg'})])])
end
```

**測試代碼**：執行題目要求的命令，驗證輸出格式。

---

## 類別分類總結

### 1. 容器類（接受數組內容）
- `Html`, `Head`, `Body`
- `Table`, `Tr`
- `Ul`, `Ol`
- `Div`

**特點**：
- `initialize(content = [])`：內容是可選的，默認為空數組
- 可以包含多個子元素

### 2. 文本類（接受字串內容）
- `Title`, `H1`, `H2`, `P`
- `Th`, `Td`, `Li`
- `Span`

**特點**：
- `initialize(content)`：內容是必需的
- 自動將字串轉換為 `Text` 對象
- 通常只包含文本內容

### 3. 自閉合類（只有屬性）
- `Meta`, `Img`
- `Hr`, `Br`

**特點**：
- `initialize(opt = {})` 或 `initialize(content = [], opt = {})`
- 標籤類型為 'simple'
- 不能包含內容（或內容被忽略）

---

## 使用範例

### 範例 1：基本 HTML 結構
```ruby
require_relative 'ex04.rb'

html = Html.new([
  Head.new([
    Title.new("My Page")
  ]),
  Body.new([
    H1.new("Welcome"),
    P.new("This is a paragraph.")
  ])
])

puts html
```

### 範例 2：帶圖片的頁面
```ruby
body = Body.new([
  H1.new("My Image"),
  Img.new([], {'src' => 'image.jpg', 'alt' => 'My Image'})
])
```

### 範例 3：表格
```ruby
table = Table.new([
  Tr.new([
    Th.new("Name"),
    Th.new("Age")
  ]),
  Tr.new([
    Td.new("Alice"),
    Td.new("25")
  ])
])
```

### 範例 4：列表
```ruby
ul = Ul.new([
  Li.new("Item 1"),
  Li.new("Item 2"),
  Li.new("Item 3")
])
```

---

## 需注意的內容

### 1. 標籤名稱必須大寫
- ✅ 正確：`'Html'`, `'Head'`, `'Body'`
- ❌ 錯誤：`'html'`, `'head'`, `'body'`

### 2. 字串自動轉換
- 文本類（如 `Title`, `H1`, `P` 等）會自動將字串轉換為 `Text` 對象
- 這簡化了使用，不需要手動創建 `Text` 對象

### 3. 繼承的好處
- 所有類自動繼承 `Elem` 的方法：
  - `to_s`：生成 HTML 字串
  - `add_content`：添加內容
  - `attr_reader`：訪問屬性

### 4. 自閉合標籤
- `Meta`, `Img`, `Hr`, `Br` 是自閉合標籤
- 標籤類型設為 'simple'
- 內容參數通常被忽略（但為了兼容性可以接受）

### 5. require_relative 的使用
- 必須載入 ex03 中的 `Elem` 和 `Text` 類
- 使用相對路徑：`require_relative '../ex03/ex03.rb'`
- 這符合題目要求，因為我們需要繼承 `Elem` 類

### 6. 構造函數設計模式
- **容器類**：`initialize(content = [])` - 內容可選
- **文本類**：`initialize(content)` - 內容必需，自動轉換字串
- **自閉合類**：`initialize(opt = {})` - 只有屬性

### 7. 符合規則要求
- ✅ 包含 shebang：`#!/usr/bin/env ruby`
- ✅ 包含警告標誌：`# frozen_string_literal: true`
- ✅ 代碼在類中（非全局作用域）
- ✅ 包含測試代碼（在 `if $PROGRAM_NAME == __FILE__` 區塊中）
- ✅ 未使用 `for`、`while`、`until` 循環
- ✅ 使用 `require_relative` 載入必要的類（這是允許的，因為需要繼承）
- ✅ 所有類都繼承自 `Elem`

### 8. 代碼重用
- 通過繼承，我們不需要重複實現 `to_s`、`add_content` 等方法
- 只需要在構造函數中調用 `super` 並傳入正確的參數
- 這大大減少了代碼量

---

## 執行方式

### 方式 1：直接執行
```bash
ruby ex04.rb
```

### 方式 2：在 irb 中使用
```ruby
require_relative 'ex04.rb'

html = Html.new([Head.new([Title.new("Test")])])
puts html
```

---

## 測試建議

1. **基本結構測試**：測試 Html, Head, Body 的創建
2. **文本類測試**：測試 Title, H1, P 等接受字串
3. **自閉合標籤測試**：測試 Img, Meta, Hr, Br
4. **嵌套結構測試**：測試複雜的嵌套結構
5. **輸出格式測試**：驗證輸出是否符合預期格式

---

## 常見問題

### Q: 為什麼標籤名稱要大寫？
A: 這是題目要求的格式。從預期輸出可以看到標籤都是大寫的：`<Html>`, `<Head>`, `<Body>` 等。

### Q: 為什麼需要 require_relative？
A: 因為這些類需要繼承自 `Elem` 類，而 `Elem` 類定義在 ex03 中。這是必要的依賴。

### Q: 為什麼有些類接受字串，有些接受數組？
A: 這取決於 HTML 元素的特性：
- 容器元素（如 `Div`, `Body`）可以包含多個子元素，所以接受數組
- 文本元素（如 `P`, `H1`）通常只包含文本，所以接受字串

### Q: 自閉合標籤為什麼還要接受內容參數？
A: 為了兼容性和靈活性。雖然自閉合標籤在 HTML 中不應該有內容，但接受參數可以讓代碼更靈活，不會因為傳入內容而報錯。

---

## 總結

Exercise 04 通過繼承實現了代碼重用和簡化使用。通過創建這些特定的 HTML 元素類：

1. **簡化了使用**：不需要每次都指定標籤名和類型
2. **提高了可讀性**：`Html.new` 比 `Elem.new('html')` 更清晰
3. **減少了錯誤**：每個類對應特定的 HTML 元素，減少拼寫錯誤
4. **保持了靈活性**：仍然可以通過屬性 Hash 添加任意屬性

這種設計模式在實際開發中非常常見，是面向對象編程中繼承的典型應用。
