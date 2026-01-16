#!/usr/bin/env ruby
# frozen_string_literal: true
# warn_indent: true

# Custom exception: handles duplicate file creation
class Dup_file < StandardError
  def initialize(requested_path, existing_files)
    @requested_path = requested_path
    @existing_files = existing_files
    super("#{requested_path} already exist!")
  end

  def show_state
    puts "A file named #{File.absolute_path(@requested_path)} was already there:"
    @existing_files.each do |file|
      puts "  #{File.absolute_path(file)}"
    end
  end

  def correct
    # Find a non-existing filename (repeatedly insert ".new" before the extension)
    dir = File.dirname(@requested_path)
    dir = Dir.pwd if dir == '.'

    basename = File.basename(@requested_path)
    ext = File.extname(basename)
    stem = ext.empty? ? basename : File.basename(basename, ext)

    loop do
      candidate = if ext.empty?
                    File.join(dir, "#{stem}.new")
                  else
                    File.join(dir, "#{stem}.new#{ext}")
                  end
      unless File.exist?(candidate)
        @new_filename = candidate
        return candidate
      end
      stem = "#{stem}.new"
    end
  end

  def explain
    puts "Appended .new in order to create requested file: #{File.absolute_path(@new_filename)}"
  end
end

# Custom exception: handles writes after </body> has been closed
class Body_closed < StandardError
  def initialize(filename, line_number, line_content)
    @filename = filename
    @line_number = line_number
    @line_content = line_content
    super("The body has already been closed in #{filename}")
  end

  def show_state
    puts "In #{@filename} body was closed :"
    puts "> ln :#{@line_number} #{@line_content}"
  end

  def correct(file_content, new_text)
    # Find the </body> tag and remove it
    lines = file_content.split("\n")
    body_close_index = lines.index { |line| line.strip == '</body>' }
    
    if body_close_index
      # Remove the </body> tag
      lines.delete_at(body_close_index)
      # Insert the new text at the same position
      lines.insert(body_close_index, "<p>#{new_text}</p>")
      # Find </html> and insert </body> right before it
      html_close_index = lines.index { |line| line.strip == '</html>' }
      if html_close_index
        lines.insert(html_close_index, '</body>')
      else
        # If </html> is missing, append </body> and </html>
        lines << '</body>'
        lines << '</html>'
      end
    else
      # If </body> is missing, insert before </html> (or append everything)
      html_close_index = lines.index { |line| line.strip == '</html>' }
      if html_close_index
        lines.insert(html_close_index, "<p>#{new_text}</p>")
        lines.insert(html_close_index + 1, '</body>')
      else
        lines << "<p>#{new_text}</p>"
        lines << '</body>'
        lines << '</html>'
      end
    end
    
    @corrected_content = lines.join("\n")
    @corrected_content
  end

  def explain
    puts "> ln :#{@line_number} #{@line_content} : text has been inserted and tag moved at the end of it."
  end
end

class Html
  attr_reader :page_name

  def initialize(page_name, filename = nil)
    @page_name = page_name
    @filename = filename || "#{page_name}.html"

    begin
      if File.exist?(@filename)
        dir = File.dirname(@filename)
        dir = Dir.pwd if dir == '.'
        basename = File.basename(@filename)
        ext = File.extname(basename)
        stem = ext.empty? ? basename : File.basename(basename, ext)
        pattern = ext.empty? ? "#{stem}*" : "#{stem}*#{ext}"
        existing_files = Dir.glob(File.join(dir, pattern)).select { |f| File.file?(f) }
        raise Dup_file.new(@filename, existing_files)
      end
    rescue Dup_file => e
      e.show_state
      @filename = e.correct
      e.explain
    end

    @file = File.open(@filename, 'w')
    @body_opened = false
    @body_closed = false
    head
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
    end
    
    if @body_closed
      # Read file content to locate the </body> line and its line number
      @file.close if @file && !@file.closed?
      file_content = File.read(@filename)
      lines = file_content.split("\n")
      # Locate the </body> tag line number
      body_close_index = lines.index { |line| line.strip == '</body>' }
      line_number = body_close_index ? body_close_index + 1 : lines.length
      line_content = body_close_index ? lines[body_close_index].strip : (lines.last&.strip || '')
      
      # Raise the exception and handle it (auto-fix)
      begin
        raise Body_closed.new(filename, line_number, line_content)
      rescue Body_closed => e
        e.show_state
        corrected = e.correct(file_content, str)
        File.write(@filename, corrected)
        e.explain
        @body_closed = false  # Re-open the body
        # Re-open the file in append mode
        @file = File.open(@filename, 'a')
        return
      end
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
  # Test code
  begin
    # Cleanup old files
    File.delete('test.html') if File.exist?('test.html')
    File.delete('test.new.html') if File.exist?('test.new.html')
    File.delete('test.new.new.html') if File.exist?('test.new.new.html')
    
    puts "=== Test 1: Normal file creation ==="
    html = Html.new('test')
    html.dump('Hello World')
    html.dump('This is a test')
    html.finish
    
    puts "HTML file '#{html.page_name}.html' has been created successfully!"
    puts "\n=== Test 2: Handling duplicate file exception ==="

    html2 = Html.new('test')
    html2.dump('Content in new file')
    html2.finish
    puts "New file created successfully!"
    
    puts "\n=== Test 3: Handling Body_closed exception ==="
    html3 = Html.new('demo')
    html3.dump('First paragraph')
    html3.finish
    
    # Try writing after the body is closed
    html3.dump('This should be inserted before </body>')
    # No need to call finish again: correct() already moved </body> and preserved </html>
    
    puts "\nContent of demo.html:"
    puts File.read('demo.html')
    
  rescue => e
    puts "Unexpected error: #{e.message}"
    puts e.backtrace
  end
end
