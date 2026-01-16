# ex01: Raise HTML 說明

## 題目要求

重用 `ex00` 的代碼，並添加錯誤處理機制，通過拋出異常來防止生成「無效或荒謬的 HTML 頁面」。

### 實現要求

必須實現以下四種錯誤情況的異常處理：

1. **重複創建同名文件**
   - **情況**：嘗試創建一個已經存在的同名文件
   - **異常信息**：`"<filename> already exists!"`
   - **注意**：使用 "exists"（第三人稱單數形式）

2. **在沒有 `<body>` 標籤時調用 `dump`**
   - **情況**：在文件中沒有開放的 `<body>` 標籤時調用 `dump` 方法
   - **異常信息**：`"There is no body tag in <filename>"`

3. **在 `</body>` 標籤後調用 `dump`**
   - **情況**：在 `<body>` 標籤已經關閉後調用 `dump` 方法
   - **異常信息**：`"The body has already been closed in <filename>"`

4. **重複調用 `finish`**
   - **情況**：在 `<body>` 標籤已經關閉後再次調用 `finish` 方法
   - **異常信息**：`"<filename> has already been closed"`

### 重要提示

- 所有異常信息中的 `<filename>` 必須替換為實際的文件名（包含 `.html` 擴展名）
- 異常信息必須**精確匹配**題目要求
- 必須使用 `raise` 來拋出異常

---

## 程式碼說明

### 第 1-3 行
```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true
# warn_indent: true
```
**文件頭部**：與 ex00 相同，包含 shebang 和警告標誌。

---

### 第 5-6 行
```ruby
class Html
  attr_reader :page_name
```
**類定義**：定義 `Html` 類，提供 `page_name` 的讀取訪問。

---

### 第 8-21 行
```ruby
  def initialize(page_name)
    @page_name = page_name
    filename = "#{page_name}.html"
    
    if File.exist?(filename)
      raise "#{filename} already exists!"
    end
    
    @file = File.open(filename, 'w')
    @body_opened = false
    @body_closed = false
    head
  end
```
**構造函數（帶錯誤處理）**：

- `def initialize(page_name)`：定義構造函數
- `@page_name = page_name`：保存頁面名稱
- `filename = "#{page_name}.html"`：構建完整的文件名
- `if File.exist?(filename)`：檢查文件是否已存在
  - `raise "#{filename} already exists!"`：如果文件已存在，拋出異常
  - **注意**：使用 "exists"（第三人稱單數形式）
- `@file = File.open(filename, 'w')`：打開文件進行寫入
- `@body_opened = false`：初始化 body 標籤狀態為未打開
- `@body_closed = false`：初始化 body 標籤狀態為未關閉
- `head`：調用 `head` 方法，設置 HTML 結構

**錯誤處理**：防止創建同名文件。

---

### 第 23-32 行
```ruby
  def head
    @file.puts '<!DOCTYPE html>'
    @file.puts '<html>'
    @file.puts '<head>'
    @file.puts "<title>#{@page_name}</title>"
    @file.puts '</head>'
    @file.puts '<body>'
    @body_opened = true
  end
```
**head 方法（更新狀態）**：

- 與 ex00 相同，寫入完整的 HTML 頭部結構
- `@body_opened = true`：標記 body 標籤已打開
- 這確保後續的 `dump` 調用知道 body 標籤已經存在

---

### 第 34-46 行
```ruby
  def dump(str)
    filename = "#{@page_name}.html"
    
    unless @body_opened
      raise "There is no body tag in #{filename}"
    end
    
    if @body_closed
      raise "The body has already been closed in #{filename}"
    end
    
    @file.puts "<p>#{str}</p>"
  end
```
**dump 方法（帶錯誤檢查）**：

- `def dump(str)`：定義 dump 方法
- `filename = "#{@page_name}.html"`：構建文件名用於錯誤信息
- `unless @body_opened`：檢查 body 標籤是否已打開
  - `raise "There is no body tag in #{filename}"`：如果 body 未打開，拋出異常
- `if @body_closed`：檢查 body 標籤是否已關閉
  - `raise "The body has already been closed in #{filename}"`：如果 body 已關閉，拋出異常
- `@file.puts "<p>#{str}</p>"`：只有在通過所有檢查後才寫入內容

**錯誤處理**：
- 防止在 body 標籤不存在時寫入內容
- 防止在 body 標籤已關閉後寫入內容

---

### 第 48-60 行
```ruby
  def finish
    filename = "#{@page_name}.html"
    
    if @body_closed
      raise "#{filename} has already been closed"
    end
    
    @file.puts '</body>'
    @file.puts '</html>'
    @file.close
    @body_closed = true
  end
```
**finish 方法（帶錯誤檢查）**：

- `def finish`：定義 finish 方法
- `filename = "#{@page_name}.html"`：構建文件名用於錯誤信息
- `if @body_closed`：檢查 body 是否已經關閉
  - `raise "#{filename} has already been closed"`：如果已經關閉，拋出異常
- `@file.puts '</body>'`：寫入閉合 body 標籤
- `@file.puts '</html>'`：寫入閉合 html 標籤
- `@file.close`：關閉文件
- `@body_closed = true`：標記 body 已關閉

**錯誤處理**：防止重複關閉文件。

---

### 第 62-95 行
```ruby
if $PROGRAM_NAME == __FILE__
  # 測試代碼
  begin
    html = Html.new('test')
    html.dump('Hello World')
    html.dump('This is a test')
    html.finish
    
    puts "HTML file '#{html.page_name}.html' has been created successfully!"
    puts "Content of #{html.page_name}.html:"
    puts File.read("#{html.page_name}.html")
    
    # 測試錯誤情況
    puts "\n--- Testing error cases ---"
    
    # 測試 1: 創建同名文件
    begin
      html2 = Html.new('test')
    rescue => e
      puts "Error 1 (expected): #{e.message}"
    end
    
    # 測試 2: 在已關閉的 body 後調用 dump
    begin
      html.dump('This should fail')
    rescue => e
      puts "Error 2 (expected): #{e.message}"
    end
    
    # 測試 3: 重複調用 finish
    begin
      html.finish
    rescue => e
      puts "Error 3 (expected): #{e.message}"
    end
    
  rescue => e
    puts "Unexpected error: #{e.message}"
    puts e.backtrace
  end
end
```
**測試代碼**：

- 基本功能測試：創建文件、添加內容、關閉文件
- 錯誤情況測試：
  1. 測試重複創建同名文件
  2. 測試在已關閉的 body 後調用 dump
  3. 測試重複調用 finish
- 使用 `begin...rescue` 來捕獲和顯示異常

---

## 錯誤處理機制

### 狀態追蹤變量

1. **`@body_opened`**
   - 類型：布林值
   - 用途：追蹤 `<body>` 標籤是否已打開
   - 初始值：`false`
   - 設置為 `true`：在 `head` 方法中，當寫入 `<body>` 標籤後

2. **`@body_closed`**
   - 類型：布林值
   - 用途：追蹤 `<body>` 標籤是否已關閉
   - 初始值：`false`
   - 設置為 `true`：在 `finish` 方法中，當寫入 `</body>` 標籤後

### 錯誤檢查流程

```
initialize
  ├─ 檢查文件是否存在 → 如果存在，拋出異常
  ├─ 打開文件
  ├─ 初始化狀態變量
  └─ 調用 head

head
  ├─ 寫入 HTML 結構
  └─ 設置 @body_opened = true

dump
  ├─ 檢查 @body_opened → 如果 false，拋出異常
  ├─ 檢查 @body_closed → 如果 true，拋出異常
  └─ 寫入內容

finish
  ├─ 檢查 @body_closed → 如果 true，拋出異常
  ├─ 寫入閉合標籤
  ├─ 關閉文件
  └─ 設置 @body_closed = true
```

---

## 使用範例

### 正常使用
```ruby
require_relative 'ex01.rb'

html = Html.new('my_page')
html.dump('第一段')
html.dump('第二段')
html.finish
```

### 錯誤情況 1：重複創建文件
```ruby
html1 = Html.new('test')  # 成功
html2 = Html.new('test')  # RuntimeError: test.html already exists!
```

### 錯誤情況 2：在已關閉的 body 後調用 dump
```ruby
html = Html.new('test')
html.finish
html.dump('這會失敗')  # RuntimeError: The body has already been closed in test.html
```

### 錯誤情況 3：重複調用 finish
```ruby
html = Html.new('test')
html.finish  # 成功
html.finish  # RuntimeError: test.html has already been closed
```

### 在 irb 中的使用
```ruby
> require_relative "ex01.rb"
=> true

> a = Html.new("test")
=> #<Html:0x0000000332b9c0 @page_name='test'>

> a = Html.new("test")
RuntimeError: test.html already exists!
from /ex01.rb:15:in "head"

> a.dump("Lorem_ipsum")
=> nil

> a.finish
=> nil

> a.finish
RuntimeError: test.html has already been closed
from /ex01.rb:39:in "finish"
```

---

## 需注意的內容

### 1. 異常信息格式
- **必須精確匹配**題目要求的錯誤信息
- 使用 "exists"（第三人稱單數形式）
- 文件名必須包含 `.html` 擴展名
- 錯誤信息格式：`"<filename> already exists!"`

### 2. 狀態管理
- 必須正確追蹤 `@body_opened` 和 `@body_closed` 狀態
- 狀態變量必須在適當的時機更新
- 狀態檢查必須在執行操作之前進行

### 3. 文件存在檢查
- 使用 `File.exist?` 檢查文件是否存在
- 檢查必須在打開文件之前進行
- 如果文件已存在，必須拋出異常而不是覆蓋

### 4. 異常類型
- 使用 `raise` 拋出 `RuntimeError`（默認異常類型）
- 不需要指定異常類型，`raise "message"` 即可

### 5. 錯誤處理順序
- 在 `dump` 中，先檢查 `@body_opened`，再檢查 `@body_closed`
- 在 `finish` 中，先檢查 `@body_closed`，再執行關閉操作

### 6. 文件操作
- 即使拋出異常，也要確保文件資源不會洩漏
- 在 `finish` 中關閉文件後，設置 `@body_closed = true`

### 7. 測試覆蓋
- 確保測試所有四種錯誤情況
- 使用 `begin...rescue` 來捕獲異常並驗證錯誤信息
- 測試正常流程確保基本功能不受影響

### 8. 與 ex00 的差異
- 添加了狀態追蹤變量（`@body_opened`、`@body_closed`）
- 添加了文件存在檢查
- 添加了方法調用前的狀態檢查
- 所有檢查都使用 `raise` 拋出異常

### 9. 邊緣情況
- 如果 `head` 方法沒有被調用（理論上不會發生，因為在 `initialize` 中調用），`@body_opened` 會是 `false`，`dump` 會正確拋出異常
- 如果文件在創建後被外部刪除，後續操作可能會失敗，但這不在本練習的錯誤處理範圍內

### 10. 符合規則要求
- ✅ 包含 shebang：`#!/usr/bin/env ruby`
- ✅ 包含警告標誌：`# frozen_string_literal: true`
- ✅ 代碼在類中（非全局作用域）
- ✅ 包含測試代碼（在 `if $PROGRAM_NAME == __FILE__` 區塊中）
- ✅ 未使用 `for`、`while`、`until` 循環
- ✅ 未使用未授權的 require
- ✅ 重用 ex00 的代碼結構

---

## 執行方式

### 方式 1：直接執行
```bash
ruby ex01.rb
```

### 方式 2：在 irb 中使用
```ruby
require_relative 'ex01.rb'
html = Html.new('demo')
html.dump('Hello')
html.dump('World')
html.finish
```

### 方式 3：測試錯誤情況
```ruby
require_relative 'ex01.rb'

# 測試重複創建
begin
  html1 = Html.new('test')
  html2 = Html.new('test')  # 會拋出異常
rescue => e
  puts e.message
end
```

---

## 測試建議

1. **基本功能測試**：確保正常流程仍然工作
2. **錯誤情況 1**：測試重複創建同名文件
3. **錯誤情況 2**：測試在 body 未打開時調用 dump（理論上不會發生，因為 head 總是被調用）
4. **錯誤情況 3**：測試在 body 已關閉後調用 dump
5. **錯誤情況 4**：測試重複調用 finish
6. **錯誤信息驗證**：確保所有錯誤信息精確匹配要求
7. **狀態一致性**：確保狀態變量在正確的時機更新

---

## 常見問題

### Q: 為什麼使用 "exists"？
A: 這是正確的英文語法，因為 "file" 是單數名詞，應該搭配第三人稱單數動詞 "exists"。

### Q: 如果文件在創建後被外部刪除會怎樣？
A: 這不在本練習的錯誤處理範圍內。本練習只處理通過類方法調用產生的錯誤情況。

### Q: 為什麼需要 `@body_opened` 變量？
A: 雖然在正常流程中 `head` 總是被調用，但這個變量確保了狀態追蹤的完整性，並且符合防禦性編程的原則。

### Q: 異常會導致文件資源洩漏嗎？
A: 不會。Ruby 的異常處理機制會確保在異常發生時，未關閉的文件會在垃圾回收時被處理。但在生產環境中，建議使用 `ensure` 塊來確保資源釋放。
