# ex03: Elem 說明

## 題目要求

創建一個面向對象的 HTML 生成系統，使用 `Elem` 類來表示 HTML 元素，通過 `to_s` 方法將對象轉換為 HTML 字串。

### 實現要求

1. **Elem 類**
   - 構造函數接受四個參數：
     - `tag`：標籤名稱（如 "div", "p", "img"）
     - `content`：內容（可以是數組、Text 對象、或其他 Elem 對象）
     - `tag_type`：標籤類型（'double' 或 'simple'，默認為 'double'）
     - `opt`：屬性 Hash（用於標籤內的屬性，如 src, style 等）
   - 必須實現 `add_content` 方法來添加內容
   - 必須實現 `to_s` 方法來生成 HTML 字串
   - 必須提供 `attr_reader` 訪問器：`tag`, `content`, `opt`, `tag_type`

2. **Text 類**
   - 構造函數接受一個 String 參數
   - 必須實現 `to_s` 方法返回文本內容

3. **特殊要求**
   - 當 `content` 只有一個元素時，`content` 屬性應該返回該元素本身（不是數組）
   - 當 `content` 有多個元素時，`content` 屬性應該返回數組
   - `to_s` 方法必須生成正確格式的 HTML，包括適當的換行

---

## HTML 基礎知識

### HTML 標籤類型

1. **雙標籤（Double Tag）**
   ```html
   <div>內容</div>
   <p>段落</p>
   ```
   - 有開始標籤和結束標籤
   - 可以包含內容

2. **自閉合標籤（Simple/Self-closing Tag）**
   ```html
   <img src="image.jpg" />
   <br />
   ```
   - 沒有結束標籤
   - 在標籤末尾使用 `/>` 閉合
   - 不能包含內容

### HTML 屬性

屬性提供標籤的額外信息：
```html
<img src="image.jpg" alt="描述" />
<a href="http://example.com">鏈接</a>
```

---

## Ruby 基礎知識

### 類和對象
```ruby
class MyClass
  def initialize(param)
    @instance_var = param
  end
end

obj = MyClass.new("value")
```

### attr_reader
```ruby
attr_reader :name
# 等價於：
def name
  @name
end
```

### 方法重載
在 Ruby 中，`to_s` 是每個對象都有的方法，我們可以重寫它來自定義對象的字串表示。

---

## 程式碼說明

### 第 1-3 行
```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true
# warn_indent: true
```
**文件頭部**：標準的 shebang 和警告標誌。

---

### 第 5-13 行：Text 類

```ruby
class Text
  def initialize(str)
    @content = str
  end

  def to_s
    @content.to_s
  end
end
```

**Text 類**：表示純文本內容

- `def initialize(str)`：構造函數，接收一個字串參數
- `@content = str`：將字串存儲為實例變量
- `def to_s`：重寫 `to_s` 方法，返回文本內容
- `@content.to_s`：確保返回字串類型

**使用範例**：
```ruby
text = Text.new("Hello World")
puts text.to_s  # 輸出：Hello World
```

---

### 第 15-80 行：Elem 類

#### 第 16 行
```ruby
attr_reader :tag, :content, :opt, :tag_type
```
**屬性讀取器**：提供對實例變量的讀取訪問。

#### 第 18-30 行
```ruby
  def initialize(tag, content = [], tag_type = 'double', opt = {})
    @tag = tag
    @tag_type = tag_type
    @opt = opt
    
    # 處理 content
    if content.is_a?(Array)
      @content = content
    elsif content.nil? || content == ''
      @content = []
    else
      # 單個元素：存儲為數組，但為了測試兼容性，如果只有一個元素，直接存儲該元素
      @content = [content]
    end
  end
```
**構造函數**：

- `def initialize(tag, content = [], tag_type = 'double', opt = {})`：
  - `tag`：標籤名稱（必需）
  - `content = []`：內容，默認為空數組
  - `tag_type = 'double'`：標籤類型，默認為 'double'（雙標籤）
  - `opt = {}`：屬性 Hash，默認為空 Hash

- **內容處理邏輯**：
  - 如果 `content` 是數組：直接使用
  - 如果 `content` 是 `nil` 或空字串：設為空數組
  - 否則：將單個元素包裝成數組

**使用範例**：
```ruby
# 空標籤
body = Elem.new('body')

# 帶 Text 內容
h1 = Elem.new('h1', Text.new('Hello'))

# 自閉合標籤
img = Elem.new('img', '', 'simple', {'src' => 'image.jpg'})
```

#### 第 32-40 行
```ruby
  # 為了兼容測試，當 content 只有一個元素時，返回該元素；否則返回數組
  def content
    if @content.length == 1
      @content[0]
    else
      @content
    end
  end
```
**content 方法（重寫 attr_reader）**：

- 當內容只有一個元素時，返回該元素本身（不是數組）
- 當內容有多個元素時，返回數組

**為什麼需要這個？**
- 測試要求：`h1.content` 應該是 `Text` 對象（當只有一個 Text 時）
- 但 `body.content` 應該是數組（當有多個元素時）

#### 第 42-50 行
```ruby
  def add_content(*args)
    args.each do |arg|
      if arg.is_a?(Array)
        @content.concat(arg)
      else
        @content << arg
      end
    end
  end
```
**add_content 方法**：添加內容到元素中

- `def add_content(*args)`：`*args` 表示可以接受多個參數
- `args.each do |arg|`：遍歷所有參數
- `if arg.is_a?(Array)`：如果參數是數組
  - `@content.concat(arg)`：將數組的所有元素添加到內容中
- `else`：如果參數不是數組
  - `@content << arg`：直接添加該元素

**使用範例**：
```ruby
body = Elem.new('body')
body.add_content(h1, img)  # 添加多個元素
body.add_content([h1, img])  # 也可以傳入數組
```

#### 第 52-54 行
```ruby
  # 內部方法：獲取實際的內容數組（用於 to_s）
  def _content_array
    @content
  end
```
**內部方法**：返回實際的內容數組（用於 `to_s` 方法內部使用）。

#### 第 56-103 行
```ruby
  def to_s
    result = String.new('')
    
    # 構建開始標籤
    result << "<#{@tag}"
    
    # 添加屬性
    unless @opt.empty?
      @opt.each do |key, value|
        result << " #{key}='#{value}'"
      end
    end
    
    # 如果是簡單標籤（自閉合），直接返回
    if @tag_type == 'simple'
      result << ' />'
      return result
    end
    
    # 雙標籤：添加開始標籤的閉合
    result << '>'
    
    # 如果有內容，添加內容
    content_array = _content_array
    unless content_array.empty?
      # 檢查內容是否只有一個 Text 對象
      if content_array.length == 1 && content_array[0].is_a?(Text)
        # 單個 Text 內容，直接添加，不換行
        result << content_array[0].to_s
      else
        # 多個內容或包含 Elem，需要換行
        result << "\n"
        content_array.each do |item|
          if item.is_a?(Elem)
            # 如果是 Elem，遞歸調用 to_s，並添加縮排
            item.to_s.split("\n").each do |line|
              result << line << "\n"
            end
          elsif item.is_a?(Text)
            # 如果是 Text，直接添加
            result << item.to_s << "\n"
          else
            # 其他類型，轉換為字串
            result << item.to_s << "\n"
          end
        end
      end
    else
      # 空內容，添加換行
      result << "\n"
    end
    
    # 添加結束標籤
    result << "</#{@tag}>"
    
    result
  end
```
**to_s 方法**：將 Elem 對象轉換為 HTML 字串

**詳細步驟**：

1. **初始化結果字串**：
   - `result = String.new('')`：創建可變字串（因為 `frozen_string_literal: true`）

2. **構建開始標籤**：
   - `result << "<#{@tag}"`：添加開始標籤，例如 `<body`

3. **添加屬性**：
   - `unless @opt.empty?`：如果屬性 Hash 不為空
   - `@opt.each do |key, value|`：遍歷每個屬性
   - `result << " #{key}='#{value}'"`：添加屬性，格式為 ` key='value'`
   - 注意：使用單引號包裹屬性值

4. **處理自閉合標籤**：
   - `if @tag_type == 'simple'`：如果是自閉合標籤
   - `result << ' />'`：添加自閉合標記
   - `return result`：直接返回

5. **處理雙標籤**：
   - `result << '>'`：添加開始標籤的閉合

6. **添加內容**：
   - **單個 Text 內容**：
     - 直接添加，不換行：`<h1>Text</h1>`
   - **多個內容或包含 Elem**：
     - 添加換行符
     - 遍歷每個內容項：
       - 如果是 `Elem`：遞歸調用 `to_s`，每行添加換行
       - 如果是 `Text`：直接添加，然後換行
       - 其他類型：轉換為字串，然後換行
   - **空內容**：
     - 只添加換行符

7. **添加結束標籤**：
   - `result << "</#{@tag}>"`：添加結束標籤

**輸出格式範例**：

```ruby
# 空標籤
body = Elem.new('body')
body.to_s  # => "<body>\n</body>"

# 單個 Text
h1 = Elem.new('h1', Text.new('Hello'))
h1.to_s  # => "<h1>Hello</h1>"

# 自閉合標籤
img = Elem.new('img', '', 'simple', {'src' => 'image.jpg'})
img.to_s  # => "<img src='image.jpg' />"

# 嵌套元素
body = Elem.new('body')
body.add_content(h1, img)
body.to_s  # => "<body>\n<h1>Hello</h1>\n<img src='image.jpg' />\n</body>"
```

---

## 使用範例

### 範例 1：基本使用
```ruby
require_relative 'ex03.rb'

# 創建簡單元素
body = Elem.new('body')
puts body.to_s
# 輸出：
# <body>
# </body>

# 創建帶文本的元素
h1 = Elem.new('h1', Text.new('Hello World'))
puts h1.to_s
# 輸出：
# <h1>Hello World</h1>
```

### 範例 2：自閉合標籤
```ruby
# 創建圖片標籤
img = Elem.new('img', '', 'simple', {
  'src' => 'http://example.com/image.jpg',
  'alt' => 'Example Image'
})
puts img.to_s
# 輸出：
# <img src='http://example.com/image.jpg' alt='Example Image' />
```

### 範例 3：嵌套元素
```ruby
# 創建 HTML 結構
html = Elem.new('html')
head = Elem.new('head')
title = Elem.new('title', Text.new('My Page'))
body = Elem.new('body')
h1 = Elem.new('h1', Text.new('Welcome'))

# 構建結構
head.add_content(title)
body.add_content(h1)
html.add_content(head, body)

puts html.to_s
# 輸出：
# <html>
# <head>
# <title>My Page</title>
# </head>
# <body>
# <h1>Welcome</h1>
# </body>
# </html>
```

### 範例 4：複雜結構
```ruby
html = Elem.new('html')
head = Elem.new('head')
title = Elem.new('title', Text.new('"Hello ground!"'))
body = Elem.new('body')
h1 = Elem.new('h1', Text.new('"Oh no, not again!"'))
img = Elem.new('img', '', 'simple', {'src' => 'http://i.imgur.com/pfp3T.jpg'})

head.add_content(title)
body.add_content(h1, img)
html.add_content(head, body)

puts html.to_s
```

---

## 需注意的內容

### 1. 字串凍結問題
- 由於 `frozen_string_literal: true`，字串字面量被凍結
- 必須使用 `String.new('')` 創建可變字串
- 不能直接修改字串字面量

### 2. content 屬性的特殊行為
- **單個元素**：返回元素本身（不是數組）
- **多個元素**：返回數組
- 這是為了兼容測試要求

### 3. 輸出格式
- **空標籤**：`<tag>\n</tag>`（有換行）
- **單個 Text**：`<tag>Text</tag>`（無換行）
- **多個內容**：每個內容後都有換行
- **自閉合標籤**：`<tag attr='value' />`（無換行，無內容）

### 4. 屬性格式
- 使用單引號：`src='value'`
- 屬性之間用空格分隔
- 格式：` key='value'`

### 5. 遞歸處理
- `to_s` 方法會遞歸調用子元素的 `to_s`
- 確保嵌套結構正確生成

### 6. add_content 方法
- 可以接受多個參數
- 可以接受數組參數
- 會自動展開數組內容

### 7. 標籤類型
- `'double'`：雙標籤，有開始和結束標籤
- `'simple'`：自閉合標籤，使用 `/>` 閉合

### 8. 內容類型
- `Text` 對象：純文本
- `Elem` 對象：嵌套的 HTML 元素
- 數組：多個內容的集合

### 9. 符合規則要求
- ✅ 包含 shebang：`#!/usr/bin/env ruby`
- ✅ 包含警告標誌：`# frozen_string_literal: true`
- ✅ 代碼在類中（非全局作用域）
- ✅ 包含測試代碼（在 `if $PROGRAM_NAME == __FILE__` 區塊中）
- ✅ 未使用 `for`、`while`、`until` 循環（使用 `each`）
- ✅ 未使用未授權的 require
- ✅ 實現了所有必需的方法

---

## 執行方式

### 方式 1：直接執行
```bash
ruby ex03.rb
```

### 方式 2：運行測試
```bash
ruby ex03_test.rb
```

### 方式 3：在 irb 中使用
```ruby
require_relative 'ex03.rb'

html = Elem.new('html')
body = Elem.new('body')
body.add_content(Elem.new('p', Text.new('Hello')))
html.add_content(body)
puts html.to_s
```

---

## 測試說明

測試文件 `ex03_test.rb` 包含以下測試：

1. **test_initialize_params**：測試基本構造函數
2. **test_initialize_params_2**：測試帶屬性的構造函數
3. **test_to_s**：測試 `to_s` 方法的基本輸出
4. **test_text**：測試 Text 內容
5. **test_add_content**：測試 `add_content` 方法和複雜結構

---

## 常見問題

### Q: 為什麼 `content` 方法要特殊處理？
A: 測試要求當只有一個內容時，`content` 應該返回該元素本身，而不是包含它的數組。這是為了方便訪問單個內容。

### Q: 為什麼單個 Text 內容不換行？
A: 這是測試要求的格式。單個 Text 內容應該直接放在標籤內，不換行，例如 `<h1>Text</h1>` 而不是 `<h1>\nText\n</h1>`。

### Q: 如何處理嵌套結構？
A: `to_s` 方法會遞歸調用子元素的 `to_s` 方法，確保嵌套結構正確生成。

### Q: 為什麼使用 `String.new('')`？
A: 因為 `frozen_string_literal: true` 會凍結所有字串字面量，必須創建新的字串對象才能修改。

---

## 總結

Exercise 03 實現了一個面向對象的 HTML 生成系統，通過 `Elem` 和 `Text` 類來構建 HTML 結構。這個設計允許：

1. **靈活的內容管理**：可以添加 Text、Elem 或數組
2. **嵌套結構**：Elem 可以包含其他 Elem，形成樹狀結構
3. **自動格式化**：`to_s` 方法自動生成正確格式的 HTML
4. **屬性支持**：可以為標籤添加任意屬性

這種設計模式在實際開發中非常有用，可以構建複雜的 HTML 結構，同時保持代碼的可讀性和可維護性。
