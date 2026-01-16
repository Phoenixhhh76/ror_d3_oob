#!/usr/bin/env ruby
# frozen_string_literal: true
# warn_indent: true

class Html
  attr_reader :page_name

  def initialize(page_name)
    @page_name = page_name
    filename = "#{page_name}.html"
    
    if File.exist?(filename)
      raise "A file named #{filename} already exists!"
    end
    
    @file = File.open(filename, 'w')
    @body_opened = false
    @body_closed = false
    head # after this line, @body_opened will be true
  end

  def head
    @file.puts '<!DOCTYPE html>'
    @file.puts '<html>'
    @file.puts '<head>'
    @file.puts "<title>#{@page_name}</title>"
    @file.puts '</head>'
    @file.puts '<body>'
    @body_opened = true
  end

  def dump(str)
    filename = "#{@page_name}.html"
    
    unless @body_opened
      raise "There is no body tag in #{filename}"
      # to test: remove the head on line 19, and run the code, it will raise an error
    end
    
    if @body_closed
      raise "The body has already been closed in #{filename}"
    end
    
    @file.puts "<p>#{str}</p>"
  end

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
end

if $PROGRAM_NAME == __FILE__
  # Testing code
  begin
    html = Html.new('test')
    10.times { |x| html.dump("titi_number#{x}") }
    html.finish
    
    puts "HTML file '#{html.page_name}.html' has been created successfully!"
    puts "Content of #{html.page_name}.html:"
    puts File.read("#{html.page_name}.html")
    
    # Testing error cases
    puts "\n--- Testing error cases ---"
    
    # Test 1: Creating a file with a name that already exists
    # 'begin' starts a block where exceptions can be caught
    begin
      html2 = Html.new('test')
    # 'rescue => e' catches the exception and stores it in variable 'e'
    rescue => e
      # '#{e.message}' extracts the specific text from the raised exception
      puts "Error 1 (expected): #{e.message}"
    end
    
    # Test 2: Calling dump after the body has been closed
    begin
      html.dump('This should fail')
    rescue => e
      puts "Error 2 (expected): #{e.message}"
    end
    
    # Test 3: Calling finish multiple times
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
