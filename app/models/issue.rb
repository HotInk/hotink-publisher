class Issue < ActiveResource::Base

  # TODO: make this a configuration option
  self.site = "http://demo.hotink.net"
  self.prefix = "/accounts/:account_id/"
  self.user = "hyfen"
  self.password = "blah123"

  def to_liquid
    {'date' => date, 'description' => description, 'name' => name, 'number' => number, 'volume' => volume, 'pdf-file-name' => pdf_file_name}
  end

end
