require 'test/unit'
require File.dirname(__FILE__) + '/test_helper'

class RedclothExtensionsTest < Test::Unit::TestCase
  
  def test_textilize_method
    assert "".respond_to?(:textilize)
  end

  def test_no_caps_span
    assert_equal "My name is PAUL".textilize, "<p>My name is PAUL</p>"
  end

  def test_opening_table_tag
    assert_equal "|a|b|".textilize, "<table cellspacing=\"0\">\n\t<tr>\n\t\t<td>a</td>\n\t\t<td>b</td>\n\t</tr>\n</table>"
  end

  def test_opening_in_polish_formatter
    assert_equal "\"I am.\", said Paul".textilize, "<p>&#8220;I am.&#8221;, said Paul</p>"
    assert_equal "\"I am.\", said Paul".textilize(:lang => "pl"), "<p>&#8222;I am.&#8221;, said Paul</p>"
  end

end
