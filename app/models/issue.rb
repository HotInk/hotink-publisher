class Issue < ActiveResource::Base

  self.site = HI_CONFIG["site"]
  self.user = HI_CONFIG["user"]
  self.password = HI_CONFIG["password"]
  self.prefix = "/accounts/:account_id/"

  def to_liquid
    {'date' => date, 'description' => description, 'name' => name, 'number' => number, 'volume' => volume, 'pdf-file-name' => pdf_file_name}
  end

end
