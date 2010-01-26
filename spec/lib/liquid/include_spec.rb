require 'spec_helper'

describe Liquid::Include do
  it "should find and include partial template" do
    @partial = Factory(:partial_template, :name => "Test partial", :code => "This is a partial template")
    output = Liquid::Template.parse( " {% include \"#{@partial.name}\" %} "  ).render({}, :registers => { :design => @partial.design } )
    output.should == " #{@partial.code} "
  end
  
  it "should include partial template variable, if supplied" do
    @partial = Factory(:partial_template, :name => "Smart partial", :code => "{{ article.title }}")
    @article = Factory(:article)
    output = Liquid::Template.parse( " {% include \"#{@partial.name}\" for article %} "  ).render({'article' => @article}, :registers => { :design => @partial.design } )
    output.should == " #{@article.title} "
  end
end
