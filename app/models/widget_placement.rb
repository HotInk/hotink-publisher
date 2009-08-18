class WidgetPlacement < ActiveRecord::Base
  belongs_to :widget
  belongs_to :template
  
end
