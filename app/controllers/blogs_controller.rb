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
    @registers[:account] = @account

    render :text => @current_template.render({'blogs' => @blogs, 'newspaper' => @newspaper}, :registers => @registers )
  end
  

  def show
    @blog = Blog.find(params[:id], :params => { :account_id => @account.account_resource_id })

    page = params[:page] || 1
    per_page = params[:per_page] || 15
    @entries = Entry.paginate( :params => { :blog_id => @blog.id, :account_id => @account.account_resource_id, :page => page, :per_page => per_page })
    @entries_pagination = { 'current_page' => @entries.current_page, 'per_page' => @entries.per_page, 'total_entries' => @entries.total_entries }

    render :text => @current_template.render({'blog' => @blog, 'entries' => @entries, 'entries_pagination' => @entries_pagination, 'newspaper' => @newspaper}, :registers => @registers )
  end

end