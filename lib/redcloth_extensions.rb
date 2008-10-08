require 'redcloth'

# always add cellspacing="0" html attribute to the opening <table> tags
module RedCloth::Formatters::HTML
  def table_open(opts)
    "<table#{pba(opts)} cellspacing=\"0\">\n"
  end
end


# custom RedCloth formatter for the Polish language
module RedCloth::Formatters::HTML::Polish
  include RedCloth::Formatters::HTML

  # quotations: double low-9 opening quote
  def quote2(opts)
    "&#8222;#{opts[:text]}&#8221;"
  end
end


# optional usage of Polish html formatter
module RedCloth
  class TextileDoc < String
    def to_html_pl_formatter(*rules)
      apply_rules(rules)
      to(RedCloth::Formatters::HTML::Polish)
    end
  end
end


# new textilize method for String class
String.class_eval do
  def textilize(opts = {})
    RedCloth.new(self, [:no_span_caps]).send(opts[:lang] && opts[:lang] == 'pl' ? 'to_html_pl_formatter' : 'to_html')
  end
end
