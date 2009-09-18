module Liquid

  module PaginationFilters
  
    def paginate(pagination_info)
      pagination_html = ""
      if pagination_info.is_a?(Hash) && (pagination_info["current_page"] && pagination_info["per_page"] && pagination_info["total_entries"])
       
        pagination_html += "<div class=\"pagination\">"
        
        # Previous link, if appropriate
        pagination_html += "<a href=\"?page=#{pagination_info["current_page"].to_i - 1}\" class=\"prev_page\" rel=\"prev\">&laquo; Previous</a>" if pagination_info["current_page"].to_i > 1 


        # Next link, if appropriate
        if (pagination_info["current_page"].to_i * pagination_info["per_page"].to_i) < pagination_info["total_entries"].to_i
          pagination_html += "<a href=\"?page=#{pagination_info["current_page"].to_i + 1}\" class=\"next_page\" rel=\"next\">Next &raquo;</a>"
        end
        
        pagination_html += "</div>"
        
      end
      pagination_html
    end
    
  end

end