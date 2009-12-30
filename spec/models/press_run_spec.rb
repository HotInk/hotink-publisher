require 'spec_helper'

describe PressRun do
  
  it { should belong_to(:account) }
  it { should validate_presence_of(:account) }
  
  it { should belong_to(:front_page) }
  it { should validate_presence_of(:front_page) }
  
end
