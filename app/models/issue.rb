class Issue < HyperactiveResource

  has_many :article
  belongs_to :account, :nested => true

  self.site = HOTINK_SETTINGS.site
  self.user = HOTINK_SETTINGS.user
  self.password = HOTINK_SETTINGS.password
  self.prefix = "/accounts/:account_id/"

  def to_liquid
    {   'date' => self.date,
        'description' => self.description,
        'name' => self.name, 
        'number' => self.number, 
        'volume' => self.volume, 
        'press_pdf_url' => self.press_pdf_file, 
        'screen_pdf_url' => self.screen_pdf_file, 
        'large_cover_image' => self.large_cover_image,
        'small_cover_image' => self.small_cover_image,
        'id' => self.id,
        'account_id' => self.account_id
    }
  end

end
