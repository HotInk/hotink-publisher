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
    
    @article = Article.find(params[:id], :params => { :account_id => @account.account_resource_id })
    
    @registers[:form_authenticity_token] = self.form_authenticity_token
    @registers[:captcha_id] = @captcha.id
    @registers[:captcha_question] = @captcha.question    
    @registers[:form_action] = "#{@account.url}/articles/#{@article.id.to_s}/comments"
    
    render :text => @current_template.render({'current_section' => @account.sections.detect{ |s| s.name == @article.section }, 'article' => @article, 'newspaper' => @newspaper}, :registers => @registers)
  end
  
  
  # temporary redirect action until legacy url code is complete
  def legacy_show
    # grab the id from slugged urls like "3818-cops-bust-frat-boys-for"
    # skip the account part of the URL - this only runs on deployed Hot Ink
    redirect_to "/articles/#{params[:id].split("-")[0]}", :status=>:moved_permanently
  end

end
  