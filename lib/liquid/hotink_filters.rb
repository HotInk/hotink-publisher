module Liquid

  module HotinkFilters

    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::TextHelper
    include WillPaginate::ViewHelpers
    include Liquid::UrlFilters
    
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
    
    def pluralized(count, singular, plural = nil)
      pluralize(count.to_i, singular, plural)
    end
    
    def fuzzy_time(date)
      date = DateTime.parse(date)
      time_ago_in_words(date).to_s + " ago"
    end
    
    def test(test)
      Liquid::Template.parse("{% include 'fulcrum/views/layouts/footer' %}").render      
    end
    
    def proxy(title = "")
      return title + @context.registers[:proxy]
    end
    
    def categories_drilldown(article, separator = " / ")
      drilldown = ""
      if article && article.section
        section_category = article.categories.detect { |c| c.name == article.section }
        
        if section_category.parent_id.nil?  
          drilldown += link_to_category(section_category)
          current_category = article.categories.detect{ |c| c.parent_id == section_category.id }
          # If a direct decendent is found, follow that path. If not, check for indirect decendents
          if current_category
            # Run through direct decendents, these are easy 
            while current_category
                drilldown += separator + link_to_category(current_category)
                current_category = article.categories.detect{ |c| c.parent_id == current_category.id }
            end
          else
            for cat in article.categories.reject { |c| c == section_category }
              if is_indirect_child_of?(section_category, cat)
                drilldown += separator + link_to_category(cat)
                return drilldown
              end
            end
          end
        else
          # If the section is not a main category, just return the current section
          drilldown += link_to_category(section_category)
        end
      end      
      return drilldown
    end
    
    private
    
    # Takes a category and a section, tells you if category is indirect child of section.
    def is_indirect_child_of?(section, category)
      return false if section.children.blank?
      return true if section.children.detect { |sub_sec| sub_sec.id == category.parent_id } # this is the operative line. check section children for category parent
      for sub_sec in section.children
        return true if is_indirect_child_of?(sub_sec, category) # check subsection children for category parent
      end
      return false
    end
    
  end
end