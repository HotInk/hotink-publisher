require 'spec_helper'

describe Liquid::ArticleDrop do
  include Liquid::StandardFilters
  
  before do
    @article = Factory(:article)
    @article_drop = Liquid::ArticleDrop.new(@article)
  end
  
  describe "section" do
    it "should know article's section's name" do
      article = Factory(:article, :section => "News-ish")
      output = Liquid::Template.parse( ' {{ article.section }} '  ).render('article' => Liquid::ArticleDrop.new(article))
      output.should == " News-ish "
    end
    
    it "should return nothing when no name is set" do
      article = Factory(:article, :section => nil)
      output = Liquid::Template.parse( ' {{ article.section }} '  ).render('article' => Liquid::ArticleDrop.new(article))
      output.should == "  "
    end
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
  
  it "should return the article's attached media" do
    article_with_mediafiles = Factory(:article, :mediafiles => (1..3).collect{ Factory(:mediafile) } )
    output = Liquid::Template.parse( ' {% for mediafile in article.attached_media %} {{ mediafile.title }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(article_with_mediafiles))
    
    titles = article_with_mediafiles.mediafiles.collect{ |m| m.title }
    output.should == "  #{titles.join('  ')}  "
    
    # Deprecated syntax
    output = Liquid::Template.parse( ' {% for mediafile in article.mediafiles %} {{ mediafile.title }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(article_with_mediafiles))
    
    titles = article_with_mediafiles.mediafiles.collect{ |m| m.title }
    output.should == "  #{titles.join('  ')}  "
  end

  it "should return files that are neither images nor audiofiles" do
    images = (1..3).collect{ Factory(:image) }
    files = (1..3).collect{ Factory(:mediafile) }
    article_with_mediafiles = Factory(:article, :mediafiles => images + files)
    
    output = Liquid::Template.parse( ' {% for file in article.files %} {{ file.title }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(article_with_mediafiles))
    output.should == "  #{files.collect{ |m| m.title }.join('  ')}  "
    
  end

  describe "images" do
    before do
      @images = (1..3).collect{ Factory(:image) }
      @article_with_some_images = Factory(:article, :mediafiles => ((1..3).collect{ Factory(:mediafile) } + @images))
    end
    
    it "should return the article's images" do
      output = Liquid::Template.parse( ' {% for image in article.images %} {{ image.title }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(@article_with_some_images))
    
      titles = @article_with_some_images.mediafiles.select{ |a| a.mediafile_type == "Image" }.collect{ |a|  a.title }
      output.should == "  #{titles.join('  ')}  "    
    end
  
    it "should know whether the article has any images attached" do
      output = Liquid::Template.parse( '{% if article.has_image? %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(@article_with_some_images))
      output.should == " YES "
      
      other_article = Factory(:article)   
      output = Liquid::Template.parse( '{% if article.has_image? %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(other_article))
      output.should == " NO " 
    end
    
    describe "by proportions" do
        it "should know whether the article has a vertical image" do
          article_with_vertical_image = Factory(:article, :mediafiles => [Factory(:image, :width => 1000, :height => 2000)])
          output = Liquid::Template.parse( '{% if article.has_vertical_image? %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(article_with_vertical_image))
          output.should == " YES "

          article_without_vertical_image = Factory(:article, :mediafiles => [Factory(:image, :width => 2000, :height => 1000)])
          output = Liquid::Template.parse( '{% if article.has_vertical_image? %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(article_without_vertical_image))
          output.should == " NO "
        end

        it "should know whether the article has a horizontal image" do
          article_with_horizontal_image = Factory(:article, :mediafiles => [Factory(:horizontal_image)])
          output = Liquid::Template.parse( '{% if article.has_horizontal_image? %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(article_with_horizontal_image))
          output.should == " YES "

          article_without_horizontal_image = Factory(:article, :mediafiles => [Factory(:vertical_image)])
          output = Liquid::Template.parse( '{% if article.has_horizontal_image? %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(article_without_horizontal_image))
          output.should == " NO "
        end

        it "should return the first vertical image" do
          image = Factory(:vertical_image)
          article = Factory(:article, :mediafiles =>[Factory(:mediafile), Factory(:horizontal_image), image])
          output = Liquid::Template.parse( ' {{ article.first_vertical_image.title }} '  ).render('article' => Liquid::ArticleDrop.new(article))
          output.should == " #{image.title} "
        end

        it "should return the first horizontal image" do
          image = Factory(:horizontal_image)
          article = Factory(:article, :mediafiles =>[Factory(:mediafile), Factory(:vertical_image), image])
          output = Liquid::Template.parse( ' {{ article.first_horizontal_image.title }} '  ).render('article' => Liquid::ArticleDrop.new(article))
          output.should == " #{image.title} "
        end
    end
  end
  
  describe "audiofiles" do
    before do
      @audiofiles = (1..3).collect{ Factory(:audiofile) }
      @article_with_audiofiles = Factory(:article, :mediafiles => ((1..3).collect{ Factory(:mediafile) } + @audiofiles))
    end
    
    it "should return the article's audiofiles" do
      output = Liquid::Template.parse( ' {% for audiofile in article.audiofiles %} {{ audiofile.title }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(@article_with_audiofiles))
    
      titles = @article_with_audiofiles.mediafiles.select{ |a| a.mediafile_type == "Audiofile" }.collect{ |a|  a.title }
      output.should == "  #{titles.join('  ')}  "    
    end
  
    it "should know whether the article has any audiofiles attached" do
      output = Liquid::Template.parse( '{% if article.has_audiofile? %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(@article_with_audiofiles))
      output.should == " YES "
      
      other_article = Factory(:article)   
      output = Liquid::Template.parse( '{% if article.has_audiofile? %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(other_article))
      output.should == " NO " 
    end
  end

  it "should know the article's wordcount" do
    article = Factory(:article, :word_count => "746")
    output = Liquid::Template.parse( ' {{ article.word_count }} '  ).render('article' => Liquid::ArticleDrop.new(article))
    output.should == " 746 "    
  end

  describe "tags" do
    before do
      @tags = (1..3).collect{ Factory(:tag) }
      @article_with_tags = Factory(:article, :tags => @tags)
    end
    
    it "should return the article's tags" do
      output = Liquid::Template.parse( ' {% for tag in article.tags %} {{ tag.name }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(@article_with_tags))
    
      names = @article_with_tags.tags.collect{ |a|  a.name }
      output.should == "  #{names.join('  ')}  "
    end
    
    it "should return the article's tags list" do
      output = Liquid::Template.parse( '  {{ article.tags_list }}  '  ).render('article' => Liquid::ArticleDrop.new(@article_with_tags))
      output.should == "  #{@tags[0].name}, #{@tags[1].name}, #{@tags[2].name}  "
      
      article_with_two_tags = Factory(:article, :tags => @tags[0..1])
      output = Liquid::Template.parse( '  {{ article.tags_list }}  '  ).render('article' => Liquid::ArticleDrop.new(article_with_two_tags))
      output.should == "  #{@tags[0].name}, #{@tags[1].name}  "
      
      article_with_one_tag = Factory(:article, :tags => [@tags[0]])
      output = Liquid::Template.parse( '  {{ article.tags_list }}  '  ).render('article' => Liquid::ArticleDrop.new(article_with_one_tag))
      output.should == "  #{@tags[0].name}  "  
      
      article_with_no_tags = Factory(:article)
      output = Liquid::Template.parse( '  {{ article.tags_list }}  '  ).render('article' => Liquid::ArticleDrop.new(article_with_no_tags))
      output.should == "    "    
    end
    
    it "should return the article's tags list, with links to tag search" do
      @account = Factory(:account)
      output = Liquid::Template.parse( '  {{ article.tags_list_with_links }}  '  ).render({'article' => Liquid::ArticleDrop.new(@article_with_tags)}, :registers => {:account => @account} )
      output.should == "  <a href=\"/search?tagged_with=#{CGI.escape(@tags[0].name)}&amp;page=1\">#{@tags[0].name}</a>, <a href=\"/search?tagged_with=#{CGI.escape(@tags[1].name)}&amp;page=1\">#{@tags[1].name}</a>, <a href=\"/search?tagged_with=#{CGI.escape(@tags[2].name)}&amp;page=1\">#{@tags[2].name}</a>  "
 
      article_with_two_tags = Factory(:article, :tags => @tags[0..1])
      output = Liquid::Template.parse( '  {{ article.tags_list_with_links }}  '  ).render({'article' => Liquid::ArticleDrop.new(article_with_two_tags)}, :registers => {:account => @account} )
      output.should == "  <a href=\"/search?tagged_with=#{CGI.escape(@tags[0].name)}&amp;page=1\">#{@tags[0].name}</a>, <a href=\"/search?tagged_with=#{CGI.escape(@tags[1].name)}&amp;page=1\">#{@tags[1].name}</a>  "

      article_with_one_tag = Factory(:article, :tags => [@tags[0]])
      output = Liquid::Template.parse( '  {{ article.tags_list_with_links }}  '  ).render({'article' => Liquid::ArticleDrop.new(article_with_one_tag)}, :registers => {:account => @account} )
      output.should == "  <a href=\"/search?tagged_with=#{CGI.escape(@tags[0].name)}&amp;page=1\">#{@tags[0].name}</a>  "
      
      article_with_no_tags = Factory(:article)
      output = Liquid::Template.parse( '  {{ article.tags_list_with_links }}  '  ).render('article' => Liquid::ArticleDrop.new(article_with_no_tags))
      output.should == "    "
    end
  end
  
  describe "categories" do
    before do
      @categories = (1..3).collect{ Factory(:section) }
      @article_with_categories = Factory(:article, :categories => @categories)
    end
    
    it "should return the article's categories" do
      output = Liquid::Template.parse( ' {% for category in article.categories %} {{ category.name }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(@article_with_categories))
    
      names = @article_with_categories.categories.collect{ |a|  a.name }
      output.should == "  #{names.join('  ')}  "
    end
  end
  
  describe "blogs (for entries only)" do
    before do
      @blogs = (1..3).collect{ Factory(:blog) }
      @entry_in_blogs = Factory(:entry, :blogs => @blogs)
    end
    
    it "should return the article's categories" do
      output = Liquid::Template.parse( ' {% for blog in entry.blogs %} {{ blog.title }} {% endfor %} '  ).render('entry' => Liquid::ArticleDrop.new(@entry_in_blogs))
    
      titles = @entry_in_blogs.blogs.collect{ |a|  a.title }
      output.should == "  #{titles.join('  ')}  "
    end
  end
  
  describe "issues" do
    before do
      @issues = (1..3).collect{ Factory(:issue) }
      @article_in_issues = Factory(:article, :issues => @issues)
    end
    
    it "should return the article's categories" do
      output = Liquid::Template.parse( ' {% for issue in article.issues %} {{ issue.name }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(@article_in_issues))
    
      names = @article_in_issues.issues.collect{ |a|  a.name }
      output.should == "  #{names.join('  ')}  "
    end
  end
  
  describe "authors" do
    before do
      @authors = (1..3).collect{ Factory(:author) }
      @article_with_authors = Factory(:article, :authors => @authors)
    end
    
    it "should return the article's categories" do
      output = Liquid::Template.parse( ' {% for author in article.authors %} {{ author.name }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(@article_with_authors))
    
      names = @article_with_authors.authors.collect{ |a|  a.name }
      output.should == "  #{names.join('  ')}  "
    end
    
    it "should return the article's authors list" do
      output = Liquid::Template.parse( '  {{ article.authors_list }}  '  ).render('article' => Liquid::ArticleDrop.new(@article_with_authors))
      output.should == "  #{@article_with_authors.authors_list}  "
      
      article_with_no_authors = Factory(:article, :authors_list => " " )
      output = Liquid::Template.parse( '  {{ article.authors_list }}  '  ).render('article' => Liquid::ArticleDrop.new(article_with_no_authors))
      output.should == "    "
    end
    
    it "should return the article's authors list with links" do
      @account = Factory(:account)
      output = Liquid::Template.parse( '  {{ article.authors_list_with_links }}  '  ).render({'article' => Liquid::ArticleDrop.new(@article_with_authors)}, :registers => {:account => @account} )
      output.should == "  <a href=\"/search?q=#{CGI.escape(@authors[0].name)}&amp;page=1\">#{@authors[0].name}</a>, <a href=\"/search?q=#{CGI.escape(@authors[1].name)}&amp;page=1\">#{@authors[1].name}</a> and <a href=\"/search?q=#{CGI.escape(@authors[2].name)}&amp;page=1\">#{@authors[2].name}</a>  "
 
      article_with_two_authors = Factory(:article, :authors => @authors[0..1])
      output = Liquid::Template.parse( '  {{ article.authors_list_with_links }}  '  ).render({'article' => Liquid::ArticleDrop.new(article_with_two_authors)}, :registers => {:account => @account} )
      output.should == "  <a href=\"/search?q=#{CGI.escape(@authors[0].name)}&amp;page=1\">#{@authors[0].name}</a> and <a href=\"/search?q=#{CGI.escape(@authors[1].name)}&amp;page=1\">#{@authors[1].name}</a>  "

      article_with_one_author = Factory(:article, :authors => [@authors[0]])
      output = Liquid::Template.parse( '  {{ article.authors_list_with_links }}  '  ).render({'article' => Liquid::ArticleDrop.new(article_with_one_author)}, :registers => {:account => @account} )
      output.should == "  <a href=\"/search?q=#{CGI.escape(@authors[0].name)}&amp;page=1\">#{@authors[0].name}</a>  "
      
      article_with_no_authors = Factory(:article)
      output = Liquid::Template.parse( '  {{ article.authors_list_with_links }}  '  ).render('article' => Liquid::ArticleDrop.new(article_with_no_authors))
      output.should == "    "
    end
  end

  describe "excerpt" do
    before do
      @article_with_summary = Factory(:article, :summary => "Summary text")
      bodytext = <<-TEXT
      Breaking into Toronto’s well-established arts scene can present a huge challenge for even the gutsiest BFA graduate. There’s the intimidation that comes from approaching well-known artists and galleries, the fight to get noticed in a competitive field, and rents that rise whenever the New York Times declares your once-affordable neighbourhood “the next big thing.”

      So, what’s a twentysomething artist to do? Band together with others in the same predicament, of course. Three new collective-run artist spaces in Kensington Market prove that they can tough it out with a little help from their friends.

      ###The venue: Double Double Land (209 Augusta Ave.)

      “Did I mention I can bring big propane burners?” Julia makes notes to her sketchbook using a thick marker.

      “Yeah, that would be great,” Dan replies.

      “Good, because I want to cook with them in the back room.”

      Julia Kennedy is planning a barbeque soirée, the first in a series of themed culinary events that Double Double Land is hosting this year. She’s discussing her proposal in the kitchen of the combined performance space/apartment with residents Jon McCurley, Daniel Vila, Rob Gordon, and Steve Thomas. The room’s industrial appliances and vents, relics of a past life, are softened in the presence of tattered cookbooks and Craigslist lamps.

      The loft space atop La Rosa Bakery used to be an office, then an after-hours club. It was Vila who discovered it after being kicked out of Jamie’s Ar")
    TEXT
      @article_with_no_summary = Factory(:article, :bodytext => bodytext)
    end
    
    it "should deliver existing summary" do
      output = Liquid::Template.parse( '  {{ article.excerpt }}  '  ).render('article' => Liquid::ArticleDrop.new(@article_with_summary))
      output.should == "  #{@article_with_summary.summary}  "
      
      output = Liquid::Template.parse( '  {{ article.excerpt }}  '  ).render('article' => Liquid::ArticleDrop.new(@article_with_no_summary))
      output.should == "  #{truncatewords(@article_with_no_summary.bodytext, 120)}  "
    end
  end
  
  describe "comments" do
    before do
      @article_with_comments = Factory(:article)
      @comments = (1..3).collect{ Factory(:comment, :content_id => @article_with_comments.id, :content_type => "Article") }
    end
    
    it "should return the article's comments" do
      output = Liquid::Template.parse( ' {% for comment in article.comments %} {{ comment.name }} {% endfor %} '  ).render('article' => Liquid::ArticleDrop.new(@article_with_comments))
    
      names = @article_with_comments.comments.collect{ |a|  a.name }
      output.should == "  #{names.join('  ')}  "
    end
    
    it "should return the total number of comments" do
      output = Liquid::Template.parse( '  {{ article.comment_count }}  '  ).render('article' => Liquid::ArticleDrop.new(@article_with_comments))
      output.should == "  #{@article_with_comments.comments.length}  "
    end
  end
  
  describe "locked comments" do
    before do
      @account = Factory(:account)
      @article = Factory(:article, :account_id => @account.account_resource_id)
    end
    
    it "should show as locked when set as locked" do
      ArticleOption.create(:article_id => @article.id, :account_id => @account.id, :comments_locked => true)
      output = Liquid::Template.parse( '{% if article.comments_locked %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(@article))
      output.should == " YES "
    end
    
    it "should show as unlocked when set as unlocked" do
      ArticleOption.create(:article_id => @article.id, :account_id => @account.id, :comments_locked => false)
      output = Liquid::Template.parse( '{% if article.comments_locked %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(@article))
      output.should == " NO "
    end
    
    it "should show as unlocked when not set" do
      output = Liquid::Template.parse( '{% if article.comments_locked %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(@article))
      output.should == " NO "
    end
  end
  
  describe "disabled comments" do
    before do
      @account = Factory(:account)
      @article = Factory(:article, :account_id => @account.account_resource_id)
    end
    
    it "should show as enabled when set as enabled" do
      ArticleOption.create(:article_id => @article.id, :account_id => @account.id, :comments_enabled => true)
      output = Liquid::Template.parse( '{% if article.comments_enabled %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(@article))
      output.should == " YES "
    end
    
    it "should show as enabled when not set" do
      output = Liquid::Template.parse( '{% if article.comments_enabled %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(@article))
      output.should == " YES "
    end
    
    it "should show as disabled when set as disabled" do
      ArticleOption.create(:article_id => @article.id, :account_id => @account.id, :comments_enabled => false)
      output = Liquid::Template.parse( '{% if article.comments_enabled %} YES {% else %} NO {% endif %}'  ).render('article' => Liquid::ArticleDrop.new(@article))
      output.should == " NO "
    end
  end
end
