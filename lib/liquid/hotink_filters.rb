module Liquid

  module HotinkFilters

    def word_count(text)
      (text.split(/[^a-zA-Z]/).join(' ').size / 4.5).round
    end
    
    def strftime(date, format)
      date ? date.strftime(format) : nil
    end
    
    def markdown(text)
      markdown = Markdown.new(text).to_html
    end
    
  end
end