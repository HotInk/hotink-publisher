module Liquid

  module PaginationFilters
  
    def paginate(pagination_info)
      pagination_html = ""
      if pagination_info["current_page"] && pagination_info["per_page"] && pagination_info["total_entries"]
        pagination_html = "<h6>Working</h6>"  
      else
        pagination_html = "<h6>Nothing to paginate</h6>"
      end
      pagination_html
    end
    
  end

end