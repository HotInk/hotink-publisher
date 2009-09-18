module Liquid

  module PaginationFilters
  
    def paginate(pagination_info)
      pagination_html = ""
      if pagination_info.is_a? Hash
        pagination_html = "<h6>Working</h6>"  
      else
        pagination_html = "<h6>Nothing to paginate</h6>"
      end
      pagination_html
    end
    
  end

end