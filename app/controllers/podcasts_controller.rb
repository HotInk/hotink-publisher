class PodcastsController < ApplicationController

  skip_before_filter :require_user, :only => :show
  
  def show
    @podcast = Podcast.find(params[:id])
    @entries = Entry.find(:all, :from => "/accounts/#{@account.account_resource_id.to_s}/blogs/#{@podcast.blog_id.to_s}/entries.xml", :as => @account.access_token)
    @entries = @entries[0].article.to_a
    @entries.reject! {|entry| 
      entry.audiofiles.empty?
    }
  end

end
