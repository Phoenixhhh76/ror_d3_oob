# ex00: HTML 說明

## 題目要求

創建一個 `Html` 類，用於生成和填充 HTML 文件。

### 實現要求

1. **構造函數（Builder）**
   - 必須接收一個文件名（不含擴展名）作為參數
   - 必須調用 `head` 方法
   - 必須將文件名賦值給實例變量 `@page_name`

2. **`attr_reader`**
   - 必須為 `@page_name` 提供 `attr_reader`

3. **`head` 方法**
   - 應該設置 `<!DOCTYPE html>` 聲明
   - 應該設置一個有效的 `html` 標籤
   - 應該包含完整的 `<head>` 區塊，其中包含 `<title>` 標籤（標題內容為 `page_name`）
   - 應該在 `head` 標籤後跟隨一個開放的 `body` 標籤
   - 這些標籤應該在文件開頭

4. **`dump` 方法**
   - 必須接收一個字符串作為參數
   - 必須將字符串用 `<p>` 標籤包圍後追加到文件
   - 內容應該放在 `<body>` 標籤之後

5. **`finish` 方法**
   - 必須用閉合的 `</body>` 標籤結束文件
   - 應該同時關閉 `</html>` 標籤

### 重要提示

- **每次插入必須是行**：所有內容都應該逐行添加，每行都有換行符

---

## 程式碼說明

### 第 1 行
```ruby
#!/usr/bin/env ruby
```
**Shebang 行**：這是一個特殊的註釋，告訴系統使用哪個直譯器來執行這個腳本。`#!/usr/bin/env ruby` 會自動找到系統中的 Ruby 直譯器並使用它來執行腳本。這使得腳本可以直接執行（例如：`./ex00.rb`），而不需要明確輸入 `ruby ex00.rb`。

---

### 第 2 行
```ruby
# frozen_string_literal: true
```
**凍結字串字面量**：這是 Ruby 的魔法註釋，告訴 Ruby 所有字串字面量都是不可變的（frozen）。這有助於提高性能和安全性，防止意外修改字串。

---

### 第 3 行
```ruby
# warn_indent: true
```
**警告標誌**：啟用縮排警告，幫助檢測程式碼格式問題。

---

### 第 4 行
```ruby

```
**空行**：用於提高程式碼的可讀性，將註釋與類定義分開。

---

### 第 5 行
```ruby
class Html
```
**類定義**：定義一個名為 `Html` 的類，這個類用於生成 HTML 文件。

---

### 第 6 行
```ruby
  attr_reader :page_name
```
**屬性讀取器**：為 `@page_name` 實例變量提供讀取訪問。這允許外部代碼通過 `html.page_name` 來讀取文件名，但不能修改它。

**等價於**：
```ruby
def page_name
  @page_name
end
```

---

### 第 7 行
```ruby

```
**空行**：用於分隔程式碼區塊。

---

### 第 8-12 行
```ruby
  def initialize(page_name)
    @page_name = page_name
    @file = File.open("#{page_name}.html", 'w')
    head
  end
```
**構造函數**：定義 `initialize` 方法，這是 Ruby 中對象的構造函數：

- `def initialize(page_name)`：定義構造函數，接收一個參數 `page_name`（文件名，不含擴展名）
- `@page_name = page_name`：將參數值賦值給實例變量 `@page_name`，這樣可以在類的其他方法中訪問
- `@file = File.open("#{page_name}.html", 'w')`：打開一個 HTML 文件進行寫入：
  - `"#{page_name}.html"`：使用字串插值將文件名和 `.html` 擴展名組合
  - `'w'`：以寫入模式打開文件（如果文件存在會被覆蓋）
  - `@file`：將文件物件存儲在實例變量中，供其他方法使用
- `head`：調用 `head` 方法，在文件開頭寫入 HTML 和 body 標籤

**範例**：如果 `page_name` 是 `"test"`，則會創建 `test.html` 文件。

---

### 第 13 行
```ruby

```
**空行**：用於分隔方法定義。

---

### 第 14-20 行
```ruby
  def head
    @file.puts '<!DOCTYPE html>'
    @file.puts '<html>'
    @file.puts '<head>'
    @file.puts "<title>#{@page_name}</title>"
    @file.puts '</head>'
    @file.puts '<body>'
  end
```
**head 方法**：在 HTML 文件開頭寫入完整的 HTML 結構：

- `def head`：定義 `head` 方法
- `@file.puts '<!DOCTYPE html>'`：向文件寫入 HTML5 文檔類型聲明，這是現代 HTML 文件的標準開頭
- `@file.puts '<html>'`：向文件寫入 `<html>` 根標籤
- `@file.puts '<head>'`：向文件寫入 `<head>` 標籤開始
- `@file.puts "<title>#{@page_name}</title>"`：向文件寫入 `<title>` 標籤，使用字串插值將 `@page_name` 插入作為標題內容
- `@file.puts '</head>'`：向文件寫入 `</head>` 閉合標籤
- `@file.puts '<body>'`：向文件寫入 `<body>` 標籤開始
- 所有 `puts` 方法都會自動在末尾添加換行符

**輸出結果**：
```
<!DOCTYPE html>
<html>
<head>
<title>test</title>
</head>
<body>
```

---

### 第 18 行
```ruby

```
**空行**：用於分隔方法定義。

---

### 第 19-21 行
```ruby
  def dump(str)
    @file.puts "<p>#{str}</p>"
  end
```
**dump 方法**：將字符串內容用段落標籤包圍後追加到文件：

- `def dump(str)`：定義 `dump` 方法，接收一個字符串參數 `str`
- `@file.puts "<p>#{str}</p>"`：向文件寫入段落標籤包圍的內容：
  - `"<p>#{str}</p>"`：使用字串插值將 `str` 插入到 `<p>` 和 `</p>` 標籤之間
  - `puts` 方法會自動添加換行符，確保每次插入都是新的一行

**範例**：如果調用 `html.dump('Hello World')`，文件會添加：
```
<p>Hello World</p>
```

---

### 第 22 行
```ruby

```
**空行**：用於分隔方法定義。

---

### 第 23-27 行
```ruby
  def finish
    @file.puts '</body>'
    @file.puts '</html>'
    @file.close
  end
```
**finish 方法**：結束 HTML 文件並關閉文件：

- `def finish`：定義 `finish` 方法
- `@file.puts '</body>'`：寫入閉合的 `</body>` 標籤
- `@file.puts '</html>'`：寫入閉合的 `</html>` 標籤
- `@file.close`：關閉文件，確保所有內容都被寫入磁盤並釋放文件資源

**重要**：必須調用 `finish` 方法來正確關閉文件，否則文件可能不會被正確保存。

---

### 第 28 行
```ruby
end
```
**結束類定義**：結束 `Html` 類的定義。

---

### 第 29 行
```ruby

```
**空行**：用於分隔類定義和測試代碼。

---

### 第 30-40 行
```ruby
if $PROGRAM_NAME == __FILE__
  # 測試代碼
  html = Html.new('test')
  html.dump('Hello World')
  html.dump('This is a test')
  html.finish
  
  puts "HTML file '#{html.page_name}.html' has been created successfully!"
  puts "Content of #{html.page_name}.html:"
  puts File.read("#{html.page_name}.html")
end
```
**測試代碼區塊**：只有在直接執行此文件時才會運行的測試代碼：

- `if $PROGRAM_NAME == __FILE__`：檢查當前文件是否被直接執行（而不是被其他文件 require）
  - `$PROGRAM_NAME`：Ruby 的全域變量，包含當前執行的腳本名稱
  - `__FILE__`：當前文件的完整路徑
  - 如果兩者相等，表示文件被直接執行
- `html = Html.new('test')`：創建一個新的 `Html` 實例，文件名為 `test`（會創建 `test.html`）
- `html.dump('Hello World')`：添加第一個段落
- `html.dump('This is a test')`：添加第二個段落
- `html.finish`：結束並關閉文件
- `puts "HTML file '#{html.page_name}.html' has been created successfully!"`：輸出成功訊息，使用 `page_name` 屬性讀取文件名
- `puts "Content of #{html.page_name}.html:"`：輸出提示訊息
- `puts File.read("#{html.page_name}.html")`：讀取並輸出生成的 HTML 文件內容

**執行結果**：
```
HTML file 'test.html' has been created successfully!
Content of test.html:
<!DOCTYPE html>
<html>
<head>
<title>test</title>
</head>
<body>
<p>Hello World</p>
<p>This is a test</p>
</body>
</html>
```

---

## 額外要求（測試範例）

根據題目要求，在 Ruby 控制台（irb 或 pry）中應該能夠正常使用：

### 在 irb 中的使用範例
```ruby
require_relative "ex00.rb"
# => true

a = Html.new("test")
# => #<Html:0x00000001071580 @page_name="test">

10.times{|x| a.dump("titi_number#{x}")}
# => 10  (Integer#times 返回接收者本身，也就是 10)

a.finish
# => nil  (File#close 返回 nil)
```

**關於返回值**：
- `Integer#times` 方法在 Ruby 中返回接收者本身（調用它的數字），所以 `10.times{...}` 返回 `10`
- `File#puts` 和 `File#close` 都返回 `nil`，所以 `a.finish` 返回 `nil`
- 這些返回值是 Ruby 標準行為，不是錯誤

### 生成的 HTML 文件內容
使用 `cat -e test.html` 查看文件內容（`-e` 選項顯示行尾符號）：
```html
<!DOCTYPE html>$
<html>$
<head>$
<title>test</title>$
</head>$
<body>$
<p>titi_number0</p>$
<p>titi_number1</p>$
<p>titi_number2</p>$
<p>titi_number3</p>$
<p>titi_number4</p>$
<p>titi_number5</p>$
<p>titi_number6</p>$
<p>titi_number7</p>$
<p>titi_number8</p>$
<p>titi_number9</p>$
</body>$
</html>$
```

**重要提示**：
- 使用循環（如示例中的 `times`）來填充文件**必須能夠工作**
- 返回值 (`10` 和 `nil`) 是 Ruby 的標準行為，這是正常的
- 關鍵是確保功能正確（能正確生成 HTML 文件），而不是返回值的精確匹配

---

## 使用範例

### 基本使用
```ruby
require_relative 'ex00.rb'

# 創建 HTML 文件
html = Html.new('my_page')

# 添加內容
html.dump('這是第一段')
html.dump('這是第二段')
html.dump('這是第三段')

# 完成並關閉文件
html.finish
```

### 生成的 HTML 文件內容
```html
<!DOCTYPE html>
<html>
<head>
<title>my_page</title>
</head>
<body>
<p>這是第一段</p>
<p>這是第二段</p>
<p>這是第三段</p>
</body>
</html>
```

---

## 需注意的內容

### 1. 文件操作
- **必須調用 `finish` 方法**：如果不調用 `finish`，文件可能不會被正確保存，因為緩衝區可能還沒有寫入磁盤
- **文件會被覆蓋**：如果同名的 HTML 文件已存在，`File.open` 的 `'w'` 模式會覆蓋原有內容

### 2. 字串插值
- 使用 `"#{variable}"` 進行字串插值時，必須使用雙引號 `""`，單引號 `''` 不會進行插值
- 例如：`"#{page_name}.html"` 會正確插值，但 `'#{page_name}.html'` 會保持字面量

### 3. 實例變量
- `@page_name` 和 `@file` 都是實例變量（以 `@` 開頭），可以在類的所有方法中訪問
- `@file` 在 `initialize` 中創建，在 `finish` 中關閉，確保文件資源被正確管理

### 4. 方法調用順序
- `head` 方法在構造函數中自動調用，不需要手動調用
- `dump` 方法可以多次調用，每次都會添加新的段落
- `finish` 方法必須在最後調用，且只能調用一次（多次調用會導致錯誤，因為文件已關閉）

### 5. 符合規則要求
- ✅ 包含 shebang：`#!/usr/bin/env ruby`
- ✅ 包含警告標誌：`# frozen_string_literal: true`
- ✅ 代碼在類中（非全局作用域）
- ✅ 包含測試代碼（在 `if $PROGRAM_NAME == __FILE__` 區塊中）
- ✅ 未使用 `for`、`while`、`until` 循環
- ✅ 未使用未授權的 require
- ✅ 每次插入都是行（使用 `puts`，自動添加換行符）

### 6. 錯誤處理
- 當前實現沒有錯誤處理，如果文件無法創建或寫入，會拋出異常
- 在實際應用中，可能需要添加錯誤處理機制

### 7. HTML 結構
- 生成的 HTML 文件包含完整的 HTML5 結構：
  - `<!DOCTYPE html>` 聲明
  - `<html>` 根標籤
  - `<head>` 區塊，包含 `<title>` 標籤（標題為 `page_name`）
  - `<body>` 區塊，包含所有通過 `dump` 方法添加的內容
- 這是一個完整的、有效的 HTML5 文檔

### 8. 循環使用
- **重要**：必須支持使用循環（如 `times`、`each` 等）來填充文件
- 範例：`10.times{|x| html.dump("titi_number#{x}")}` 必須能夠正常工作
- 這確保了 `dump` 方法可以多次調用，每次都會正確添加內容

---

## 執行方式

### 方式 1：直接執行
```bash
ruby ex00.rb
```

### 方式 2：在 irb 中使用
```ruby
require_relative 'ex00.rb'
html = Html.new('demo')
html.dump('Hello')
html.dump('World')
html.finish
```

### 方式 3：作為可執行文件（需要執行權限）
```bash
chmod +x ex00.rb
./ex00.rb
```

---

## 測試建議

1. **基本功能測試**：創建文件、添加內容、關閉文件
2. **多次 dump 測試**：測試多次調用 `dump` 方法
3. **文件名測試**：測試不同的文件名
4. **文件讀取測試**：驗證生成的 HTML 文件內容是否正確
5. **屬性訪問測試**：驗證 `page_name` 屬性是否可以正確讀取
