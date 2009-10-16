class ArticlesController < ApplicationController
  
  skip_before_filter :require_user, :only => [:show, :legacy_show]
  
  before_filter :require_design, :only => :show
  before_filter :set_liquid_variables, :only => :show
  before_filter :find_template, :only => :show
  before_filter :build_registers, :only => :show
  before_filter :load_widget_data, :only => :show

  before_filter :create_brain_buster, :only => [:show]
  
  # Since the show action is public facing, it should always fail in a predictable
  # informative way.
  def show
    
    @article = Article.find(params[:id], :account_id => @account.account_resource_id, :as => @account.access_token)
    @comments = @article.comments
    
    @registers[:form_authenticity_token] = self.form_authenticity_token
    @registers[:captcha_id] = @captcha.id
    @registers[:captcha_question] = @captcha.question
    @registers[:article] = @article
  
    
    page_html = @current_template.parsed_code.render({'article' => @article, 'newspaper' => @newspaper}, :registers => @registers )
    if @current_template.current_layout
      render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'article' => @article, 'newspaper' => @newspaper}, :registers => @registers)
    else  
      render :text => page_html
    end 
    #render :text => "Sorry, the page you were looking for could not be found.", :status => :not_found # If the current deisgn has no article template we should render 404
  end
  
  
  # temporary redirect action until legacy url code is complete
  def legacy_show
    # grab the id from slugged urls like "3818-cops-bust-frat-boys-for"
    # skip the account part of the URL - this only runs on deployed Hot Ink
    redirect_to "/articles/#{params[:id].split("-")[0]}", :status=>:moved_permanently
  end

end
  