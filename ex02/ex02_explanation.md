# ex02：Rescue HTML（自動修復例外）說明

本題的核心是「**讓程式不中斷**」：遇到已存在檔案或 `</body>` 後仍寫入時，不是單純報錯停掉，而是 **raise → 顯示狀態 → 自動修正 → 繼續執行**。

---

## 題目要求（對照實作）

你需要在上一題（`ex01`）的基礎上新增兩個例外類別，並在 `Html` 類別中正確使用它們：

- **`Dup_file < StandardError`**
  - **觸發**：嘗試建立「已存在」的檔案
  - **show_state**：印出相似檔案清單（**完整絕對路徑**）
  - **correct**：把檔名改成在副檔名前插入 `.new`，必要時可多次：
    - `test.html` → `test.new.html` → `test.new.new.html` → ...
  - **explain**：印出「已改名建立」的新檔案路徑（絕對路徑）

- **`Body_closed < StandardError`**
  - **觸發**：在 `</body>` 之後仍呼叫 `dump(...)` 寫入
  - **show_state**：印出檔名 + `</body>` 所在**行號**與該行內容
  - **correct**：移除該 `</body>` → 插入文字 → 再把 `</body>` 放回文件尾端（在 `</html>` 前）
  - **explain**：印出修正後的訊息

---

## 這份 `ex02.rb` 的設計重點

### 1) 例外不是拿來「終止」，而是拿來「修復」

每個例外都有三段固定流程：

- **show_state**：修正前
- **correct**：自動修正（並回傳或產出修正結果）
- **explain**：修正後/修正說明

### 2) `Html.new(...)` 會「自己處理」重複檔名（不需要呼叫端 rescue）

當檔案已存在時，`Html#initialize` 會 raise `Dup_file`，但會在內部立即 rescue，完成：

- 列出相似檔案
- 算出不衝突的新檔名（反覆插入 `.new`）
- 改用新檔名建立檔案並繼續往下跑

這就是題目要的「save the execution of the processes」。

---

## 行為示例（輸出格式）

### 1) 重複檔名（`Dup_file`）

當 `test.html` 已存在，再 `Html.new('test')` 時輸出類似：

```
A file named /.../test.html was already there:
  /.../test.html
Appended .new in order to create requested file: /.../test.new.html
```

若 `test.new.html` 也存在，會繼續變成：

`test.new.new.html`、`test.new.new.new.html` ...

### 2) `</body>` 後寫入（`Body_closed`）

如果 `finish` 後又 `dump(...)`，輸出類似：

```
In demo.html body was closed :
> ln :8 </body>
> ln :8 </body> : text has been inserted and tag moved at the end of it.
```

並且檔案內容會被修正成「文字在 `</body>` 前、標籤順序正確」。

---

## 你可以怎麼跑

在 `Ror_0_Oop/ex02/` 目錄下直接執行：

```bash
ruby ex02.rb
```

---

## 常見檢查點（交作業前自我驗證）

- **`Dup_file`**
  - 相似檔案清單是否為 **絕對路徑**
  - `.new` 是否插在 **副檔名前**（`a.html` → `a.new.html`）
  - 若 `.new` 仍衝突，是否能繼續 `.new.new...`

- **`Body_closed`**
  - 是否印出正確的行號與 `</body>` 那行內容
  - 是否真的把 `</body>` 往後移（而不是新增第二個 `</body>` 造成重複）

---

## 總結

這題的關鍵不是「丟例外」，而是「**丟了也能救回來**」：

- `Dup_file` 讓建立檔案不會因同名而中止，而是自動改名建立
- `Body_closed` 讓 `dump` 不會因 `</body>` 已關閉而失敗，而是自動重排標籤並插入內容
