require 'spec_helper'

describe Liquid::IssueDrop do
  before do
    @issue = Factory(:issue)
  end

  it "should know some basic issue attributes" do
    output = Liquid::Template.parse( ' {{ issue.id }} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == " #{@issue.id} "
    
    output = Liquid::Template.parse( ' {{ issue.name }} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == " #{@issue.name} "
    
    output = Liquid::Template.parse( ' {{ issue.description }} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == " #{@issue.description} "
  end
  
  it "should know its issue identification numbers" do
    output = Liquid::Template.parse( ' {{ issue.volume }} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == " #{@issue.volume} "
    
    output = Liquid::Template.parse( ' {{ issue.number }} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == " #{@issue.number} "
  end
  
  it "should know the issue PDF file locations" do
    output = Liquid::Template.parse( ' {{ issue.press_pdf_url }} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == " #{@issue.press_pdf_file} "
    
    output = Liquid::Template.parse( ' {{ issue.screen_pdf_url }} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == " #{@issue.screen_pdf_file} "
  end
  
  it "should know the issue PDF cover images" do
    output = Liquid::Template.parse( ' {{ issue.small_cover_image }} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == " #{@issue.small_cover_image} "

    output = Liquid::Template.parse( ' {{ issue.large_cover_image }} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == " #{@issue.large_cover_image} "
  end
  
  it "should know the issue's url" do
    account = Factory(:account, :url => '/accounts/url', :account_resource_id => @issue.account_id)
    output = Liquid::Template.parse( ' {{ issue.url }} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == " #{account.url + '/issues/' + @issue.id.to_s} "    
  end
  
  it "should know the issue's PDF status" do
    issue = Factory(:issue)
    issue_without_pdf = Factory(:issue_without_pdf)
    
    template = ' {% if issue.has_pdf? %}has pdf{% else %}has no pdf{% endif %} '
    
    output = Liquid::Template.parse(template).render('issue' => Liquid::IssueDrop.new(issue))
    output.should == " has pdf "
    
    output = Liquid::Template.parse(template).render('issue' => Liquid::IssueDrop.new(issue_without_pdf))
    output.should == " has no pdf "
  end

  it "should find and return all of its articles" do
    account = Factory(:account, :url => '/accounts/url', :account_resource_id => @issue.account_id)
    articles = (1..7).collect{ Factory(:article) }
    Article.should_receive(:find).with(:all, :from => "/accounts/#{@issue.account_id.to_s}/issues/#{@issue.id.to_s}/articles.xml").and_return(articles)
    
    output = Liquid::Template.parse( ' {% for article in issue.articles %} {{article.title}} {% endfor %} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == "  #{ articles.collect{|n| n.title}.join('  ') }  "
  end

  it "should find and return all of its articles by section" do
    account = Factory(:account, :url => '/accounts/url', :account_resource_id => @issue.account_id)
    first_section_articles = (1..3).collect{ Factory(:article, :section => "Section One") }
    second_section_articles = (1..3).collect{ Factory(:article, :section => "Section Two") }
    Article.should_receive(:find).with(:all, :from => "/accounts/#{@issue.account_id.to_s}/issues/#{@issue.id.to_s}/articles.xml").and_return(first_section_articles+second_section_articles)
    
    output = Liquid::Template.parse( ' {% for article in issue.articles_by_section["Section One"] %} {{article.title}} {% endfor %} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == "  #{ first_section_articles.collect{|a| a.title }.join('  ') }  "

    output = Liquid::Template.parse( ' {% for article in issue.articles_by_section["Section Two"] %} {{article.title}} {% endfor %} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == "  #{ second_section_articles.collect{|a| a.title }.join('  ') }  "
  end

  it "should track the names of each section included in the issue" do
    account = Factory(:account, :url => '/accounts/url', :account_resource_id => @issue.account_id)
    first_section_articles = (1..3).collect{ Factory(:article, :section => "Section One") }
    second_section_articles = (1..3).collect{ Factory(:article, :section => "Section Two") }
    Article.should_receive(:find).with(:all, :from => "/accounts/#{@issue.account_id.to_s}/issues/#{@issue.id.to_s}/articles.xml").and_return(first_section_articles+second_section_articles)
    
    output = Liquid::Template.parse( ' {% for section in issue.sections %} {{section}} {% endfor %} '  ).render('issue' => Liquid::IssueDrop.new(@issue))
    output.should == "  Section One  Section Two  "
  end


 end
