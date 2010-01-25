require 'spec_helper'

describe PodcastsController do
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  describe "GET show" do
    before do
      @podcast = Factory(:podcast, :account => @account)
      @entries = (1..3).collect { Factory(:entry, :account => @account) }
      @entries.each { |e| e.stub!(:audiofiles).and_return([Factory(:mediafile, :account => @account)]) }
      Entry.stub!(:find).and_return(@entries)
      get :show, :account_id => @account.id, :id => @podcast.id
    end
    
    it { should assign_to(:entries).with(@entries) }
    it { should render_template('show') }
  end
end
