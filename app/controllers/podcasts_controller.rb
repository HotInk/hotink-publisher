class PodcastsController < ApplicationController

  skip_before_filter :require_user, :only => :show
  
  def show
    @podcast = Podcast.find(params[:id])
    @entries = Entry.find(:all, :from => "/accounts/#{@account.account_resource_id}/entries.xml", :params => { :blog_id => @podcast.blog_id })
    @entries = @entries[0].article.to_a
    @entries.reject! {|entry| 
      entry.audiofiles.empty?
    }
  end

end
