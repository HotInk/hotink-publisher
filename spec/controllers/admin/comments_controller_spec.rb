require 'spec_helper'

describe Admin::CommentsController do
  include ApplicationHelper
  
  before do
    @account = Factory(:account)
    Account.stub!(:find).and_return(@account)
    controller.stub!(:require_user).and_return(true)
  end
  
  describe "GET index" do
    before do
      @comments = (1..3).collect{ Factory(:comment, :account => @account) }
      @articles = (1..3).collect{ Factory(:article, :account => @account) }
      Comment.should_receive(:paginate).and_return(@comments)
      Article.should_receive(:find_by_ids).with(@comments.collect { |x| x.content_id }.uniq, :account_id => @account.account_resource_id).and_return(@articles)
      get :index, :account_id => @account
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:comments).with(@comments) }
    it { should assign_to(:articles).with(hash_by_id(@articles)) }    
  end
  
  describe "POST bulk_action" do
    before do
      @comment1 = Factory(:comment, :account => @account)
      Comment.stub!(:find).with(@comment1.id).and_return(@comment1)
      
      @comment2 = Factory(:comment, :account => @account)
      Comment.stub!(:find).with(@comment2.id).and_return(@comment2)
    end
    
    it "should clear flags on indicated comments" do
      @comment1.should_receive(:clear_flags)
      @comment2.should_receive(:clear_flags)
      post :bulk_action, :account_id => @account.id, :action_name => "clear", :comment_ids => [@comment1.id, @comment2.id]
    end
    
    it "should remove indicated comments" do
      @comment1.should_receive(:disable)
      @comment2.should_receive(:disable)
      post :bulk_action, :account_id => @account.id, :action_name => "remove", :comment_ids => [@comment1.id, @comment2.id]
    end
    
    it "should mark indicated comments as spam" do
      @comment1.should_receive(:mark_spam)
      @comment2.should_receive(:mark_spam)
      post :bulk_action, :account_id => @account.id, :action_name => "spam", :comment_ids => [@comment1.id, @comment2.id]
    end
    
    it "should work on single comment" do
      @comment2.should_receive(:mark_spam)
      post :bulk_action, :account_id => @account.id, :action_name => "spam", :comment_ids => [@comment2.id]      
    end
  end
  
  describe "GET clear_all_flags" do
    it "should clear all flags with HTML" do
      Comment.should_receive(:clear_all_flags).with(@account.id)
      get :clear_all_flags, :account_id => @account.id
      should set_the_flash
      should respond_with(:redirect)
    end
    
    it "should clear all flags with JS" do
      Comment.should_receive(:clear_all_flags).with(@account.id)
      xhr :get, :clear_all_flags, :account_id => @account.id
      should set_the_flash
      should respond_with(:success)
    end
  end
  
  describe "GET flag" do
    before do
      @comment = Factory(:comment, :account => @account)
      @comment.should_receive(:flag)
    end
    
    it "should flag the comment in HTML" do
      Comment.should_receive(:find).with(@comment.id.to_s, :conditions => { :account_id => @account.id }).and_return(@comment)
      get :flag, :account_id => @account.id, :id => @comment.id
      should set_the_flash
      should respond_with(:redirect)
    end
    
    it "should flag the comment in JS" do
      Comment.should_receive(:find).with(@comment.id.to_s, :conditions => { :account_id => @account.id }).and_return(@comment)
      xhr :get, :flag, :account_id => @account.id, :id => @comment.id
      should set_the_flash
      should respond_with(:success)
    end
  end
  
  describe "GET enable" do
    before do
      @comment = Factory(:comment, :account => @account)
      @comment.should_receive(:enable)
    end
    
    it "should enable the comment in HTML" do
      Comment.should_receive(:find).with(@comment.id.to_s, :conditions => { :account_id => @account.id }).and_return(@comment)
      get :enable, :account_id => @account.id, :id => @comment.id
      should set_the_flash
      should respond_with(:redirect)
    end
    
    it "should enable the comment in JS" do
      Comment.should_receive(:find).with(@comment.id.to_s, :conditions => { :account_id => @account.id }).and_return(@comment)
      xhr :get, :enable, :account_id => @account.id, :id => @comment.id
      should set_the_flash
      should respond_with(:success)
    end
  end
  
  describe "GET disable" do
    before do
      @comment = Factory(:comment, :account => @account)
      @comment.should_receive(:disable)
    end
    
    it "should disable the comment in HTML" do
      Comment.should_receive(:find).with(@comment.id.to_s, :conditions => { :account_id => @account.id }).and_return(@comment)
      get :disable, :account_id => @account.id, :id => @comment.id
      should set_the_flash
      should respond_with(:redirect)
    end
    
    it "should disable the comment in JS" do
      Comment.should_receive(:find).with(@comment.id.to_s, :conditions => { :account_id => @account.id }).and_return(@comment)
      xhr :get, :disable, :account_id => @account.id, :id => @comment.id
      should set_the_flash
      should respond_with(:success)
    end
  end
end
