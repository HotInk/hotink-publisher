require 'spec_helper'

describe Account do
  it { should validate_presence_of(:account_resource_id) }
end
