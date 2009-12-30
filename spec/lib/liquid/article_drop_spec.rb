require 'spec_helper'

describe Liquid::ArticleDrop do
  before do
    @article = Factory(:article)
    @article_drop = Liquid::ArticleDrop.new(@article)
  end
  
  it "should make basic attributes available" do
    output = Liquid::Template.parse( ' {{ article.id }} '  ).render('article' => Liquid::ArticleDrop.new(@article))
    output.should == " #{@article.id} "

    output = Liquid::Template.parse( ' {{ article.title }} '  ).render('article' => Liquid::ArticleDrop.new(@article))
    output.should == " #{@article.title} "
    
    output = Liquid::Template.parse( ' {{ article.subtitle }} '  ).render('article' => Liquid::ArticleDrop.new(@article))
    output.should == " #{@article.subtitle} "
    
    output = Liquid::Template.parse( ' {{ article.bodytext }} '  ).render('article' => Liquid::ArticleDrop.new(@article))
    output.should == " #{@article.bodytext} "
  end
  
  it "should make dates available in a variety of formats" do
    output = Liquid::Template.parse( ' {{ article.published_at }} '  ).render('article' => Liquid::ArticleDrop.new(@article))
    output.should == " #{Time.parse(@article.published_at).to_s(:standard).gsub(' ', '&nbsp;')} "
  
    output = Liquid::Template.parse( ' {{ article.published_at_detailed }} '  ).render('article' => Liquid::ArticleDrop.new(@article))
    output.should == " #{Time.parse(@article.published_at).to_s(:long)} "

    output = Liquid::Template.parse( ' {{ article.updated_at }} '  ).render('article' => Liquid::ArticleDrop.new(@article))
    output.should == " #{Time.parse(@article.updated_at).to_s(:standard).gsub(' ', '&nbsp;')} "  
    
    output = Liquid::Template.parse( ' {{ article.updated_at_detailed }} '  ).render('article' => Liquid::ArticleDrop.new(@article))
    output.should == " #{Time.parse(@article.updated_at).to_s(:long)} "  
  end
  
  it "should return some account information" do
    output = Liquid::Template.parse( ' {{ article.account_id }} '  ).render('article' => Liquid::ArticleDrop.new(@article))
    output.should == " #{@article.account_id} "
  end
  
  it "should return the article's url" do
    @account = mock('account')
    Account.should_receive(:find_by_account_resource_id).with(@article.account_id).and_return(@account)
    @account.should_receive(:url).and_return('/account_url')

    output = Liquid::Template.parse( ' {{ article.url }} '  ).render('article' => Liquid::ArticleDrop.new(@article))
    output.should == " #{@article.url} "
  end
  
  it "should return the article's mediafiles" do
    article_with_mediafiles = Factory(:article, :mediafiles => (1..3).collect{ Factory(:mediafile) } )
    output = Liquid::Template.parse( ' {% for mediafile in article.mediafiles %} {{ mediafile.title }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(article_with_mediafiles))
    
    titles = article_with_mediafiles.mediafiles.collect{ |m| m.title }
    output.should == "  #{titles.join('  ')}  "
  end

  it "should return the article's images" do
    images = (1..3).collect{ Factory(:image) }
    article_with_some_images = Factory(:article, :mediafiles => ((1..3).collect{ Factory(:mediafile) } + images))
    output = Liquid::Template.parse( ' {% for image in article.images %} {{ image.title }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(article_with_some_images))
    
    titles = article_with_some_images.mediafiles.select{ |a| a.mediafile_type == "Image" }.collect{ |a|  a.title }
    output.should == "  #{titles.join('  ')}  "    
  end
end
