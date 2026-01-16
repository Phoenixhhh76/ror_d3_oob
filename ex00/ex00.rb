#!/usr/bin/env ruby
# frozen_string_literal: true
# warn_indent: true

class Html
  # attr_reader :page_name creates a read-only method to access @page_name instance variable
  # Equivalent to: def page_name; @page_name; end
  attr_reader :page_name

  def initialize(page_name)
    @page_name = page_name
    # Opens/creates a file named "page_name.html" in write mode ('w') and stores the file handle in @file
    @file = File.open("#{page_name}.html", 'w')
    head
  end

  def head
    @file.puts '<!DOCTYPE html>'
    @file.puts '<html>'
    @file.puts '<head>'
    @file.puts "<title>#{@page_name}</title>"
    @file.puts '</head>'
    @file.puts '<body>'
  end

  def dump(str)
    @file.puts "<p>#{str}</p>"
  end

  def finish
    @file.puts '</body>'
    #@file.puts '</html>'
    @file.close
  end
end

if $PROGRAM_NAME == __FILE__
  a = Html.new("test")
  10.times { |x| a.dump("titi_number#{x}") }
  a.finish
end
