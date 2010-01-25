require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper
  it "should build a hash by record id, if necessary" do
    articles = Array.new
    articles[0] = Factory(:article, :id => "77")
    articles[1] = Factory(:article, :id => "1")
    articles[2] = Factory(:article, :id => "24877")
    
    hash_by_id(articles).should == {"77" => articles[0], "1" => articles[1], "24877" => articles[2] }
  end
end
