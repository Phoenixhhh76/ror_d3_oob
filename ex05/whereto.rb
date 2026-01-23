#!/usr/bin/env ruby
# frozen_string_literal: true
# warn_indent: true

# ========== Classes copied from ex03 ==========

# Text class: represents plain text content
class Text
  def initialize(str)
    @content = str
  end

  def to_s
    @content.to_s
  end
end

# Elem class: represents HTML elements
class Elem
  attr_reader :tag, :content, :opt, :tag_type

  def initialize(tag, content = [], tag_type = 'double', opt = {})
    @tag = tag
    @tag_type = tag_type
    @opt = opt
    
    # Process content
    if content.is_a?(Array)
      @content = content
    elsif content.nil? || content == ''
      @content = []
    else
      @content = [content]
    end
  end
  
  # For test compatibility: when content has only one element, return the element; otherwise return an array
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
  
  # Internal method: get the actual content array (used for validation and to_s)
  def _content_array
    @content
  end

  def to_s
    result = String.new('')
    result << "<#{@tag}"
    
    unless @opt.empty?
      @opt.each do |key, value|
        result << " #{key}='#{value}'"
      end
    end
    
    if @tag_type == 'simple'
      result << ' />'
      return result
    end
    
    result << '>'
    content_array = _content_array
    unless content_array.empty?
      if content_array.length == 1 && content_array[0].is_a?(Text)
        result << content_array[0].to_s
      else
        result << "\n"
        content_array.each do |item|
          if item.is_a?(Elem)
            item.to_s.split("\n").each do |line|
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
    
    result << "</#{@tag}>"
    result
  end
end

# ========== Classes copied from ex04 ==========

class Html < Elem
  def initialize(content = [])
    super('Html', content)
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

# ========== Page class: validates HTML structure ==========

class Page
  def initialize(elem)
    @root = elem
    @valid = true
    @errors = []
    @verbose = true  # Default: output validation process
  end

  def is_valid?(verbose = true)
    @verbose = verbose
    @valid = true
    @errors = []
    validate_node(@root, true)
    # When verbose = false and validation passes, output "FILE IS OK"
    if @valid
      puts "             FILE IS OK"
    else
      puts "             FILE IS INVALID"
    end
    @valid
  end

  private

  # Helper method: output only in verbose mode
  def verbose_puts(message)
    puts message if @verbose
  end

  # Get the class name of a node
  def get_node_class_name(node)
    node.class.name
  end

  # Get the tag name of a node (for display)
  def get_node_tag(node)
    if node.is_a?(Elem)
      node.tag
    elsif node.is_a?(Text)
      'Text'
    else
      node.class.name
    end
  end

  # Validate a single node
  def validate_node(node, is_root = false, show_evaluating = true, show_validation = true)
    node_class = get_node_class_name(node)
    node_tag = get_node_tag(node)
    
    # Only show "Currently evaluating" for specific nodes
    if show_evaluating && (is_root || node_class == 'Text' || node_class == 'Img')
      verbose_puts "Currently evaluating a #{node_tag} :"
    end
    
    # Rule 1: Check if node type is allowed
    allowed_types = ['Html', 'Head', 'Body', 'Title', 'Meta', 'Img', 'Table', 
                     'Th', 'Tr', 'Td', 'Ul', 'Ol', 'Li', 'H1', 'H2', 'P', 
                     'Div', 'Span', 'Hr', 'Br', 'Text']
    
    unless allowed_types.include?(node_class)
      @valid = false
      verbose_puts "- ERROR: Invalid node type '#{node_class}'"
      return false
    end
    
    # Root node must be Html
    if is_root
      unless node.is_a?(Html)
        @valid = false
        verbose_puts "- ERROR: Root element must be Html, got #{node_class}"
        return false
      end
      verbose_puts "- root element of type \"html\""
      verbose_puts "- Html -> Must contains a Head AND a Body after it"
    end
    
    # Perform specific validation based on node type
    case node_class
    when 'Html'
      validate_html(node, show_validation)
    when 'Head'
      validate_head(node, show_validation)
    when 'Body', 'Div'
      validate_body_or_div(node, show_validation)
    when 'Title', 'H1', 'H2', 'Li', 'Th', 'Td'
      validate_text_only(node, node_tag, show_validation)
    when 'P'
      validate_paragraph(node, show_validation)
    when 'Span'
      validate_span(node, show_validation)
    when 'Ul', 'Ol'
      validate_list(node, node_tag, show_validation)
    when 'Tr'
      validate_table_row(node, show_validation)
    when 'Table'
      validate_table(node, show_validation)
    when 'Img'
      validate_image(node, show_validation)
    when 'Text'
      validate_text_node(node, show_validation)
    end
    
    # Recursively validate child nodes
    if node.is_a?(Elem)
      content_array = node._content_array
      unless content_array.empty?
        # Conditions for showing "Evaluating a multiple node":
        # 1. When validating Html node's children
        # 2. When validating Body node's children (has multiple children or child is not a single Text)
        # 3. Other nodes (except Head, Title, H1): has multiple children or child is not a single Text
        if is_root
          # Html node: check if there are non-Text children like Head or Body
          if content_array.any? { |child| !child.is_a?(Text) }
            verbose_puts "Evaluating a multiple node"
          end
        elsif node_class == 'Body'
          # Body node: has multiple children or child is not a single Text
          if content_array.length > 1 || !content_array[0].is_a?(Text)
            verbose_puts "Evaluating a multiple node"
          end
        elsif node_class != 'Head' && node_class != 'Title' && node_class != 'H1'
          # Other nodes (except Head, Title, H1): has multiple children or child is not a single Text
          if content_array.length > 1 || !content_array[0].is_a?(Text)
            verbose_puts "Evaluating a multiple node"
          end
        end
        
        content_array.each do |child|
          # Head, Title, Body, H1 nodes don't show "Currently evaluating" and validation messages
          child_class = get_node_class_name(child)
          show_child_evaluating = (child_class == 'Text' || child_class == 'Img')
          # Head, Title, Body, H1 nodes don't show validation messages
          show_child_validation = !['Head', 'Title', 'Body', 'H1'].include?(child_class)
          validate_node(child, false, show_child_evaluating, show_child_validation)
        end
      end
    end
    
    true
  end

  # Validate Html node
  def validate_html(node, show_validation = true)
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
      verbose_puts "- ERROR: Html must contain exactly one Head, found #{head_count}"
      return false
    end
    
    if body_count != 1
      @valid = false
      verbose_puts "- ERROR: Html must contain exactly one Body, found #{body_count}"
      return false
    end
    
    if head_index >= body_index
      @valid = false
      verbose_puts "- ERROR: Head must come before Body"
      return false
    end
    
    verbose_puts "Head is OK" if show_validation
    true
  end

  # Validate Head node
  def validate_head(node, show_validation = true)
    content_array = node._content_array
    title_count = 0
    
    content_array.each do |child|
      if child.is_a?(Title)
        title_count += 1
      end
    end
    
    if title_count != 1
      @valid = false
      verbose_puts "- ERROR: Head must contain exactly one Title, found #{title_count}"
      return false
    end
    
    true
  end

  # Validate Body or Div node
  def validate_body_or_div(node, show_validation = true)
    allowed_types = ['H1', 'H2', 'Div', 'Table', 'Ul', 'Ol', 'Span', 'Text', 'Img', 'Hr', 'Br']
    content_array = node._content_array
    
    content_array.each do |child|
      child_class = get_node_class_name(child)
      unless allowed_types.include?(child_class)
        @valid = false
        verbose_puts "- ERROR: #{node.tag} can only contain H1, H2, Div, Table, Ul, Ol, Span, Text, Img, Hr, or Br, found #{child_class}"
        return false
      end
    end
    
    verbose_puts "#{node.tag} content is OK" if show_validation
    true
  end

  # Validate nodes that can only contain one Text
  def validate_text_only(node, node_tag, show_validation = true)
    content_array = node._content_array
    
    if content_array.length != 1
      @valid = false
      verbose_puts "- ERROR: #{node_tag} must contain exactly one Text, found #{content_array.length} elements"
      return false
    end
    
    unless content_array[0].is_a?(Text)
      @valid = false
      verbose_puts "- ERROR: #{node_tag} must contain a Text element, found #{get_node_class_name(content_array[0])}"
      return false
    end
    
    verbose_puts "#{node_tag} content is OK" if show_validation
    true
  end

  # Validate P node
  def validate_paragraph(node, show_validation = true)
    content_array = node._content_array
    
    content_array.each do |child|
      unless child.is_a?(Text)
        @valid = false
        verbose_puts "- ERROR: P can only contain Text elements, found #{get_node_class_name(child)}"
        return false
      end
    end
    
    verbose_puts "P content is OK" if show_validation
    true
  end

  # Validate Span node
  def validate_span(node, show_validation = true)
    allowed_types = ['Text', 'P']
    content_array = node._content_array
    
    content_array.each do |child|
      child_class = get_node_class_name(child)
      unless allowed_types.include?(child_class)
        @valid = false
        verbose_puts "- ERROR: Span can only contain Text or P elements, found #{child_class}"
        return false
      end
    end
    
    verbose_puts "Span content is OK" if show_validation
    true
  end

  # Validate list node (Ul or Ol)
  def validate_list(node, node_tag, show_validation = true)
    content_array = node._content_array
    
    if content_array.empty?
      @valid = false
      verbose_puts "- ERROR: #{node_tag} must contain at least one Li element"
      return false
    end
    
    content_array.each do |child|
      unless child.is_a?(Li)
        @valid = false
        verbose_puts "- ERROR: #{node_tag} can only contain Li elements, found #{get_node_class_name(child)}"
        return false
      end
    end
    
    verbose_puts "#{node_tag} content is OK" if show_validation
    true
  end

  # Validate table row (Tr)
  def validate_table_row(node, show_validation = true)
    content_array = node._content_array
    
    if content_array.empty?
      @valid = false
      verbose_puts "- ERROR: Tr must contain at least one Th or Td element"
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
        verbose_puts "- ERROR: Tr can only contain Th or Td elements, found #{get_node_class_name(child)}"
        return false
      end
    end
    
    if has_th && has_td
      @valid = false
      verbose_puts "- ERROR: Tr cannot contain both Th and Td elements (they are mutually exclusive)"
      return false
    end
    
    verbose_puts "Tr content is OK" if show_validation
    true
  end

  # Validate table (Table)
  def validate_table(node, show_validation = true)
    content_array = node._content_array
    
    content_array.each do |child|
      unless child.is_a?(Tr)
        @valid = false
        verbose_puts "- ERROR: Table can only contain Tr elements, found #{get_node_class_name(child)}"
        return false
      end
    end
    
    verbose_puts "Table content is OK" if show_validation
    true
  end

  # Validate image (Img)
  def validate_image(node, show_validation = true)
    # Check src attribute (may be symbol or string key)
    src_value = node.opt[:src] || node.opt['src']
    
    unless src_value && !src_value.nil?
      @valid = false
      verbose_puts "- ERROR: Img must have a 'src' attribute"
      return false
    end
    
    unless src_value.is_a?(Text)
      @valid = false
      verbose_puts "- ERROR: Img 'src' attribute value must be of type Text, found #{src_value.class.name}"
      return false
    end
    
    verbose_puts "Img content is OK" if show_validation
    true
  end

  # Validate text node (Text)
  def validate_text_node(node, show_validation = true)
    verbose_puts "-Text -> Must contains a simple string" if show_validation
    unless node.is_a?(Text)
      @valid = false
      verbose_puts "- ERROR: Text node must be an instance of Text class"
      return false
    end
    verbose_puts "Text content is OK" if show_validation
    true
  end
end

if $PROGRAM_NAME == __FILE__
  # Test code: execute the command required by the exercise
  toto = Html.new([Head.new([Title.new(Text.new("Hello ground!"))]), 
                   Body.new([H1.new(Text.new("Oh no, not again!")), 
                            Img.new([], {'src' => Text.new('http://i.imgur.com/pfp3T.jpg')})])])
  
  test = Page.new(toto)
  test.is_valid?
  
  tata = Html.new([Head.new([Title.new(Text.new("Hello ground!"))]), 
                   Body.new([H1.new(Text.new("Oh no, not again!")), 
                            Img.new([], {'src' => Text.new('http://i.imgur.com/pfp3T.jpg')})])])
  
  test2 = Page.new(tata)
  test2.is_valid?

  # invalid = Html.new([Head.new([Title.new(Text.new("Test"))]),
  #     Body.new([Ul.new([H1.new(Text.new("Invalid"))])])]) # Ul can only contain Li elements
  # invalid_test = Page.new(invalid)
  # invalid_test.is_valid?
end
