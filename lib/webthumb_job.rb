class WebthumbJob < Struct.new(:front_page_id)
  def perform
    FrontPage.find(self.front_page_id).perform
  end
end