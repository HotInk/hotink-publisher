require 'spec_helper'

describe Section do
  
  it "should generate a liquid-friendly version" do
    section = Factory(:section_with_subcategories)
    section.to_liquid.should == {
      'name' => section.name, 
      'position' => section.position, 
      'id' => section.id, 
      'subcategories' => section.children
    }
  end
  
  it "should use its name as its parameter" do
    section = Factory(:section)
    section.to_param = section.name
  end
  
end
