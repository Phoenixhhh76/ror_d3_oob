#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'ex05.rb'

puts "=== 測試 1: Html 缺少 Head ==="
invalid1 = Html.new([Body.new([H1.new(Text.new("Test"))])])
test1 = Page.new(invalid1)
result1 = test1.is_valid?
puts "結果: #{result1 ? '有效' : '無效'}"
puts

puts "=== 測試 2: Head 包含多個 Title ==="
invalid2 = Html.new([
  Head.new([Title.new(Text.new("Title 1")), Title.new(Text.new("Title 2"))]),
  Body.new([H1.new(Text.new("Test"))])
])
test2 = Page.new(invalid2)
result2 = test2.is_valid?
puts "結果: #{result2 ? '有效' : '無效'}"
puts

puts "=== 測試 3: Img 缺少 src 屬性 ==="
invalid3 = Html.new([
  Head.new([Title.new(Text.new("Test"))]),
  Body.new([Img.new([])])
])
test3 = Page.new(invalid3)
result3 = test3.is_valid?
puts "結果: #{result3 ? '有效' : '無效'}"
puts

puts "=== 測試 4: Body 包含不允許的元素（P 包含非 Text） ==="
invalid4 = Html.new([
  Head.new([Title.new(Text.new("Test"))]),
  Body.new([P.new([H1.new(Text.new("Invalid"))])])
])
test4 = Page.new(invalid4)
result4 = test4.is_valid?
puts "結果: #{result4 ? '有效' : '無效'}"
puts

puts "=== 測試 5: Ul 不包含 Li ==="
invalid5 = Html.new([
  Head.new([Title.new(Text.new("Test"))]),
  Body.new([Ul.new([H1.new(Text.new("Invalid"))])])
])
test5 = Page.new(invalid5)
result5 = test5.is_valid?
puts "結果: #{result5 ? '有效' : '無效'}"
puts

puts "=== 測試 6: Tr 同時包含 Th 和 Td ==="
invalid6 = Html.new([
  Head.new([Title.new(Text.new("Test"))]),
  Body.new([
    Table.new([
      Tr.new([Th.new(Text.new("Header")), Td.new(Text.new("Data"))])
    ])
  ])
])
test6 = Page.new(invalid6)
result6 = test6.is_valid?
puts "結果: #{result6 ? '有效' : '無效'}"
puts

puts "=== 測試 7: H1 包含多個 Text ==="
invalid7 = Html.new([
  Head.new([Title.new(Text.new("Test"))]),
  Body.new([H1.new([Text.new("Text 1"), Text.new("Text 2")])])
])
test7 = Page.new(invalid7)
result7 = test7.is_valid?
puts "結果: #{result7 ? '有效' : '無效'}"
