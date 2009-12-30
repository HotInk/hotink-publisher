Factory.define :article, :default_strategy => :build do |a|
  a.sequence(:id)          { |n| n.to_i }
  a.title                  { Factory.next(:article_title) }
  a.subtitle               "Get a detailed look (subtitle)"
  a.authors_list           "Author #1, Author #2 and Author #3"
  a.bodytext               "Wow. I **cannot** believe *the truth*."
  a.status                 "Published"
  a.published_at           Time.now.to_s(:db)
  a.updated_at             Time.now.to_s(:db)
  a.sequence(:account_id)  {|n| n.to_i }
  a.sequence(:account_name)  {|n| "Account ##{n}" }
end

Factory.define :entry, :default_strategy => :build do |e|
  e.sequence(:id)           { |n| n.to_i }
  e.title                   { Factory.next(:article_title) }
  e.subtitle                "Get a detailed look (subtitle)"
  e.authors_list            "Author #1, Author #2 and Author #3"
  e.bodytext                "Wow. I **cannot** believe *the truth*."
  e.status                  "Published"
  e.published_at            Time.now.to_s(:db)
  e.updated_at              Time.now.to_s(:db)
  e.sequence(:account_id)   {|n| n.to_i }
  e.sequence(:account_name) {|n| "Account ##{n}" }
  e.blogs                   { [ Factory(:blog) ] }
end

Factory.define :mediafile, :default_strategy => :build do |m|
  m.sequence(:title)      { |n| "Mediafile ##{n}" }
  m.sequence(:caption)    { |n| "A caption for Mediafile ##{n}." }
  m.mediafile_type        "Mediafile"
  m.sequence(:date)       { |n| n.days.ago.utc.to_s }
  m.sequence(:id)         { |n| n.to_i }
  m.authors_list           "Author #1, Author #2 and Author #3"
  m.sequence(:url)        { |n| "/mediafile_url/#{n}.txt" }
  m.content_type          "text/plain"
end

Factory.define :image, :default_strategy => :build, :parent => :mediafile do |i|
  i.mediafile_type      "Image"
  i.content_type        "image/jpeg"
  i.url                 { Factory(:image_url) }
  i.height              "683"
  i.width               "1024"
end

Factory.define :image_url, :class => 'Url', :default_strategy => :build do |i|
  i.original "/mediafile_url/image/original.jpg"
  i.thumb "/mediafile_url/image/thumb.jpg"
  i.small "/mediafile_url/image/small.jpg"
  i.medium "/mediafile_url/image/medium.jpg"
  i.large "/mediafile_url/image/large.jpg"
  i.system_default "/mediafile_url/image/system_default.jpg"
  i.system_thumb "/mediafile_url/image/system_thumb.jpg"
  i.system_icon "/mediafile_url/image/system_icon.jpg"
end

Factory.define :blog, :default_strategy => :build do |b|
  b.sequence(:id) { |n| n }
  b.sequence(:title) { |n|  "Blog title ##{n}"  }
  b.sequence(:description) { |n|  "A description of Blog ##{n}"  }  
  b.sequence(:updated_at) { |n| n.hours.ago }
end

Factory.define :issue, :default_strategy => :build do |i|
  i.sequence(:id)                 { |n| n.to_i }
  i.sequence(:date)               { |n| n.days.ago.utc.to_s }
  i.sequence(:account_id)         { |n| n.to_i }
  i.sequence(:account_name)       { |n| "Account ##{n}" }
  i.sequence(:name)               { |n|  "Issue ##{n} name"  }
  i.sequence(:description)        { |n|  "A description of Issue ##{n}."  }
  i.volume                        "101"
  i.sequence(:number)             { |n| (30 + n).to_s }
  i.sequence(:press_pdf_file)     { |n|  "/issue/press_pdf_file/#{n}.pdf" }
  i.sequence(:screen_pdf_file)    { |n|  "/issue/screen_pdf_file/#{n}.pdf" }
  i.sequence(:large_cover_image)  { |n|  "/issue/large_cover_image/#{n}.jpg" }
  i.sequence(:small_cover_image)  { |n|  "/issue/small_cover_image/#{n}.jpg" }
end

Factory.define :issue_without_pdf, :default_strategy => :build, :parent => :issue do |i|
  i.press_pdf_file      "/images/no_issue_cover_small.jpg"
  i.screen_pdf_file    "/images/no_issue_cover_small.jpg"
  i.large_cover_image  "/images/no_issue_cover_small.jpg"
  i.small_cover_image  "/images/no_issue_cover_small.jpg"
end

Factory.sequence :article_title do |n|
  "The truth about \##{n}"
end

Factory.define :author do |a|
  a.sequence(:name) { |n| "Author ##{n}" }
  #a.account { Factory(:account) }
end

Factory.define :account do |a|
  a.sequence(:name) { |n| "Account \##{n}" }
  a.time_zone "What time?"
end

## Templates

Factory.define :template do |t|
  t.design { Factory(:design) }
  t.sequence(:code) { |n| "Template ##{n}" }
  t.sequence(:parsed_code) { |n| Liquid::Template.parse("Template ##{n}") }
end

Factory.define :page_template, :parent => :template, :class => 'PageTemplate' do |p|
  p.sequence(:code) { |n| "Page Template ##{n}" }
  p.sequence(:parsed_code) { |n| Liquid::Template.parse("Page Template ##{n}") }
end

Factory.define :layout, :parent => :template, :class => 'Layout' do |l|
  l.sequence(:code) { |n| "Layout ##{n} \n{{ page_contents }}" }
  l.sequence(:parsed_code) { |n| Liquid::Template.parse("Layout ##{n} \n{{ page_contents }}") }
end

Factory.define :front_page_template, :parent => :template, :class => 'FrontPageTemplate' do |f|
  f.sequence(:code) { |n| "Front page template ##{n}" }
  f.sequence(:parsed_code) { |n| Liquid::Template.parse("Front page template ##{n}") }
end
##

Factory.define :design do |d|
  d.account { Factory(:account) }
  d.sequence(:name) { |n| "Design ##{n}" }
end

Factory.define :front_page do |f|
  f.template  { Factory(:front_page_template) }
  f.account   { Factory(:account) }
end

Factory.define :press_run do |f|
  f.account   { Factory(:account) }
  f.front_page { |g| Factory(:front_page, :account => g.account) }
end

Factory.define :account do |a|
  a.sequence(:account_resource_id) { |n| n }
end