module Liquid

  module HotinkFilters

    include ActionView::Helpers::DateHelper
    include WillPaginate::ViewHelpers
    
    def word_count(text)
      (text.split(/[^a-zA-Z]/).join(' ').size / 4.5).round
    end
    
    def format_time(date, format)
      date = DateTime.parse(date)
      date ? date.strftime(format) : nil
    end
    
    def markdown(text)
      markdown = BlueCloth.new(text).to_html
    end
    
    def fuzzy_time(date)
      date = DateTime.parse(date)
      time_ago_in_words(date).to_s + " ago"
    end
    
    def test(test)
      Liquid::Template.parse("{% include 'fulcrum/views/layouts/footer' %}").render      
    end
    
    def paginated_with(collection, pagination )
      begin
      if pagination["current_page"]&& pagination["per_page"]&&pagination["total_entries"]
        @collection = WillPaginate::Collection.create(pagination["current_page"], pagination["per_page"], pagination["total_entries"]) do |pager|
          pager.replace collection
        end
        will_paginate @collection
      elsif pagination["current_page"]
        if pagination["current_page"].to_i>1
          "<a href=\"?page=#{(pagination["current_page"].to_i - 1).to_s}\"> &laquo; Newer entries</a> <a href=\"?page=#{(pagination["current_page"].to_i + 1).to_s}\">Older entries &raquo;</a>"
        else
          "<a href=\"?page=2\">Older entries &raquo;</a>"
        end
      else
        "<a href=\"?page=2\">Older entries &raquo;</a>"
      end
      rescue
        "<!-- no pagination -->"
      end
    end
    
  end
end