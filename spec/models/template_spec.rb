require 'spec_helper'

describe Template do
  include ApplicationHelper
  
  it { should belong_to(:design) }
  it { should validate_presence_of(:design) }

  it { should have_many(:widgets) }
  it { should have_many(:widget_placements).dependent(:destroy) }
  
  it "should return a default name if one not provided" do
    named_template = Factory(:page_template, :name => "Test template")
    named_template.name.should == "Test template"
    
    unnamed_template = Factory(:page_template, :name => "")
    unnamed_template.name.should == "(Unnamed template)"
  end

  it "should render itself with appropriate options" do
    template = Factory(:template, :code => "Template #1 {{ contents }}")
    options = { 'contents' => "Testing my patience" }
    template.render(options).should == Liquid::Template.parse(template.code).render(options)
  end 

  it "should parse template code before each save" do
    template = Factory(:template)
    template.render.should == Liquid::Template.parse(template.code).render
    
    template.code = "Yo yo, it's yo template"
    template.save
    template.render.should == Liquid::Template.parse(template.code).render
  end
  
  it "should not save when saved with malformed template code" do
    template = Factory.attributes_for(:template)  
    template[:code] = "Hello {% "
    lambda{ PageTemplate.create(template) }.should raise_error(Liquid::SyntaxError)
  end

  describe "widget placement" do
    before do
      @design = Factory(:design)
      @widget1 = Factory(:widget, :design => @design)
      @widget2 = Factory(:widget, :design => @design)
      @widget3 = Factory(:widget)
    end
    
    it "should find and load template's widgets on every save" do
      template = Factory(:template, :code => "{% widget \"#{@widget1.name}\" %}", :design => @design)
      template.widgets.size.should == 1
      template.widgets.should include(@widget1)
      
      template.code = "{% widget \"#{@widget2.name}\" %}"
      template.save
      template.widgets.size.should == 1
      template.widgets.should include(@widget2)
      template.widgets.should_not include(@widget1)  
    end
    
    it "should load as many widgets as are contained in the template" do
      template = Factory( :template, 
                          :code => "{% widget \"#{@widget1.name}\" %} {% widget \"#{@widget2.name}\" %}", 
                          :design => @design)
      template.widgets.size.should == 2
      template.widgets.should include(@widget1)
      template.widgets.should include(@widget2)
    end
    
    it "should only load widgets belonging to template's design" do
      template = Factory( :template, 
                          :code => "{% widget \"#{@widget1.name}\" %} {% widget \"#{@widget2.name}\" %} {% widget \"#{@widget3.name}\" %}", 
                          :design => @design)
      template.widgets.size.should == 2
      template.widgets.should include(@widget1)
      template.widgets.should include(@widget2)
    end
  end
    
  it "should sort widget articles from list of fetched articles" do
    @articles = (1..3).collect{ Factory(:article) }
    @article_ids = @articles.collect{ |a| a.id }
    @design = Factory(:design)
    @widget1 = Factory(:widget, :schema => {'lead_articles' => { 'ids' => @article_ids, 'type' => 'Article', 'description' => '' }}, :design => @design)
    template = Factory(:template, :code => "{% widget \"#{@widget1.name}\" %}", :design => @design)
    template.parsed_widget_data(hash_by_id(@articles)).should == {"lead_articles_#{@widget1.name}" => @articles}
  end
end
