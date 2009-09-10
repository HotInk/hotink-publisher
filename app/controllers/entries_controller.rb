class EntriesController < ApplicationController

  before_filter :set_liquid_variables
  before_filter :require_design  
  before_filter :find_template
  before_filter :build_registers
    
  def show
  
    @blog = Blog.find(params[:blog_id].to_i, :account_id => @account.account_resource_id, :as => @account.access_token )    
    @entry = Entry.find(params[:id], :blog_id => @blog.id, :account_id => @account.account_resource_id, :as => @account.access_token )    
    
    # Set design register here, in case the user has specified one other than the current.
    @registers[:design] = @current_template.design

    page_html = @current_template.parsed_code.render({'entry' => @entry, 'blog' => @blog, 'newspaper' => @newspaper}, :registers => @registers )
    if @current_template.current_layout
      render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'newspaper' => @newspaper}, :registers => @registers)
    else  
      render :text => page_html
    end

  end
end