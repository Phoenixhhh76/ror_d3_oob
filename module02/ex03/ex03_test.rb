require_relative 'ex03.rb'
require 'test/unit'
require 'colorize'

class MainTest < Test::Unit::TestCase
  def test_self
    assert_equal(1.to_s, "1" ," Always check your tools ")
  end

  def test_initialize_params
    body = Elem.new('body')
    assert_kind_of( Elem, body,"Should be an instance of Elem")
    assert_kind_of( Array, body.content,"Should be an instance of Array")
    assert_kind_of( Hash, body.opt,"Should be an instance of Hash")
    assert_equal("body", body.tag )
    assert_equal("double", body.tag_type )
    head = Elem.new('head')
    assert_kind_of( Elem, body,"Should be an instance of Elem")
    assert_kind_of( Array, body.content,"Should be an instance of Array")
    assert_kind_of( Hash, body.opt,"Should be an instance of Hash")
    assert_equal("head", head.tag )
    assert_equal("double", head.tag_type )
  end

  def test_initialize_params_2
    img = Elem.new('img', '', 'simple',{'src':'http://i.imgur.com/pfp3T.jpg'})
    assert_kind_of( Elem, img,"Should be an instance of Elem")
    assert_kind_of( Hash, img.opt,"Should be an instance of Hash")
    assert_equal("img", img.tag )
    assert_equal("simple", img.tag_type )
    assert_equal("http://i.imgur.com/pfp3T.jpg", img.opt[:src] )
  end


  def test_to_s
    body = Elem.new('body')
    img = Elem.new('img', '', 'simple',{'src':'http://i.imgur.com/pfp3T.jpg'})
    assert("<body>\n</body>", body.to_s)
    assert("<img src='http://i.imgur.com/pfp3T.jpg' />", img.to_s)
  end

  def test_text
    h1 = Elem.new('h1',Text.new('"Oh no, not again!"'))
    assert_kind_of(Text, h1.content, "Should be an instance of Text")
    assert_kind_of(Elem, h1, "Should be an instance of Elem")
    assert_equal('"<h1>"Oh no, not again!"</h1>"', h1.to_s)
  end

  def test_add_content
    body = Elem.new('body')
    head = Elem.new('head')
    h1 = Elem.new('h1',Text.new('"Oh no, not again!"'))
    title = Elem.new('title', Text.new('"Hello ground!"'))
    img = Elem.new('img', '', 'simple',{'src':'http://i.imgur.com/pfp3T.jpg'})
    html = Elem.new('html')
    head.add_content(title)
    body.add_content(h1, img)
    assert_kind_of(Array, body.content)
    assert_equal(2, body.content.count)
    assert_kind_of(Elem, body.content[0])
    assert_kind_of(Text, body.content[0].content)
    assert_kind_of(Elem, body.content[1])
    assert_equal('"<body>\n<h1>"Oh no, not again!"</h1>\n<img src=\'http://i.imgur.com/pfp3T.jpg\' />\n</body>"', body.to_s)
    html.add_content(head, body)
    assert_kind_of(Array, html.content)
    assert_equal('"<html>\n<head>\n<title>"Hello ground!"</title>\n</head>\n<body>\n<h1>"Oh no, not again!"</h1>\n<img src=\'http://i.imgur.com/pfp3T.jpg\' />\n</body>\n</html>"', html.to_s )
 end

end
