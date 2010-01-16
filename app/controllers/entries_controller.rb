class EntriesController < ApplicationController

  skip_before_filter :require_user

  before_filter :set_liquid_variables
  before_filter :require_design  
  before_filter :find_template
  before_filter :build_registers
  before_filter :load_widget_data
  before_filter :create_brain_buster, :only => [:show]
    
  def show
    @blog = Blog.find(params[:blog_id].to_i, :params => { :account_id => @account.account_resource_id } )    
    @entry = Entry.find(params[:id], :params => { :blog_id => @blog.id, :account_id => @account.account_resource_id } )    
    
    @registers[:form_authenticity_token] = self.form_authenticity_token
    @registers[:captcha_id] = @captcha.id
    @registers[:captcha_question] = @captcha.question    
    @registers[:form_action] = "#{@account.url}/blogs/#{@entry.blog_id}/entries/#{@entry.id}/comments"
    
    # Set design register here, in case the user has specified one other than the current.
    @registers[:design] = @current_template.design
 
    render :text => @current_template.render({'entry' => @entry, 'blog' => @blog, 'newspaper' => @newspaper, 'current_user' => current_user}, :registers => @registers )
  end
end