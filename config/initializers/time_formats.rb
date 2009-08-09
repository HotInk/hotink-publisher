{ :short_date  => "%x",              # 04/13/10
  :long_date   => "%A, %b. %e, %Y"   # Tue, Apr 13, 2010
}.each do |k, v|
  ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.update(k => v)
end

Time::DATE_FORMATS[:time] = "%l:%M %p"

Time::DATE_FORMATS[:standard] = lambda do |date|
    if Time.zone.now <= date
      Time.zone.now.end_of_day >= date ? "#{date.strftime('%l').to_i}:#{date.strftime('%M')} #{date.strftime('%p').downcase}" : 
      Time.zone.now.end_of_year >= date ? "#{date.strftime('%b')} #{date.day}" : "#{date.month}/#{date.day}/#{date.strftime('%y')}"
    else
      Time.zone.now.beginning_of_day <= date ? "#{date.strftime('%l').to_i}:#{date.strftime('%M')} #{date.strftime('%p').downcase}" : 
      Time.zone.now.beginning_of_year <= date ? "#{date.strftime('%b')} #{date.day}" : "#{date.month}/#{date.day}/#{date.strftime('%y')}"
    end
end


ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :standard_date_only => lambda do |date| 
    if Time.zone.now <= date
      Time.zone.now.end_of_year >= date ? "#{date.strftime('%b')} #{date.day}" : "#{date.month}/#{date.day}/#{date.strftime('%y')}"
    else
      Time.zone.now.beginning_of_year <= date ? "#{date.strftime('%b')} #{date.day}" : "#{date.month}/#{date.day}/#{date.strftime('%y')}"
    end
  end
)

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
  :standard => lambda { |date| Time.zone.now.beginning_of_day <= date ? 
    "#{date.strftime('%l').to_i}:#{date.strftime('%M')} #{date.strftime('%p').downcase}" : 
    (Time.zone.now.beginning_of_year <= date ? "#{date.strftime('%b')} #{date.day}" : 
    "#{date.month}/#{date.day}/#{date.strftime('%y')}") 
  }
)
