module Liquid

  module PaginationFilters
  
    def paginate(pagination_info)
      pagination_html = ""
      if pagination_info.is_a?(Hash) && (pagination_info["current_page"] && pagination_info["per_page"] && pagination_info["total_entries"])
       
        pagination_html += "<div class=\"pagination\">"
        
        # Previous link, if appropriate
        pagination_html += "<a href=\"?page=#{pagination_info["current_page"].to_i - 1}\" class=\"prev_page\" rel=\"prev\">&laquo; Newer</a>" if pagination_info["current_page"].to_i > 1 

        # Pagination start-window
        case pagination_info["current_page"].to_i
        when 3
          pagination_html += "<a href=\"?page=1\" rel=\"start\">1</a>"
        when 4
          pagination_html += "<a href=\"?page=1\" rel=\"start\">1</a><a href=\"?page=2\">2</a>"
        when 5
          pagination_html += "<a href=\"?page=1\" rel=\"start\">1</a><a href=\"?page=2\">2</a><a href=\"?page=3\">3</a>"
        else
          if pagination_info["current_page"].to_i > 5
            pagination_html += "<a href=\"?page=1\" rel=\"start\">1</a><a href=\"?page=2\">2</a><span class=\"gap\">&hellip;</span>"
          end
        end
        
        # Current page and pagination window
        pagination_html += "<a href=\"?page=#{pagination_info["current_page"].to_i - 1}\" rel=\"prev\">#{pagination_info["current_page"].to_i - 1}</a>" if pagination_info["current_page"] > 1
        pagination_html += "<span class=\"current\">#{pagination_info["current_page"]}</span>"
        pagination_html += "<a href=\"?page=#{pagination_info["current_page"].to_i + 1}\" rel=\"next\">#{pagination_info["current_page"].to_i + 1}</a>" if (pagination_info["current_page"].to_i * pagination_info["per_page"].to_i) < pagination_info["total_entries"].to_i
        
        # TODO: Pagination end-window
        
        # Next link, if appropriate
        if (pagination_info["current_page"].to_i * pagination_info["per_page"].to_i) < pagination_info["total_entries"].to_i
          pagination_html += "<a href=\"?page=#{pagination_info["current_page"].to_i + 1}\" class=\"next_page\" rel=\"next\">Older &raquo;</a>"
        end
        
        pagination_html += "</div>"
        
      end
      pagination_html
    end
    
    
    def short_paginate(pagination_info)
      pagination_html = ""
      if pagination_info.is_a?(Hash) && (pagination_info["current_page"] && pagination_info["per_page"] && pagination_info["total_entries"])
       
        pagination_html += "<div class=\"pagination\">"
        
        # Previous link, if appropriate
        pagination_html += "<a href=\"?page=#{pagination_info["current_page"].to_i - 1}\" class=\"prev_page\" rel=\"prev\">&laquo; Newer</a>" if pagination_info["current_page"].to_i > 1 

        # Next link, if appropriate
        if (pagination_info["current_page"].to_i * pagination_info["per_page"].to_i) < pagination_info["total_entries"].to_i
          pagination_html += "<a href=\"?page=#{pagination_info["current_page"].to_i + 1}\" class=\"next_page\" rel=\"next\">Older &raquo;</a>"
        end
        
        pagination_html += "</div>"
        
      end
      pagination_html
    end
    
    # Search pagination doesn't expect pages to be sorted by date.
    def search_paginate(pagination_info)
      pagination_html = ""
      if pagination_info.is_a?(Hash) && (pagination_info["current_page"] && pagination_info["per_page"] && pagination_info["total_entries"])
       
        pagination_html += "<div class=\"pagination\">"
        
        # Previous link, if appropriate
        pagination_html += "<a href=\"??q=#{@context.registers[:query]}&page=#{pagination_info["current_page"].to_i - 1}\" class=\"prev_page\" rel=\"prev\">&laquo; Previous</a>" if pagination_info["current_page"].to_i > 1 

        # Next link, if appropriate
        if (pagination_info["current_page"].to_i * pagination_info["per_page"].to_i) < pagination_info["total_entries"].to_i
          pagination_html += "<a href=\"?q=#{@context.registers[:query]}&page=#{pagination_info["current_page"].to_i + 1}\" class=\"next_page\" rel=\"next\">Next &raquo;</a>"
        end
        
        pagination_html += "</div>"
        
      end
      pagination_html
    end
    
    
  end

end