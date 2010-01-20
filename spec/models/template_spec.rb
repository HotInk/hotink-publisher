require 'spec_helper'

describe Template do
  
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
end
