require 'spec_helper'

describe WidgetTemplate do
  it "should parse a array of data entities into a schema hash" do
    template = Factory(:widget_template)
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
  
  it "should NOT load widgets" do
    design = Factory(:design)
    widget1 = Factory(:widget, :design => design)
    template = Factory(:widget_template, :code => "{% widget \"#{widget1.name}\" %}", :design => design)
    template.widgets.size.should == 0
    template.widgets.should_not include(widget1)
  end
end