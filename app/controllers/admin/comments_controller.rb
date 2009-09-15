class Admin::CommentsController < ApplicationController

  layout 'admin'
  
  before_filter :require_user

  def dashboard
    
  end

  def index
    # @comments = Comment.paginate :page => params[:page], :per_page => 50
    
    conditions = {:account_id => @account.id}
    
    @comments = Comment.paginate(:page => params[:page], :per_page => 3, :conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end
  
  def clear_all_flags
    respond_to do |format|
      if Comment.clear_all_flags(@account.id)
        flash[:notice] = 'Flags cleared'
        format.html { redirect_to(account_comments_path) }
        format.js { head :ok } 
        format.xml  { head :ok }
      else
        flash[:notice] = "An error has occurred"
        format.html { redirect_to(account_comments_path) }
      end
    end  
  end

  def show
    @page = Admin::Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def new
    @page = Admin::Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end


  def edit
    @page = Admin::Page.find(params[:id])
  end


  def create
    @page = Admin::Page.new(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = 'Admin::Page was successfully created.'
        format.html { redirect_to(@page) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @page = Admin::Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Admin::Page was successfully updated.'
        format.html { redirect_to([@account, @page]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @page = Admin::Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(account_pages_url) }
      format.xml  { head :ok }
    end
  end
  
  def flag
    @comment = Comment.find(params[:id])    

    respond_to do |format|
      if @comment.flag
        flash[:notice] = 'Comment was flagged'
        format.html { redirect_to(account_comments_path) }
        format.js { head :ok } 
        format.xml  { head :ok }
      else
        flash[:notice] = "Comment wasn't flagged"
        format.html { redirect_to(account_comments_path) }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
    
  end
  
  def enable
    @comment = Comment.find(params[:id])    

    respond_to do |format|
      if @comment.enable
        flash[:notice] = 'Comment was flagged'
        format.html { redirect_to(account_comments_path) }
        format.js { head :ok } 
        format.xml  { head :ok }
      else
        flash[:notice] = "Comment wasn't flagged"
        format.html { redirect_to(account_comments_path) }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end  

  def disable
    @comment = Comment.find(params[:id])    
    
    respond_to do |format|
      if @comment.disable
        flash[:notice] = 'Comment was flagged'
        format.html { redirect_to(account_comments_path) }
        format.js { head :ok } 
        format.xml  { head :ok }
      else
        flash[:notice] = "Comment wasn't flagged"
        format.html { redirect_to(account_comments_path) }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end

  end
  
end
