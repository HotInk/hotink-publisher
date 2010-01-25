module Liquid
  
  module CleanTruncateFilters
    
    def truncatewords(input, words = 15, truncate_string = "...")
      if input.nil? then return end
      wordlist = input.to_s.split
      l = words.to_i - 1
      l = 0 if l < 0
      truncated_string = wordlist.length > l ? wordlist[0..l].join(" ") + truncate_string : input 
      close_tags( truncated_string )
    end
    
    private
    
    def close_tags(text)
      open_tags = []
      text.scan(/\<([^\>\s\/]+)[^\>\/]*?\>/).each { |t| open_tags.unshift(t) }
      text.scan(/\<\/([^\>\s\/]+)[^\>]*?\>/).each { |t| open_tags.slice!(open_tags.index(t)) }
      open_tags.each {|t| text += "</#{t}>" }
      text
    end  
  end
  
  Template.register_filter Liquid::CleanTruncateFilters
end