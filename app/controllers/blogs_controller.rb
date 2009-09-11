class BlogsController < ApplicationController
  
  skip_before_filter :require_user
  
  before_filter :set_liquid_variables
  before_filter :require_design  
  before_filter :find_template
  before_filter :build_registers
  
  def index
    @blogs = @account.blogs

    # Set design register here, in case the user has specified one other than the current.
    @registers[:design] = @current_template.design

    page_html = @current_template.parsed_code.render({'blogs' => @blogs, 'newspaper' => @newspaper}, :registers => @registers )
    if @current_template.current_layout
      render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'newspaper' => @newspaper}, :registers => @registers)
    else  
      render :text => page_html
    end
  end
  

  def show
    @blog = Blog.find(params[:id], :params => {:account_id => @account.account_resource_id})
    @entries = Entry.paginate(:all, :from => "/accounts/#{@account.account_resource_id.to_s}/blogs/#{@blog.id.to_s}/entries.xml", :params => { :page => (params[:page] || 1), :per_page => ( params[:per_page] || 15) }, :as => @account.access_token )
    if @entries.first.respond_to?(:current_page)
        @entries_pagination = { 'current_page' => @entries.first.current_page, 'per_page' => @entries.first.per_page, 'total_entries' => @entries.first.total_entries }
        @entries = @entries.first.article
    else
        @entries_pagination = {}
        @entires = []
    end
    page_html = @current_template.parsed_code.render({'blog' => @blog, 'entries' => @entries, 'newspaper' => @newspaper}, :registers => @registers )
    if @current_template.current_layout
      render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'newspaper' => @newspaper}, :registers => @registers)
    else  
      render :text => page_html
    end
  end

end