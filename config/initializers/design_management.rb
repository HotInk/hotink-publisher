# Template file interpolations

Paperclip.interpolates :account do |attachment, style|
  attachment.instance.design.account.name
end

Paperclip.interpolates :design do |attachment, style|
  attachment.instance.design.id
end