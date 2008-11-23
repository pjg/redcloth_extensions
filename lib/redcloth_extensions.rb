require 'redcloth'

# always add cellspacing="0" html attribute to the opening <table> tags
module RedCloth::Formatters::HTML
  def table_open(opts)
    "<table#{pba(opts)} cellspacing=\"0\">\n"
  end
end

# new custom RedCloth HTML formatter for the Polish language
module RedCloth::Formatters::HTML::Polish
  include RedCloth::Formatters::HTML

  # quotations: double low-9 opening quote
  def quote2(opts)
    "&#8222;#{opts[:text]}&#8221;"
  end
end

# new 'to_html' method using the Polish html formatter (:to_html_pl_formatter)
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
    # Polish formatter is the default formatter
    RedCloth.new(self, [:no_span_caps]).send((opts[:lang].blank? or opts[:lang] == 'pl') ? 'to_html_pl_formatter' : 'to_html')
  end
end
