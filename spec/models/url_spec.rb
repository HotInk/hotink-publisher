require 'spec_helper'

describe Url do

  it "should create a liquid representation of itself" do
    url = Factory(:image_url)
    url.to_liquid.should == {   'original' => url.original, 
                                'thumb'  => url.thumb,
                                'small' => url.small, 
                                'medium' => url.medium, 
                                'large' => url.large, 
                                'system_default' => url.system_default,
                                'system_thumb' => url.system_thumb, 
                                'system_icon' => url.system_icon
                                }
  end
end
