require 'spec_helper'

describe Liquid::MediafileDrop do

  describe "mediafile" do
    before do
      @mediafile = Factory(:mediafile)
      @mediafile_drop = Liquid::MediafileDrop.new(@mediafile)
    end
    
    it "should make basic attributes available" do
      output = Liquid::Template.parse( ' {{ mediafile.id }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@mediafile))
      output.should == " #{@mediafile.id} "
      
      output = Liquid::Template.parse( ' {{ mediafile.title }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@mediafile))
      output.should == " #{@mediafile.title} "
      
      output = Liquid::Template.parse( ' {{ mediafile.caption }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@mediafile))
      output.should == " #{@mediafile.caption} "
      
      output = Liquid::Template.parse( ' {{ mediafile.mediafile_type }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@mediafile))
      output.should == " #{@mediafile.mediafile_type} "
      
      output = Liquid::Template.parse( ' {{ mediafile.authors_list }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@mediafile))
      output.should == " #{@mediafile.authors_list} "
    end
  
    it "should make the mediafile 'file' url available" do
      output = Liquid::Template.parse( ' {{ mediafile.url }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@mediafile))
      output.should == " #{@mediafile.url} "
    end
  end
  
  describe "image" do
     before do
       @image = Factory(:image)
       @mediafile_drop = Liquid::MediafileDrop.new(@image)
     end
     
     it "should return information about the image dimensions" do
       output = Liquid::Template.parse( ' {% if mediafile.is_vertical? %}is vertical{% else %}is horizontal{% endif %} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.height.to_i>@image.width.to_i ? "is vertical" : "is horizontal" } "
       
       output = Liquid::Template.parse( ' {% if mediafile.is_horizontal? %}is horizontal{% else %}is vertical{% endif %} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.height.to_i>@image.width.to_i ? "is vertical" : "is horizontal" } "
       
       output = Liquid::Template.parse( ' {{ mediafile.height }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.height } "
       
       output = Liquid::Template.parse( ' {{ mediafile.width }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.width } "
     end
     
     it "should know the various image size urls" do
       output = Liquid::Template.parse( ' {{ mediafile.url }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.url.original } "
       
       output = Liquid::Template.parse( ' {{ mediafile.original_url }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.url.original } "
       
       output = Liquid::Template.parse( ' {{ mediafile.image_url_thumb }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.url.thumb } "
       
       output = Liquid::Template.parse( ' {{ mediafile.image_url_small }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.url.small } "
       
       output = Liquid::Template.parse( ' {{ mediafile.image_url_medium }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.url.medium } "
       
       output = Liquid::Template.parse( ' {{ mediafile.image_url_large }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.url.large } "
       
       output = Liquid::Template.parse( ' {{ mediafile.image_url_system_default }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.url.system_default } "
       
       output = Liquid::Template.parse( ' {{ mediafile.image_url_system_thumb }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.url.system_thumb } "
       
       output = Liquid::Template.parse( ' {{ mediafile.image_url_system_icon }} '  ).render('mediafile' => Liquid::MediafileDrop.new(@image))
       output.should == " #{ @image.url.system_icon } "
     end
  end
end
