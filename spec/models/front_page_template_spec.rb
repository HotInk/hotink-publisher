require 'spec_helper'

describe FrontPageTemplate do
  it { should belong_to(:layout) }
  
  it "should parse a array of data entities into a schema hash" do
    template = Factory(:front_page_template)
    template.stub!(:schema).and_return([{ 'name' => 'lead_articles', 'model' => 'Article', 'quantity' => "2", 'description' => "" }])
    template.parse_schema.should == {'lead_articles' => { 'type' => 'Article', 'description' => '', 'ids' => Array.new(2) } }

    template.stub!(:schema).and_return([
      { 'name' => 'lead_articles', 'model' => 'Article', 'quantity' => "2", 'description' => "" }, 
      { 'name' => 'more_lead_articles', 'model' => 'Article', 'quantity' => 5, 'description' => "Additional lead articles" }  
    ])
    template.parse_schema.should == {
      'lead_articles' =>        { 'type' => 'Article', 'description' => '', 'ids' => Array.new(2) },
      'more_lead_articles' =>   { 'type' => 'Article', 'description' => 'Additional lead articles', 'ids' => Array.new(5) } 
    }
  end
  
  it "should identify its current layout" do
    template = Factory(:front_page_template)
    template.current_layout.should be_nil
    
    design_layout = Factory(:layout)
    template.design.default_layout = design_layout
    template.current_layout.should == design_layout
    
    template_layout = Factory(:layout)
    template.layout = template_layout
    template.current_layout.should == template_layout
  end
  
  it "should render with the appropriate layout" do
    template = Factory(:front_page_template)
    template.render.should == Marshal.load(template.parsed_code).render
    
    design_layout = Factory(:layout)
    template.design.default_layout = design_layout
    template.render.should == design_layout.render({ 'page_content' => Marshal.load(template.parsed_code).render })
    
    template_layout = Factory(:layout)
    template.layout = template_layout
    template.render.should == template_layout.render({ 'page_content' => Marshal.load(template.parsed_code).render })
  end
end
