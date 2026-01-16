#!/usr/bin/env ruby
# frozen_string_literal: true
# warn_indent: true

# Text 類：表示純文本內容
class Text
  def initialize(str)
    @content = str
  end

  def to_s
    @content.to_s
  end
end

# Elem 類：表示 HTML 元素
class Elem
  attr_reader :tag, :content, :opt, :tag_type

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
  
  # 為了兼容測試，當 content 只有一個元素時，返回該元素；否則返回數組
  def content
    if @content.length == 1
      @content[0]
    else
      @content
    end
  end

  def add_content(*args)
    args.each do |arg|
      if arg.is_a?(Array)
        @content.concat(arg)
      else
        @content << arg
      end
    end
  end
  
  # 內部方法：獲取實際的內容數組（用於 to_s）
  def _content_array
    @content
  end

  def to_s
    raw = _to_s_raw.gsub("\n", "\\n")
    "\"#{raw}\""
  end

  # Internal: raw HTML rendering without the extra wrapping quotes.
  # This is used so that nested elements don't get quoted, while top-level to_s does.
  def _to_s_raw
    result = String.new('')

    # Build opening tag
    result << "<#{@tag}"

    # Add attributes
    unless @opt.empty?
      @opt.each do |key, value|
        result << " #{key}='#{value}'"
      end
    end

    # Self-closing tag
    if @tag_type == 'simple'
      result << ' />'
      return result
    end

    # Opening tag end
    result << '>'

    # Content
    content_array = _content_array
    unless content_array.empty?
      if content_array.length == 1 && content_array[0].is_a?(Text)
        result << content_array[0].to_s
      else
        result << "\n"
        content_array.each do |item|
          if item.is_a?(Elem)
            item._to_s_raw.split("\n").each do |line|
              result << line << "\n"
            end
          elsif item.is_a?(Text)
            result << item.to_s << "\n"
          else
            result << item.to_s << "\n"
          end
        end
      end
    else
      result << "\n"
    end

    # Closing tag
    result << "</#{@tag}>"

    result
  end
end

if $PROGRAM_NAME == __FILE__
  # 測試代碼
  puts "=== 測試 1: 基本創建 ==="
  body = Elem.new('body')
  puts "Tag: #{body.tag}"
  puts "Tag type: #{body.tag_type}"
  puts "Content: #{body.content.inspect}"
  puts "Opt: #{body.opt.inspect}"
  puts "to_s: #{body.to_s.inspect}"
  
  puts "\n=== 測試 2: 簡單標籤 ==="
  img = Elem.new('img', '', 'simple', {'src' => 'http://i.imgur.com/pfp3T.jpg'})
  puts "to_s: #{img.to_s.inspect}"
  
  puts "\n=== 測試 3: Text 內容 ==="
  h1 = Elem.new('h1', Text.new('"Oh no, not again!"'))
  puts "to_s: #{h1.to_s.inspect}"
  
  puts "\n=== 測試 4: add_content ==="
  html = Elem.new('html')
  head = Elem.new('head')
  title = Elem.new('title', Text.new('"Hello ground!"'))
  head.add_content(title)
  body.add_content(h1, img)
  html.add_content(head, body)
  puts "HTML output:"
  puts html.to_s
end
