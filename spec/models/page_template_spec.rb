require 'spec_helper'

describe PageTemplate do
  
  it { should belong_to(:layout) }
  
  it "should identify its current layout" do
    template = Factory(:page_template)
    template.current_layout.should be_nil
    
    design_layout = Factory(:layout)
    template.design.default_layout = design_layout
    template.current_layout.should == design_layout
    
    template_layout = Factory(:layout)
    template.layout = template_layout
    template.current_layout.should == template_layout
  end
  
  it "should render with the appropriate layout" do
    template = Factory(:page_template)
    template.render.should == Marshal.load(template.parsed_code).render
    
    design_layout = Factory(:layout)
    template.design.default_layout = design_layout
    template.render.should == design_layout.render({ 'page_content' => Marshal.load(template.parsed_code).render })
    
    template_layout = Factory(:layout)
    template.layout = template_layout
    template.render.should == template_layout.render({ 'page_content' => Marshal.load(template.parsed_code).render })
  end
  
end
