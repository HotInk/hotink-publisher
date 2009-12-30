require 'spec_helper'

describe FrontPage do
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
end
