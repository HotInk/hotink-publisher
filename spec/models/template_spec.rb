require 'spec_helper'

describe Template do
  
  it { should belong_to(:design) }
  it { should validate_presence_of(:design) }
  
end
