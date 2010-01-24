require 'spec_helper'

describe Podcast do
  it { should belong_to(:account) }
  it { should validate_presence_of(:account) }
end
