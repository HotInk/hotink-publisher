class Liquid::NewspaperDrop < Liquid::BaseDrop
  
  def initialize(account, options = {})
    @account = account
  end

  def sections
    @account.sections.collect{|s| s.name}
  end
  
end