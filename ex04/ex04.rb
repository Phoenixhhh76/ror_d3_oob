#!/usr/bin/env ruby
# frozen_string_literal: true
# warn_indent: true

# 需要先載入 ex03 的 Elem 和 Text 類
require_relative '../ex03/ex03.rb'

# 雙標籤類（可以包含內容）
class Html < Elem
  def initialize(content = [])
    super('Html', content)
  end
  
  # 覆寫 to_s 方法，返回實際的 HTML（不帶引號），以符合 ex04 的輸出要求
  def to_s
    _to_s_raw
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

class Title < Elem
  def initialize(content)
    # 如果 content 是字串，轉換為 Text
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('Title', text_content)
  end
end

class Meta < Elem
  def initialize(opt = {})
    super('Meta', [], 'simple', opt)
  end
end

class Img < Elem
  def initialize(content = [], opt = {})
    super('Img', content, 'simple', opt)
  end
end

class Table < Elem
  def initialize(content = [])
    super('Table', content)
  end
end

class Th < Elem
  def initialize(content)
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('Th', text_content)
  end
end

class Tr < Elem
  def initialize(content = [])
    super('Tr', content)
  end
end

class Td < Elem
  def initialize(content)
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('Td', text_content)
  end
end

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

class P < Elem
  def initialize(content)
    text_content = content.is_a?(String) ? Text.new(content) : content
    super('P', text_content)
  end
end

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

if $PROGRAM_NAME == __FILE__
  # 測試代碼：執行題目要求的命令
  puts Html.new([Head.new([Title.new("Hello ground!")]),
                 Body.new([H1.new("Oh no, not again!"),
                          Img.new([], {'src' => 'http://i.imgur.com/pfp3T.jpg'})])])
end
