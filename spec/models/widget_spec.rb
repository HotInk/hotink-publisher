require 'spec_helper'

describe Widget do
  include ApplicationHelper
  
  subject { Factory(:widget) }
  
  it { should belong_to(:account) }
  it { should validate_presence_of(:account) }
  
  it { should belong_to(:template) }
  it { should validate_presence_of(:template) }
  
  it { should belong_to(:design) }
  it { should validate_presence_of(:design) }
  
  it { should have_many(:widget_placements).dependent(:destroy) }
  it { should have_many(:templates) }
  
  it { should validate_uniqueness_of(:name).scoped_to(:design_id) }
  
  describe "included data schema" do  
    before do
      @widget = Factory(:widget)
      @articles = (1..3).collect{ Factory(:article) }
      @article_ids = @articles.collect{ |a| a.id }
    end
    
    it "should know its schema article ids" do
      @widget.stub!(:schema).and_return({'lead_articles' => { 'ids' => @article_ids, 'type' => 'Article', 'description' => '' }})
      @widget.schema_article_ids.should == @article_ids
      
      @widget.stub!(:schema).and_return({'lead_articles' => { 'ids' => [@article_ids[0]], 'type' => 'Article', 'description' => '' },
                                                'offlead_articles' => { 'ids' => @article_ids[1..2], 'type' => 'Article', 'description' => '' }})
      @widget.schema_article_ids.should == @article_ids
    end
  end 
end
