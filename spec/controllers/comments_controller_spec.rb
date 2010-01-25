require 'spec_helper'

describe CommentsController do
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
  end
  
  describe "POST create" do
    before do
      controller.stub!(:validate_brain_buster).and_return(true)
    end
    describe "on article" do
      before do
        post :create, :account_id => @account, :article_id => 1
      end
      
      it { should respond_with(:redirect) }
    end
    describe "on entry" do
      before do
        post :create, :account_id => @account, :entry_id => 1
      end
      
      it { should respond_with(:redirect) }
    end
  end
  
  describe "a spam comment" do
    before do
      controller.stub!(:validate_brain_buster).and_return(true)
      @comment = Factory(:comment, :account => @account)
      @comment.should_receive(:spam?).and_return(:true)
      Comment.should_receive(:new).and_return(@comment)
      post :create, :account_id => @account, :article_id => 1
    end
    
    it "should mark comment as spam" do
      assigns[:comment].spam.should be_true
    end
    it { should respond_with(:redirect) }
  end
  
end
