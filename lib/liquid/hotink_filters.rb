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
    
    def paginate(collection, pagination )
      case collection
      when "articles"
         @collection = WillPaginate::Collection.create(pagination["current_page"], pagination["per_page"], pagination["total_entries"]) do |pager|
            pager.replace context['articles']
          end
          will_paginate  @collection
      end
    end
    
  end
end