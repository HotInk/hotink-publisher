module Liquid

  module PaginationFilters
  
    def paginate(pagination_info)
      pagination_html = ""
      if pagination_info.is_a? Hash
        if pagination_info["current_page"] && (pagination_info["current_page"].to_i > 1) 
          pagination_html += "<a href=\"?page=#{pagination_info["current_page"].to_i - 1}\" class=\"prev_page\" rel=\"prev\">&laquo; Previous</a> "
        end  
      end
      pagination_html
    end
    
  end

end