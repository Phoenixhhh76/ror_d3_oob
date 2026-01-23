#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'whereto.rb'

puts "=== Test 1: Html missing Head ==="
invalid1 = Html.new([Body.new([H1.new(Text.new("Test"))])])
test1 = Page.new(invalid1)
result1 = test1.is_valid?
puts "Result: #{result1 ? 'Valid' : 'Invalid'}"
puts

puts "=== Test 2: Head contains multiple Titles ==="
invalid2 = Html.new([
  Head.new([Title.new(Text.new("Title 1")), Title.new(Text.new("Title 2"))]),
  Body.new([H1.new(Text.new("Test"))])
])
test2 = Page.new(invalid2)
result2 = test2.is_valid?
puts "Result: #{result2 ? 'Valid' : 'Invalid'}"
puts

puts "=== Test 3: Img missing src attribute ==="
invalid3 = Html.new([
  Head.new([Title.new(Text.new("Test"))]),
  Body.new([Img.new([])])
])
test3 = Page.new(invalid3)
result3 = test3.is_valid?
puts "Result: #{result3 ? 'Valid' : 'Invalid'}"
puts

puts "=== Test 4: Body contains disallowed element (P contains non-Text) ==="
invalid4 = Html.new([
  Head.new([Title.new(Text.new("Test"))]),
  Body.new([P.new([H1.new(Text.new("Invalid"))])])
])
test4 = Page.new(invalid4)
result4 = test4.is_valid?
puts "Result: #{result4 ? 'Valid' : 'Invalid'}"
puts

puts "=== Test 5: Ul does not contain Li ==="
invalid5 = Html.new([
  Head.new([Title.new(Text.new("Test"))]),
  Body.new([Ul.new([H1.new(Text.new("Invalid"))])])
])
test5 = Page.new(invalid5)
result5 = test5.is_valid?
puts "Result: #{result5 ? 'Valid' : 'Invalid'}"
puts

puts "=== Test 6: Tr contains both Th and Td ==="
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
puts "Result: #{result6 ? 'Valid' : 'Invalid'}"
puts

puts "=== Test 7: H1 contains multiple Texts ==="
invalid7 = Html.new([
  Head.new([Title.new(Text.new("Test"))]),
  Body.new([H1.new([Text.new("Text 1"), Text.new("Text 2")])])
])
test7 = Page.new(invalid7)
result7 = test7.is_valid?
puts "Result: #{result7 ? 'Valid' : 'Invalid'}"
