require 'spec_helper'

describe Liquid::NewspaperDrop do
  before do
    @account = Factory(:account)
    @newspaper_drop = Liquid::NewspaperDrop.new(@account)
  end
  
  it "should know the account's url" do
    @account.url = ""
    output = Liquid::Template.parse( ' {{ newspaper.homepage_url }} '  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    output.should == " / "
    
    output = Liquid::Template.parse( ' {{ newspaper.root_url }} '  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    output.should == "  "    
    
    @account.url = '/account_url'
    output = Liquid::Template.parse( ' {{ newspaper.homepage_url }} '  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    output.should == " #{@account.url} "    
    
    output = Liquid::Template.parse( ' {{ newspaper.root_url }} '  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    output.should == " #{@account.url} "
  end

  it "should know the account's name" do
    @account.name = "Test account name"
    output = Liquid::Template.parse( ' {{ newspaper.name }} '  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    output.should == " Test account name "
  end

  it "should know the account's blogs" do
    @blogs = (1..4).collect{ Factory(:blog) }
    Blog.stub!(:find).and_return(@blogs)
    output = Liquid::Template.parse( '{% for blog in newspaper.blogs %} {{ blog.title }} {% endfor %}'  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    
    titles = @blogs.collect{ |b|  b.title  }
    output.should == " #{titles.join('  ')} "
  end

  it "should know the account's latest issues" do
    issues = (1..5).collect{ Factory(:issue, :account_id => @account.account_resource_id) }
    @issues = WillPaginate::Collection.create(1, 15, issues.length) do |pager|
     pager.replace(issues)
    end
    Issue.should_receive(:paginate).with(:all, :params => { :account_id => @account.account_resource_id, :page => 1, :per_page => 15 }).and_return(@issues)
    
    output = Liquid::Template.parse( '{% for issue in newspaper.latest_issues %} {{ issue.name }} {% endfor %}'  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    
    names = @issues.collect{ |i|  i.name  }
    output.should == " #{names.join('  ')} "    
  end
  
  it "should know the account's latest issue" do
    issues = (1..5).collect{ Factory(:issue, :account_id => @account.account_resource_id) }
    @issues = WillPaginate::Collection.create(1, 15, issues.length) do |pager|
     pager.replace(issues)
    end
    Issue.should_receive(:paginate).with(:all, :params => { :account_id => @account.account_resource_id, :page => 1, :per_page => 15 }).and_return(@issues)
    
    output = Liquid::Template.parse( ' {{ newspaper.latest_issue.name }} '  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    output.should == " #{issues.first.name} "
  end
  
  it "should know the account's latest articles from each section" do
    account = Factory(:account, :url => '/accounts/url')
    first_section_articles = (1..3).collect{ Factory(:article, :section => "Section One") }
    second_section_articles = (1..3).collect{ Factory(:article, :section => "Section Two") }
    
    Article.should_receive(:find).with(:all, :from => "/accounts/#{@account.account_resource_id}/query.xml", :params => { :group_by => "section", :count => 5 }).and_return(first_section_articles+second_section_articles)
    
    output = Liquid::Template.parse( ' {% for article in newspaper.latest_by_section["Section One"] %} {{article.title}} {% endfor %} '  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    output.should == "  #{ first_section_articles.collect{|a| a.title }.join('  ') }  "

    output = Liquid::Template.parse( ' {% for article in newspaper.latest_by_section["Section Two"] %} {{article.title}} {% endfor %} '  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    output.should == "  #{ second_section_articles.collect{|a| a.title }.join('  ') }  "
  end

  it "should know the account's latest entries" do
    entries = (1..5).collect{ Factory(:entry) }
    @entries = WillPaginate::Collection.create(1, 15, entries.length) do |pager|
     pager.replace(entries)
    end
    Entry.should_receive(:paginate).with(:all, :from => "/accounts/#{@account.account_resource_id.to_s}/entries.xml", :params => { :page => 1, :per_page => 5}).and_return(@entries)
    
    output = Liquid::Template.parse( '{% for entry in newspaper.latest_entries %} {{ entry.title }} {% endfor %}'  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    
    titles = @entries.collect{ |i|  i.title  }
    output.should == " #{titles.join('  ')} "    
  end  

  it "should know the account's latest entries from each blog" do
    blog_one = Factory(:blog, :title => "First blog", :account => @account)
    blog_two = Factory(:blog, :title => "Second blog", :account => @account)
    blog_one_entries = (1..3).collect{ |n| Factory(:entry, :blogs => [blog_one]) }
    blog_two_entries = (1..3).collect{ |n|  Factory(:entry, :blogs => [blog_two]) }
    
    Entry.should_receive(:find).with(:all, :from => "/accounts/#{@account.account_resource_id}/query.xml", :params => { :group_by => "blog", :count => 5 }).and_return(blog_one_entries+blog_two_entries)
    
    output = Liquid::Template.parse( ' {% for entry in newspaper.latest_from_blog["First blog"] %} {{entry.title}} {% endfor %} '  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    output.should == "  #{ blog_one_entries.collect{|a| a.title }.join('  ') }  "

    output = Liquid::Template.parse( ' {% for entry in newspaper.latest_from_blog["Second blog"] %} {{entry.title}} {% endfor %} '  ).render('newspaper' => Liquid::NewspaperDrop.new(@account))
    output.should == "  #{ blog_two_entries.collect{|a| a.title }.join('  ') }  "
  end
  
end
