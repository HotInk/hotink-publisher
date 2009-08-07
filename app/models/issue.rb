class Issue < HyperactiveResource

  has_many :article

  self.site = HOTINK_SETTINGS.site
  self.user = HOTINK_SETTINGS.user
  self.password = HOTINK_SETTINGS.password
  self.prefix = "/accounts/:account_id/"

  def to_liquid
    {'date' => date, 'description' => description, 'name' => name, 'number' => number, 'volume' => volume, 'pdf-file-name' => pdf_file_name}
  end

end
