# ex05: Validation 說明

## 題目要求

儘管在 HTML 生成方面取得了真正的進展，但我們希望一切更加清晰、更有結構。這就是為什麼要對 HTML 文檔結構施加標準。首先，將前兩個練習的類複製到此練習的文件夾中。

### 實現要求

1. **複製類**：將 ex03 和 ex04 的所有類複製到 ex05.rb 中

2. **創建 Page 類**：
   - 構造函數接受一個繼承自 `Elem` 的實例作為參數
   - 實現 `is_valid?` 方法，返回 `true` 如果所有規則都被遵守，否則返回 `false`

3. **驗證規則**：必須實現以下所有驗證規則

---

## 學習目標

### 1. 理解驗證系統的設計

這個練習教會我們如何設計和實現一個完整的驗證系統：

- **結構化驗證**：將複雜的驗證邏輯分解為多個小函數
- **遞歸遍歷**：使用遞歸來遍歷樹狀結構（HTML DOM 樹）
- **規則分離**：每個驗證規則都有獨立的函數，易於維護和擴展

### 2. 掌握樹狀數據結構的處理

HTML 文檔是一個樹狀結構：
```
Html
├── Head
│   └── Title
│       └── Text
└── Body
    ├── H1
    │   └── Text
    └── Img
```

學習目標：
- 理解樹狀結構的遞歸遍歷
- 掌握深度優先搜索（DFS）的實現
- 理解節點類型和層級關係

### 3. 學習設計模式：訪問者模式（Visitor Pattern）

雖然沒有明確使用訪問者模式，但驗證邏輯體現了類似的思想：
- 對不同類型的節點執行不同的驗證邏輯
- 使用 `case` 語句根據節點類型分發驗證任務

### 4. 理解約束和規則的重要性

在軟件開發中，約束和規則確保：
- **數據完整性**：確保數據結構符合預期
- **系統穩定性**：防止無效數據導致錯誤
- **可維護性**：清晰的規則使代碼更容易理解和維護

### 5. 掌握錯誤報告和調試

驗證系統需要提供清晰的錯誤信息：
- 指出錯誤發生的位置
- 說明違反了哪條規則
- 提供足夠的上下文信息

---

## 驗證規則詳解

### 規則 1：節點類型驗證

**規則**：樹路徑中的節點必須是以下類型之一：
- `html`, `head`, `body`, `title`, `meta`, `img`
- `table`, `th`, `tr`, `td`
- `ul`, `ol`, `li`
- `h1`, `h2`, `p`, `div`, `span`
- `hr`, `br`
- `Text`

**實現**：
```ruby
allowed_types = ['Html', 'Head', 'Body', 'Title', 'Meta', 'Img', 'Table', 
                 'Th', 'Tr', 'Td', 'Ul', 'Ol', 'Li', 'H1', 'H2', 'P', 
                 'Div', 'Span', 'Hr', 'Br', 'Text']
```

**學習要點**：
- 白名單驗證：只允許明確列出的類型
- 類型檢查：使用 `is_a?` 或類名比較

---

### 規則 2：Html 結構驗證

**規則**：Html 必須包含恰好一個 Head，然後一個 Body

**實現邏輯**：
1. 計算 Head 和 Body 的數量
2. 檢查數量是否都為 1
3. 檢查 Head 是否在 Body 之前

**學習要點**：
- **順序驗證**：不僅要檢查存在性，還要檢查順序
- **計數驗證**：確保數量精確匹配（不能多也不能少）

---

### 規則 3：Head 內容驗證

**規則**：Head 應該只包含一個 Title

**實現邏輯**：
1. 遍歷 Head 的所有子節點
2. 計算 Title 的數量
3. 確保數量為 1

**學習要點**：
- **單一性驗證**：確保某個元素只出現一次
- **內容限制**：限制父元素只能包含特定類型的子元素

---

### 規則 4：Body 和 Div 內容驗證

**規則**：Body 和 Div 只能包含以下類型的元素：
- `H1`, `H2`, `Div`, `Table`, `Ul`, `Ol`, `Span`, `Text`
- 自閉合標籤：`Img`, `Hr`, `Br`

**實現邏輯**：
1. 遍歷所有子節點
2. 檢查每個子節點的類型
3. 確保所有類型都在允許列表中

**學習要點**：
- **白名單驗證**：只允許特定類型的子元素
- **類型繼承**：Body 和 Div 有相同的規則，可以共用驗證函數

---

### 規則 5：文本節點驗證

**規則**：`Title`, `H1`, `H2`, `Li`, `Th`, `Td` 只能包含一個 Text

**實現邏輯**：
1. 檢查子節點數量是否為 1
2. 檢查該子節點是否為 Text 類型

**學習要點**：
- **精確匹配**：必須恰好是一個 Text，不能多也不能少
- **類型強制**：只能包含 Text，不能包含其他元素

---

### 規則 6：段落驗證

**規則**：P 只能包含 Text 元素（可以有多個）

**實現邏輯**：
1. 遍歷所有子節點
2. 確保每個子節點都是 Text 類型

**學習要點**：
- **類型一致性**：所有子元素必須是同一類型
- **數量靈活**：可以包含多個 Text（與規則 5 不同）

---

### 規則 7：Span 驗證

**規則**：Span 只能包含 Text 或 P 元素

**實現邏輯**：
1. 遍歷所有子節點
2. 確保每個子節點是 Text 或 P 類型

**學習要點**：
- **多類型允許**：可以包含多種類型的元素，但有限制
- **靈活性與約束的平衡**：比單一類型靈活，但仍有約束

---

### 規則 8：列表驗證

**規則**：Ul 和 Ol 必須包含至少一個 Li，且只能包含 Li 元素

**實現邏輯**：
1. 檢查子節點數量是否至少為 1
2. 確保所有子節點都是 Li 類型

**學習要點**：
- **最小數量驗證**：必須至少有一個元素
- **類型一致性**：所有子元素必須是同一類型

---

### 規則 9：表格行驗證

**規則**：Tr 必須包含至少一個 Th 或 Td，且只能包含 Th 或 Td 元素。Th 和 Td 必須互斥（不能同時存在）

**實現邏輯**：
1. 檢查子節點數量是否至少為 1
2. 檢查所有子節點是否都是 Th 或 Td
3. 檢查是否同時包含 Th 和 Td（互斥驗證）

**學習要點**：
- **互斥驗證**：某些元素不能同時存在
- **複雜條件**：需要檢查多個條件（存在性、類型、互斥性）

---

### 規則 10：表格驗證

**規則**：Table 只能包含 Tr 元素

**實現邏輯**：
1. 遍歷所有子節點
2. 確保每個子節點都是 Tr 類型

**學習要點**：
- **單一類型驗證**：只能包含一種類型的子元素
- **結構完整性**：確保表格結構正確

---

### 規則 11：圖片驗證

**規則**：Img 必須有 `src` 屬性，且該屬性的值必須是 Text 類型

**實現邏輯**：
1. 檢查 `opt` Hash 中是否存在 `src` 鍵
2. 檢查 `src` 的值是否為 Text 類型

**學習要點**：
- **屬性驗證**：不僅驗證元素，還驗證屬性
- **屬性類型驗證**：屬性的值也必須符合特定類型
- **Hash 鍵處理**：需要處理符號鍵（`:src`）和字串鍵（`'src'`）

---

## 程式碼說明

### 第 1-3 行：文件頭部
```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true
# warn_indent: true
```
標準的文件頭部。

---

### 第 5-117 行：從 ex03 複製的類

包含 `Text` 和 `Elem` 類的完整實現。這些是基礎類，所有 HTML 元素都基於它們。

---

### 第 119-245 行：從 ex04 複製的類

包含所有 HTML 元素類：
- 結構類：`Html`, `Head`, `Body`
- 文本類：`Title`, `H1`, `H2`, `P`
- 媒體類：`Img`, `Meta`
- 表格類：`Table`, `Th`, `Tr`, `Td`
- 列表類：`Ul`, `Ol`, `Li`
- 容器類：`Div`, `Span`
- 分隔類：`Hr`, `Br`

---

### 第 247-260 行：Page 類構造函數

```ruby
class Page
  def initialize(elem)
    @root = elem
    @valid = true
    @errors = []
  end

  def is_valid?
    @valid = true
    @errors = []
    validate_node(@root, true)
    @valid
  end
```

**Page 類**：負責驗證 HTML 結構

- `def initialize(elem)`：構造函數，接受根元素
- `@root = elem`：保存根元素引用
- `@valid = true`：驗證狀態標誌
- `@errors = []`：錯誤列表（可選，用於收集所有錯誤）

- `def is_valid?`：公開的驗證方法
  - 重置驗證狀態
  - 從根節點開始驗證
  - 返回驗證結果

**學習要點**：
- **狀態管理**：使用實例變量追蹤驗證狀態
- **入口方法**：提供簡單的公開接口

---

### 第 262-275 行：輔助方法

```ruby
  private

  # 獲取節點的類名
  def get_node_class_name(node)
    node.class.name
  end

  # 獲取節點的標籤名（用於顯示）
  def get_node_tag(node)
    if node.is_a?(Elem)
      node.tag
    elsif node.is_a?(Text)
      'Text'
    else
      node.class.name
    end
  end
```

**輔助方法**：提取節點信息

- `get_node_class_name`：獲取節點的類名（如 'Html', 'Text'）
- `get_node_tag`：獲取節點的標籤名（用於顯示）

**學習要點**：
- **封裝**：將常用操作提取為方法
- **多態處理**：處理不同類型的節點

---

### 第 277-330 行：主驗證方法

```ruby
  def validate_node(node, is_root = false)
    node_class = get_node_class_name(node)
    node_tag = get_node_tag(node)
    
    puts "Currently evaluating a #{node_tag} :"
    
    # 規則 1: 檢查節點類型是否允許
    allowed_types = ['Html', 'Head', 'Body', 'Title', 'Meta', 'Img', 'Table', 
                     'Th', 'Tr', 'Td', 'Ul', 'Ol', 'Li', 'H1', 'H2', 'P', 
                     'Div', 'Span', 'Hr', 'Br', 'Text']
    
    unless allowed_types.include?(node_class)
      @valid = false
      puts "- ERROR: Invalid node type '#{node_class}'"
      return false
    end
    
    # 根節點必須是 Html
    if is_root
      unless node.is_a?(Html)
        @valid = false
        puts "- ERROR: Root element must be Html, got #{node_class}"
        return false
      end
      puts "- root element of type \"html\""
      puts "- Html -> Must contains a Head AND a Body after it"
    end
    
    # 根據節點類型進行特定驗證
    case node_class
    when 'Html'
      validate_html(node)
    when 'Head'
      validate_head(node)
    when 'Body', 'Div'
      validate_body_or_div(node)
    # ... 其他 case
    end
    
    # 遞歸驗證子節點
    if node.is_a?(Elem)
      content_array = node._content_array
      unless content_array.empty?
        if content_array.length > 1 || !content_array[0].is_a?(Text)
          puts "Evaluating a multiple node"
        end
        content_array.each do |child|
          validate_node(child, false)
        end
      end
    end
    
    true
  end
```

**主驗證方法**：遞歸驗證節點

**步驟**：
1. **獲取節點信息**：類名和標籤名
2. **輸出當前節點**：提供驗證過程的可見性
3. **類型檢查**：確保節點類型在允許列表中
4. **根節點檢查**：確保根節點是 Html
5. **特定驗證**：根據節點類型調用相應的驗證函數
6. **遞歸驗證**：驗證所有子節點

**學習要點**：
- **遞歸遍歷**：使用遞歸處理樹狀結構
- **分發邏輯**：使用 `case` 語句根據類型分發驗證任務
- **深度優先搜索**：先驗證當前節點，再驗證子節點

---

### 第 332-360 行：Html 驗證

```ruby
  def validate_html(node)
    content_array = node._content_array
    head_count = 0
    body_count = 0
    head_index = -1
    body_index = -1
    
    content_array.each_with_index do |child, index|
      if child.is_a?(Head)
        head_count += 1
        head_index = index
      elsif child.is_a?(Body)
        body_count += 1
        body_index = index
      end
    end
    
    if head_count != 1
      @valid = false
      puts "- ERROR: Html must contain exactly one Head, found #{head_count}"
      return false
    end
    
    if body_count != 1
      @valid = false
      puts "- ERROR: Html must contain exactly one Body, found #{body_count}"
      return false
    end
    
    if head_index >= body_index
      @valid = false
      puts "- ERROR: Head must come before Body"
      return false
    end
    
    puts "Head is OK"
    true
  end
```

**Html 驗證**：確保結構正確

**驗證邏輯**：
1. 計算 Head 和 Body 的數量
2. 記錄它們的位置
3. 檢查數量是否都為 1
4. 檢查 Head 是否在 Body 之前

**學習要點**：
- **計數驗證**：使用計數器追蹤元素數量
- **位置驗證**：使用索引檢查順序
- **多條件驗證**：需要同時滿足多個條件

---

### 第 362-380 行：Head 驗證

```ruby
  def validate_head(node)
    content_array = node._content_array
    title_count = 0
    
    content_array.each do |child|
      if child.is_a?(Title)
        title_count += 1
      end
    end
    
    if title_count != 1
      @valid = false
      puts "- ERROR: Head must contain exactly one Title, found #{title_count}"
      return false
    end
    
    true
  end
```

**Head 驗證**：確保只有一個 Title

**學習要點**：
- **單一性驗證**：確保某個元素只出現一次
- **簡單計數**：只需要計數，不需要位置信息

---

### 第 382-400 行：Body 和 Div 驗證

```ruby
  def validate_body_or_div(node)
    allowed_types = ['H1', 'H2', 'Div', 'Table', 'Ul', 'Ol', 'Span', 'Text', 'Img', 'Hr', 'Br']
    content_array = node._content_array
    
    content_array.each do |child|
      child_class = get_node_class_name(child)
      unless allowed_types.include?(child_class)
        @valid = false
        puts "- ERROR: #{node.tag} can only contain H1, H2, Div, Table, Ul, Ol, Span, Text, Img, Hr, or Br, found #{child_class}"
        return false
      end
    end
    
    puts "#{node.tag} content is OK"
    true
  end
```

**Body 和 Div 驗證**：白名單驗證

**學習要點**：
- **白名單驗證**：只允許明確列出的類型
- **代碼重用**：Body 和 Div 共用驗證邏輯

---

### 第 402-420 行：文本節點驗證

```ruby
  def validate_text_only(node, node_tag)
    content_array = node._content_array
    
    if content_array.length != 1
      @valid = false
      puts "- ERROR: #{node_tag} must contain exactly one Text, found #{content_array.length} elements"
      return false
    end
    
    unless content_array[0].is_a?(Text)
      @valid = false
      puts "- ERROR: #{node_tag} must contain a Text element, found #{get_node_class_name(content_array[0])}"
      return false
    end
    
    puts "#{node_tag} content is OK"
    true
  end
```

**文本節點驗證**：確保只有一個 Text

**學習要點**：
- **精確匹配**：必須恰好是一個元素
- **類型強制**：必須是 Text 類型

---

### 第 422-436 行：段落驗證

```ruby
  def validate_paragraph(node)
    content_array = node._content_array
    
    content_array.each do |child|
      unless child.is_a?(Text)
        @valid = false
        puts "- ERROR: P can only contain Text elements, found #{get_node_class_name(child)}"
        return false
      end
    end
    
    puts "P content is OK"
    true
  end
```

**段落驗證**：只能包含 Text（可以多個）

**學習要點**：
- **類型一致性**：所有子元素必須是同一類型
- **數量靈活**：可以包含多個 Text

---

### 第 438-454 行：Span 驗證

```ruby
  def validate_span(node)
    allowed_types = ['Text', 'P']
    content_array = node._content_array
    
    content_array.each do |child|
      child_class = get_node_class_name(child)
      unless allowed_types.include?(child_class)
        @valid = false
        puts "- ERROR: Span can only contain Text or P elements, found #{child_class}"
        return false
      end
    end
    
    puts "Span content is OK"
    true
  end
```

**Span 驗證**：可以包含 Text 或 P

**學習要點**：
- **多類型允許**：可以包含多種類型，但有限制

---

### 第 456-478 行：列表驗證

```ruby
  def validate_list(node, node_tag)
    content_array = node._content_array
    
    if content_array.empty?
      @valid = false
      puts "- ERROR: #{node_tag} must contain at least one Li element"
      return false
    end
    
    content_array.each do |child|
      unless child.is_a?(Li)
        @valid = false
        puts "- ERROR: #{node_tag} can only contain Li elements, found #{get_node_class_name(child)}"
        return false
      end
    end
    
    puts "#{node_tag} content is OK"
    true
  end
```

**列表驗證**：至少一個 Li，且只能包含 Li

**學習要點**：
- **最小數量驗證**：必須至少有一個元素
- **非空驗證**：不能為空

---

### 第 480-510 行：表格行驗證

```ruby
  def validate_table_row(node)
    content_array = node._content_array
    
    if content_array.empty?
      @valid = false
      puts "- ERROR: Tr must contain at least one Th or Td element"
      return false
    end
    
    has_th = false
    has_td = false
    
    content_array.each do |child|
      if child.is_a?(Th)
        has_th = true
      elsif child.is_a?(Td)
        has_td = true
      else
        @valid = false
        puts "- ERROR: Tr can only contain Th or Td elements, found #{get_node_class_name(child)}"
        return false
      end
    end
    
    if has_th && has_td
      @valid = false
      puts "- ERROR: Tr cannot contain both Th and Td elements (they are mutually exclusive)"
      return false
    end
    
    puts "Tr content is OK"
    true
  end
```

**表格行驗證**：最複雜的驗證之一

**驗證邏輯**：
1. 檢查是否至少有一個元素
2. 檢查所有元素是否都是 Th 或 Td
3. 檢查 Th 和 Td 是否互斥

**學習要點**：
- **互斥驗證**：某些元素不能同時存在
- **標誌變量**：使用布林變量追蹤狀態
- **多條件檢查**：需要檢查多個條件

---

### 第 512-526 行：表格驗證

```ruby
  def validate_table(node)
    content_array = node._content_array
    
    content_array.each do |child|
      unless child.is_a?(Tr)
        @valid = false
        puts "- ERROR: Table can only contain Tr elements, found #{get_node_class_name(child)}"
        return false
      end
    end
    
    puts "Table content is OK"
    true
  end
```

**表格驗證**：只能包含 Tr

**學習要點**：
- **單一類型驗證**：只能包含一種類型的子元素

---

### 第 528-545 行：圖片驗證

```ruby
  def validate_image(node)
    # 檢查 src 屬性（可能是符號或字串鍵）
    src_value = node.opt[:src] || node.opt['src']
    
    unless src_value && !src_value.nil?
      @valid = false
      puts "- ERROR: Img must have a 'src' attribute"
      return false
    end
    
    unless src_value.is_a?(Text)
      @valid = false
      puts "- ERROR: Img 'src' attribute value must be of type Text, found #{src_value.class.name}"
      return false
    end
    
    puts "Img content is OK"
    true
  end
```

**圖片驗證**：驗證屬性

**驗證邏輯**：
1. 檢查 `src` 屬性是否存在
2. 檢查 `src` 的值是否為 Text 類型
3. 處理符號鍵和字串鍵

**學習要點**：
- **屬性驗證**：不僅驗證元素，還驗證屬性
- **Hash 鍵處理**：Ruby 中 Hash 可以使用符號或字串作為鍵
- **類型驗證**：屬性的值也必須符合特定類型

---

### 第 547-557 行：文本節點驗證

```ruby
  def validate_text_node(node)
    puts "-Text -> Must contains a simple string"
    unless node.is_a?(Text)
      @valid = false
      puts "- ERROR: Text node must be an instance of Text class"
      return false
    end
    puts "Text content is OK"
    true
  end
```

**文本節點驗證**：確保是 Text 實例

**學習要點**：
- **類型檢查**：確保節點是正確的類型

---

## 使用範例

### 範例 1：基本驗證
```ruby
require_relative 'ex05.rb'

html = Html.new([
  Head.new([Title.new(Text.new("My Page"))]),
  Body.new([H1.new(Text.new("Welcome"))])
])

page = Page.new(html)
if page.is_valid?
  puts "Valid HTML!"
else
  puts "Invalid HTML!"
end
```

### 範例 2：複雜結構驗證
```ruby
html = Html.new([
  Head.new([Title.new(Text.new("Table Example"))]),
  Body.new([
    Table.new([
      Tr.new([Th.new(Text.new("Name")), Th.new(Text.new("Age"))]),
      Tr.new([Td.new(Text.new("Alice")), Td.new(Text.new("25"))])
    ])
  ])
])

page = Page.new(html)
page.is_valid?
```

---

## 需注意的內容

### 1. 遞歸遍歷的實現
- 使用 `validate_node` 遞歸調用自身
- 對每個子節點都進行驗證
- 確保所有節點都被檢查

### 2. 驗證順序
- 先驗證當前節點
- 再驗證子節點
- 這是深度優先搜索（DFS）

### 3. 錯誤報告
- 使用 `puts` 輸出驗證過程
- 提供清晰的錯誤信息
- 指出違反的規則

### 4. 狀態管理
- 使用 `@valid` 追蹤整體驗證狀態
- 一旦發現錯誤，設置 `@valid = false`
- 繼續驗證以發現所有錯誤

### 5. 類型檢查
- 使用 `is_a?` 檢查實例類型
- 使用 `class.name` 獲取類名
- 處理不同類型的節點

### 6. 符合規則要求
- ✅ 包含 shebang：`#!/usr/bin/env ruby`
- ✅ 包含警告標誌：`# frozen_string_literal: true`
- ✅ 代碼在類中（非全局作用域）
- ✅ 包含測試代碼（在 `if $PROGRAM_NAME == __FILE__` 區塊中）
- ✅ 未使用 `for`、`while`、`until` 循環（使用 `each`）
- ✅ 複製了前兩個練習的類
- ✅ 實現了所有驗證規則

---

## 測試建議

1. **基本結構測試**：測試正確的 HTML 結構
2. **錯誤結構測試**：測試各種錯誤情況
3. **邊緣情況測試**：測試空元素、單個元素等
4. **複雜結構測試**：測試嵌套結構
5. **屬性驗證測試**：測試 Img 的 src 屬性

---

## 常見問題

### Q: 為什麼要複製類而不是使用 require？
A: 題目明確要求"複製類到文件夾中"，這是為了確保所有代碼在一個文件中，便於提交和測試。

### Q: 為什麼驗證要繼續進行而不是立即返回？
A: 這樣可以發現所有錯誤，而不僅僅是第一個錯誤。這對調試更有幫助。

### Q: 如何處理不同的 Hash 鍵類型？
A: Ruby 中 Hash 可以使用符號（`:key`）或字串（`'key'`）作為鍵，需要同時檢查兩種情況。

---

## 總結

Exercise 05 是一個完整的驗證系統實現，教會我們：

1. **系統設計**：如何設計和實現驗證系統
2. **樹狀結構處理**：如何遞歸遍歷和驗證樹狀數據
3. **規則實現**：如何將自然語言規則轉換為代碼
4. **錯誤處理**：如何提供清晰的錯誤信息
5. **代碼組織**：如何組織複雜的驗證邏輯

這個練習是整個模組的綜合應用，結合了前面所有練習的知識，是一個很好的學習總結。
