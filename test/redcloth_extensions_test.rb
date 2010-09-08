require File.dirname(__FILE__) + '/test_helper'

class RedclothExtensionsTest < ActiveSupport::TestCase

  def test_textilize_method
    assert ''.respond_to?(:textilize)
  end

  def test_no_span_caps
    assert_equal 'My name is PAUL'.textilize, '<p>My name is PAUL</p>'
  end

  def test_opening_table_tag
    assert_equal '|a|b|'.textilize, "<table cellspacing=\"0\">\n\t<tr>\n\t\t<td>a</td>\n\t\t<td>b</td>\n\t</tr>\n</table>"
  end

  def test_different_formatters
    # Custom Polish HTML formatter (default)
    I18n.locale = ''
    assert_equal '"I am.", said Paul'.textilize, '<p>&#8222;I am.&#8221;, said Paul</p>'

    # Custom Polish HTML formatter (by setting the lang param)
    assert_equal '"I am.", said Paul'.textilize(:lang => 'pl'), '<p>&#8222;I am.&#8221;, said Paul</p>'

    # Custom Polish HTML formatter (by setting I18n.locale)
    I18n.locale = 'pl'
    assert_equal '"I am.", said Paul'.textilize, '<p>&#8222;I am.&#8221;, said Paul</p>'

    # Standard HTML formatter (by setting the lang param)
    assert_equal '"I am.", said Paul'.textilize(:lang => 'en'), '<p>&#8220;I am.&#8221;, said Paul</p>'

    # Standard HTML formatter (by setting I18n.locale)
    I18n.locale = 'en'
    assert_equal '"I am.", said Paul'.textilize, '<p>&#8220;I am.&#8221;, said Paul</p>'
  end

  def test_custom_picture_tag
    # without link without caption at the beggining of text
    input = "picture(centered). /pictures/2010-05/image.jpg|Description|false\n"
    output = %(<div class="centered">\n<p><img src="/pictures/2010-05/image.jpg" alt="Description" /></p>\n</div>)
    assert_equal output, input.textilize

    # with link and caption
    input = "Paragraph\n\npicture(alignright). /pictures/2010-05/image.png|Description|true|http://wp.pl/\n\n\nSome new paragraph."
    output = %(<p>Paragraph</p>\n<div class="alignright">\n<p><a href="http://wp.pl/"><img src="/pictures/2010-05/image.png" alt="Description" /></a></p>\n<p class="caption">Description</p>\n</div>\n<p>Some new paragraph.</p>)
    assert_equal output, input.textilize

    # localized characters // short form
    input = "picture(centered). łódź.jpg"
    output = %(<div class="centered">\n<p><img src="łódź.jpg" alt="" /></p>\n</div>)
    assert_equal output, input.textilize
  end

  def test_custom_video_tag
    input = "video. /videos/2010-07/hiphop-zapowiedz.flv|450x300"
    output = %(<div class="video">\n<object type="application/x-shockwave-flash" width="450" height="300" data="/videos/player.swf?file=/videos/2010-07/hiphop-zapowiedz.flv">\n<param name="movie" value="/videos/player.swf?file=/videos/2010-07/hiphop-zapowiedz.flv" />\n<param name="allowFullScreen" value="true" />\n</object>\n</div>)
    assert_equal output, input.textilize
  end
end
