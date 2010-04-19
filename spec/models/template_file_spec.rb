require 'spec_helper'

describe TemplateFile do
  before do
    @account = Factory(:account)
    @template_file = Factory(:template_file, :design => Factory(:design, :account => Factory(:account, :name => "test-account")))
  end
  
  it { should belong_to(:design) }
  it { should validate_presence_of(:design) }
  
  describe "file attributes" do
    it "should know its file's url" do
      @template_file.url.should == @template_file.file.url
    end
    
    it "should know its file's name" do
      @template_file.file_name.should == @template_file.file_file_name
    end
    
    it "should know its file's size" do
      @template_file.file_size.should_not be_nil
      @template_file.file_size.should_not == "0"      
      @template_file.file_size.should == @template_file.file_file_size
    end
  end
end
