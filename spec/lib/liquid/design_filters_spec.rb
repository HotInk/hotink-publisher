require 'spec_helper'

describe Liquid::DesignFilters do
  before do
    @account = Factory(:account, :name => "test-account")
    @design = Factory(:design, :account => @account)
    Account.stub!(:find).and_return(@account)
  end 
  
  describe "smart template file tag filter" do
    context "with a javascript file" do
      before do
        @template_file = Factory(:javascript_file, :design => @design)
      end
    
      it "should return an external script tag" do
        output = Liquid::Template.parse( " {{ \"#{@template_file.file_file_name}\" | template_file }} "  ).render({'pagination_info' => @pagination_info}, :registers => { :account => @account, :design => @design } )
        output.should == " <script src=\"#{@template_file.url}\" type=\"text/javascript\" charset=\"utf-8\"></script> "
      end
    end
    
    context "with an image" do
      before do
        @template_file = Factory(:template_file, :design => @design)
      end
    
      it "should return an image tag" do
        output = Liquid::Template.parse( " {{ \"#{@template_file.file_file_name}\" | template_file }} "  ).render({'pagination_info' => @pagination_info}, :registers => { :account => @account, :design => @design } )
        output.should == " <img src=\"#{@template_file.url}\" /> "
      end
    end
    
    context "with a stylesheet" do
      before do
        @template_file = Factory(:stylesheet, :design => @design)
      end
    
      it "should return an image tag" do
        output = Liquid::Template.parse( " {{ \"#{@template_file.file_file_name}\" | template_file }} "  ).render({'pagination_info' => @pagination_info}, :registers => { :account => @account, :design => @design } )
        output.should == " <link rel=\"stylesheet\" type=\"text/css\" media=\"all\" href=\"#{@template_file.url}\" /> "
      end
    end
    
    context "with a general file" do
      before do
        @template_file = Factory(:template_file, :file => File.new(RAILS_ROOT + "/spec/fixtures/sample.txt"), :design => @design)
      end
    
      it "should return a link" do
        output = Liquid::Template.parse( " {{ \"#{@template_file.file_file_name}\" | template_file }} "  ).render({'pagination_info' => @pagination_info}, :registers => { :account => @account, :design => @design } )
        output.should == " <a href=\"#{@template_file.url}\" name=\"#{@template_file.file_file_name}\">#{@template_file.file_file_name}</a> "
      end
    end    
  end
  
  describe "template file url" do
    context "with an actual template file name" do
      before do
        @template_file = Factory(:javascript_file, :design => @design)
      end
    
      it "should return the template file's relative url" do
        output = Liquid::Template.parse( " {{ \"#{@template_file.file_file_name}\" | template_file_url }} "  ).render({'pagination_info' => @pagination_info}, :registers => { :account => @account, :design => @design } )
        output.should == " #{@template_file.url} "
      end
    end
    
    context "with an baloney template file name" do
      it "should return an external script tag" do
        output = Liquid::Template.parse( " {{ \"baloney.txt\" | template_file_url }} "  ).render({'pagination_info' => @pagination_info}, :registers => { :account => @account, :design => @design } )
        output.should == "  "
      end
    end
  end
   
end
