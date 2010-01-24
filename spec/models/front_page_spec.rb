require 'spec_helper'

describe FrontPage do
    include ApplicationHelper
    
    it { should belong_to(:account) }
    it { should validate_presence_of(:account) }
    
    it { should belong_to(:design) }
    
    it { should belong_to(:template) }
    it { should validate_presence_of(:template) }
    
    it { should have_many(:press_runs) }
    
    it "should identify drafts" do
      draft_front_page = Factory(:front_page)
      current_front_page = Factory(:front_page, :account => draft_front_page.account)
      press_run = Factory(:press_run, :front_page => current_front_page, :account => draft_front_page.account)
      FrontPage.drafts.should include(draft_front_page)
      FrontPage.drafts.should_not include(current_front_page)
    end
    
    it "should know how to render itself" do
      template = mock('front page template')
      front_page = Factory(:front_page)
      front_page.should_receive(:template).and_return(template)
      template.should_receive(:render).with({}, {})
      
      front_page.render
    end
    
    describe "featured article schema" do  
      before do
        @front_page = Factory(:front_page)
        @articles = (1..3).collect{ Factory(:article) }
        @article_ids = @articles.collect{ |a| a.id }
      end
      
      it "should know its schema article ids" do
        @front_page.stub!(:schema).and_return({'lead_articles' => { 'ids' => @article_ids, 'type' => 'Article', 'description' => '' }})
        @front_page.schema_article_ids.should == @article_ids
        
        @front_page.stub!(:schema).and_return({'lead_articles' => { 'ids' => [@article_ids[0]], 'type' => 'Article', 'description' => '' },
                                                  'offlead_articles' => { 'ids' => @article_ids[1..2], 'type' => 'Article', 'description' => '' }})
        @front_page.schema_article_ids.should == @article_ids
      end
        
      it "should sort articles according to schema" do
        @front_page.stub!(:schema).and_return({'lead_articles' => { 'ids' => @article_ids, 'type' => 'Article', 'description' => '' }})
        @front_page.sorted_schema_articles(hash_by_id(@articles)).should == {'lead_articles' => @articles}
      end
    end
end
