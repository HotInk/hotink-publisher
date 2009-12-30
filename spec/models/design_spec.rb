require 'spec_helper'

describe Design do

  subject { Factory(:design) }
  
  it { should belong_to(:account) }
  it { should validate_presence_of(:account) }

  it { should belong_to(:default_layout) }
  
  it { should validate_presence_of(:name) }
  
end
