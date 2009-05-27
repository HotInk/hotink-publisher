class ThemesController < ApplicationController

  layout 'default'

  def index
    @themes = Theme.find_all
        
  end

end
