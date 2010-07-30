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

# custom picture tag
module PictureTag
  #
  # picture(class). src|alt|caption?|link
  #
  #   class    - class for the outer <div> element
  #   src      - <img> src attribute
  #   alt      - <img> alt attribute (acts also as a caption)
  #   caption? - whether to include <p class="caption"> element below the picture (true|false)
  #   link     - image link
  #
  def picture(opts)
    src, description, include_caption, link = opts[:text].split('|').map! {|str| str.strip}
    html  = %Q(<div class="#{opts[:class]}">\n)
    html << %Q(<p>)
    html << %Q(<a href="#{link}">) if link
    html << %Q(<img src="#{src}" alt="#{description}" />)
    html << %Q(</a>) if link
    html << %Q(</p>\n)
    html << %Q(<p class="caption">#{description}</p>\n) if include_caption == 'true'
    html << %Q(</div>\n)
  end
end

# custom video tag
module VideoTag
  #
  # video. src|size
  #
  #   src      - path to the video
  #   size     - size of the video (450x300, for example)
  #
  def video(opts)
    src, size = opts[:text].split('|').map! {|str| str.strip}
    width, height = size.split(/×|x|&#215;/)
    html  = %Q(<div class="video">\n)
    html << %Q(<object type="application/x-shockwave-flash" width="#{width}" height="#{height}" data="/videos/player.swf?file=#{src}">\n)
    html << %Q(<param name="movie" value="/videos/player.swf?file=#{src}" />\n)
    html << %Q(<param name="allowFullScreen" value="true" />\n)
    html << %Q(</object>\n)
    html << %Q(</div>\n)
  end
end

# new textilize method for String class
String.class_eval do
  def textilize(opts = {})
    # Polish formatter is the default formatter
    r = RedCloth.new(self, [:no_span_caps])
    r.extend PictureTag, VideoTag
    r.send((opts[:lang].blank? or opts[:lang] == 'pl') ? 'to_html_pl_formatter' : 'to_html')
  end
end
