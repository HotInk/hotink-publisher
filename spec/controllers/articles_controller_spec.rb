require 'spec_helper'

describe ArticlesController, "GET show" do

  it "should render the appropriate template" do
    @account = Factory(:account)
    @section = Factory(:section)
    @article = Factory(:article, :section => @section.name)
    
    @design = Factory(:design, :account => @account)
    @redesign = Factory(:redesign, :account => @account)
    @newspaper = Liquid::NewspaperDrop.new(@account)
    @template = Factory(:page_template, :design => @design, :role => 'articles/show')

    @redesign.stub!(:design).and_return(@design)
    Template.stub!(:find_by_role).and_return(@template)
    Liquid::NewspaperDrop.stub!(:new).and_return(@newspaper)
    @account.stub!(:sections).and_return([@section])
    
    @captcha = mock('captcha')
    @captcha.stub!(:id).and_return(1)
    @captcha.stub!(:question).and_return("A question?")
    BrainBuster.stub!(:find_random_or_previous).and_return(@captcha)

    Account.should_receive(:find).with(@account.id.to_s).and_return(@account)
    Article.should_receive(:find).with(:one, :from =>"/accounts/#{@account.account_resource_id}/articles/#{@article.id}.xml").and_return(@article)
    @template.should_receive(:render).with({
      'current_section' => @section, 
      'article' => @article, 
      'newspaper' => @newspaper, 
      'current_user_id' => nil, 
      'current_user' => nil
    }, :registers => {
      :account => @account,
      :design => @design,
      :form_authenticity_token => controller.send(:form_authenticity_token),
      :captcha_id => @captcha.id,
      :captcha_question => @captcha.question,
      :form_action => "#{@account.url}/articles/#{@article.id.to_s}/comments"
    })

    get :show, :account_id => @account.id, :id => @article.id
  end
  
  it "should redirect users from old urls" do
    get :legacy_show, :id => "2212-the-bears-are-coming"
    should respond_with(:redirect)
    @response.headers['Location'].should == "http://test.host/articles/2212"
  end
end
