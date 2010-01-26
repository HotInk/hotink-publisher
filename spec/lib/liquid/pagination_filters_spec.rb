require 'spec_helper'

describe Liquid::PaginationFilters do
  context "when on the first page" do
    before do
      @pagination_info = { 'current_page' => 1, 'per_page' => 15, 'total_entries' => 40 }
    end
    
    it "should render pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | paginate }} '  ).render('pagination_info' => @pagination_info)
      output.should == " <div class=\"pagination\"><span class=\"current\">1</span><a href=\"?page=2\" rel=\"next\">2</a><a href=\"?page=2\" class=\"next_page\" rel=\"next\">Older &raquo;</a></div> "
    end

    it "should render short pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | short_paginate }} '  ).render('pagination_info' => @pagination_info)
      output.should == " <div class=\"pagination\"><a href=\"?page=2\" class=\"next_page\" rel=\"next\">Older &raquo;</a></div> "
    end
  end
  
  context "when on the third page" do
    before do
      @pagination_info = { 'current_page' => 3, 'per_page' => 15, 'total_entries' => 100 }
    end
    
    it "should render pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | paginate }} '  ).render('pagination_info' => @pagination_info)
      output.should == " <div class=\"pagination\"><a href=\"?page=2\" class=\"prev_page\" rel=\"prev\">&laquo; Newer</a><a href=\"?page=1\" rel=\"start\">1</a><a href=\"?page=2\" rel=\"prev\">2</a><span class=\"current\">3</span><a href=\"?page=4\" rel=\"next\">4</a><a href=\"?page=4\" class=\"next_page\" rel=\"next\">Older &raquo;</a></div> "
    end
    
    it "should render short pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | short_paginate }} '  ).render('pagination_info' => @pagination_info)
      output.should == " <div class=\"pagination\"><a href=\"?page=2\" class=\"prev_page\" rel=\"prev\">&laquo; Newer</a><a href=\"?page=4\" class=\"next_page\" rel=\"next\">Older &raquo;</a></div> "
    end
  end
  
  context "when on the fourth page" do
    before do
      @pagination_info = { 'current_page' => 4, 'per_page' => 15, 'total_entries' => 100 }
    end
    
    it "should render pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | paginate }} '  ).render('pagination_info' => @pagination_info)
      output.should == " <div class=\"pagination\"><a href=\"?page=3\" class=\"prev_page\" rel=\"prev\">&laquo; Newer</a><a href=\"?page=1\" rel=\"start\">1</a><a href=\"?page=2\">2</a><a href=\"?page=3\" rel=\"prev\">3</a><span class=\"current\">4</span><a href=\"?page=5\" rel=\"next\">5</a><a href=\"?page=5\" class=\"next_page\" rel=\"next\">Older &raquo;</a></div> "
    end
    
    it "should render short pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | short_paginate }} '  ).render('pagination_info' => @pagination_info)
      output.should == " <div class=\"pagination\"><a href=\"?page=3\" class=\"prev_page\" rel=\"prev\">&laquo; Newer</a><a href=\"?page=5\" class=\"next_page\" rel=\"next\">Older &raquo;</a></div> "
    end
  end
  
  context "when on the fifth page" do
    before do
      @pagination_info = { 'current_page' => 5, 'per_page' => 15, 'total_entries' => 100 }
    end
    
    it "should render pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | paginate }} '  ).render('pagination_info' => @pagination_info)
      output.should == " <div class=\"pagination\"><a href=\"?page=4\" class=\"prev_page\" rel=\"prev\">&laquo; Newer</a><a href=\"?page=1\" rel=\"start\">1</a><a href=\"?page=2\">2</a><a href=\"?page=3\">3</a><a href=\"?page=4\" rel=\"prev\">4</a><span class=\"current\">5</span><a href=\"?page=6\" rel=\"next\">6</a><a href=\"?page=6\" class=\"next_page\" rel=\"next\">Older &raquo;</a></div> "
    end
    
    it "should render short pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | short_paginate }} '  ).render('pagination_info' => @pagination_info)
      output.should == " <div class=\"pagination\"><a href=\"?page=4\" class=\"prev_page\" rel=\"prev\">&laquo; Newer</a><a href=\"?page=6\" class=\"next_page\" rel=\"next\">Older &raquo;</a></div> "
    end
    
    it "should render keyword search pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | search_paginate }} '  ).render({'pagination_info' => @pagination_info}, :registers => { :query => "test query" })
      output.should == " <div class=\"pagination\"><a href=\"?q=test+query&page=4\" class=\"prev_page\" rel=\"prev\">&laquo; Previous</a><a href=\"?q=test+query&page=6\" class=\"next_page\" rel=\"next\">Next &raquo;</a></div> "
    end
    
    it "should render tag search pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | search_paginate }} '  ).render({'pagination_info' => @pagination_info}, :registers => { :tagged_with => "test tags" })
      output.should == " <div class=\"pagination\"><a href=\"?tagged_with=test+tags&page=4\" class=\"prev_page\" rel=\"prev\">&laquo; Previous</a><a href=\"?tagged_with=test+tags&page=6\" class=\"next_page\" rel=\"next\">Next &raquo;</a></div> "
    end
  end
  
  context "when on the sixth page" do
    before do
      @pagination_info = { 'current_page' => 6, 'per_page' => 20, 'total_entries' => 140 }
    end
    
    it "should render pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | paginate }} '  ).render('pagination_info' => @pagination_info)
      output.should == " <div class=\"pagination\"><a href=\"?page=5\" class=\"prev_page\" rel=\"prev\">&laquo; Newer</a><a href=\"?page=1\" rel=\"start\">1</a><a href=\"?page=2\">2</a><span class=\"gap\">&hellip;</span><a href=\"?page=5\" rel=\"prev\">5</a><span class=\"current\">6</span><a href=\"?page=7\" rel=\"next\">7</a><a href=\"?page=7\" class=\"next_page\" rel=\"next\">Older &raquo;</a></div> "
    end
    
    it "should render short pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | short_paginate }} '  ).render('pagination_info' => @pagination_info)
      output.should == " <div class=\"pagination\"><a href=\"?page=5\" class=\"prev_page\" rel=\"prev\">&laquo; Newer</a><a href=\"?page=7\" class=\"next_page\" rel=\"next\">Older &raquo;</a></div> "
    end
    
    it "should render keyword search pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | search_paginate }} '  ).render({'pagination_info' => @pagination_info}, :registers => { :query => "test query" })
      output.should == " <div class=\"pagination\"><a href=\"?q=test+query&page=5\" class=\"prev_page\" rel=\"prev\">&laquo; Previous</a><a href=\"?q=test+query&page=7\" class=\"next_page\" rel=\"next\">Next &raquo;</a></div> "
    end
    
    it "should render tag search pagination links" do
      output = Liquid::Template.parse( ' {{ pagination_info | search_paginate }} '  ).render({'pagination_info' => @pagination_info}, :registers => { :tagged_with => "test tags" })
      output.should == " <div class=\"pagination\"><a href=\"?tagged_with=test+tags&page=5\" class=\"prev_page\" rel=\"prev\">&laquo; Previous</a><a href=\"?tagged_with=test+tags&page=7\" class=\"next_page\" rel=\"next\">Next &raquo;</a></div> "
    end
  end
  
  describe "page start count" do
    it "should return the position of this page's first record" do
      @pagination_info = { 'current_page' => 6, 'per_page' => 20, 'total_entries' => 140 }
      output = Liquid::Template.parse( ' {{ pagination_info | page_start_count }} '  ).render({'pagination_info' => @pagination_info})
      output.should == " 101 "
      
      @pagination_info = { 'current_page' => 6, 'per_page' => 10, 'total_entries' => 55 }
      output = Liquid::Template.parse( ' {{ pagination_info | page_start_count }} '  ).render({'pagination_info' => @pagination_info})
      output.should == " 51 "
    end
  end
  
  describe "page end count" do
    it "should return the position of this page's last record" do
      @pagination_info = { 'current_page' => 6, 'per_page' => 20, 'total_entries' => 140 }
      output = Liquid::Template.parse( ' {{ pagination_info | page_end_count }} '  ).render({'pagination_info' => @pagination_info})
      output.should == " 120 "
      
      @pagination_info = { 'current_page' => 6, 'per_page' => 10, 'total_entries' => 55 }
      output = Liquid::Template.parse( ' {{ pagination_info | page_end_count }} '  ).render({'pagination_info' => @pagination_info})
      output.should == " 55 "
    end
  end
  
  describe "page info" do
    it "should return the position of this page's last record" do
      @pagination_info = { 'current_page' => 1, 'per_page' => 20, 'total_entries' => 15 }
      output = Liquid::Template.parse( ' {{ pagination_info | page_info  }} '  ).render({'pagination_info' => @pagination_info})
      output.should == " 15 items "
      
      @pagination_info = { 'current_page' => 6, 'per_page' => 10, 'total_entries' => 95 }
      output = Liquid::Template.parse( ' {{ pagination_info | page_info }} '  ).render({'pagination_info' => @pagination_info})
      output.should == " 51&nbsp;–&nbsp;60 of 95 items "
    end
  end
end
