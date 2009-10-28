# Template file interpolations

Paperclip.interpolates :account do |attachment, style|
  attachment.instance.design.account.name
end

Paperclip.interpolates :design do |attachment, style|
  attachment.instance.design.id
end

Paperclip.interpolates :version do |attachement, style|  
     attachement.instance.version.to_s  
end

# Webthumb api handler
include Simplificator::Webthumb
