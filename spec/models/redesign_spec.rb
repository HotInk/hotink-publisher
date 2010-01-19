require 'spec_helper'

describe Redesign do
  it { should belong_to(:account) }
  it { should validate_presence_of(:account) }
  
  it { should belong_to(:design) }
  it { should validate_presence_of(:design) }
end
