class Url < ActiveResource::Base
  self.site = HOTINK_SETTINGS[:site]
  self.prefix = "/accounts/:account_id/"
  
  def to_liquid
    {   'original' => original, 
        'thumb'  => thumb,
        'small' => small, 
        'medium' => medium, 
        'large' => large, 
        'system_default' => system_default,
        'system_thumb' => system_thumb, 
        'system_icon' => system_icon
    }
  end
end
