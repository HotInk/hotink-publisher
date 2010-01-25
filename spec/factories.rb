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
  a.summary                ""
  a.mediafiles             []
  a.tags                   []
  a.authors                []
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

## Mediafiles

Factory.define :mediafile, :default_strategy => :build do |m|
  m.sequence(:title)      { |n| "Mediafile ##{n}" }
  m.sequence(:caption)    { |n| "A caption for Mediafile ##{n}." }
  m.mediafile_type        "Mediafile"
  m.sequence(:date)       { |n| n.days.ago.utc.to_s }
  m.sequence(:id)         { |n| n.to_i }
  m.authors_list           "Author #1, Author #2 and Author #3"
  m.sequence(:url)        { |n| "/mediafile_url/#{n}.txt" }
  m.original_file_size    "667 KB"
  m.content_type          "text/plain"
end

Factory.define :image, :default_strategy => :build, :parent => :mediafile do |i|
  i.mediafile_type      "Image"
  i.content_type        "image/jpeg"
  i.url                 { Factory(:image_url) }
  i.height              "683"
  i.width               "1024"
end

Factory.define :vertical_image, :default_strategy => :build, :parent => :image do |i|
  i.height              "1024"
  i.width               "800"
end

Factory.define :horizontal_image, :default_strategy => :build, :parent => :image do |i|
  i.height              "800"
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

Factory.define :audiofile, :default_strategy => :build, :parent => :mediafile do |a|
  a.mediafile_type      "Audiofile"
  a.content_type        "audio/mpeg"
  a.sequence(:url)      { |n| "/mediafile_url/#{n}.mp3" }
end

##

Factory.define :tag, :default_strategy => :build do |t|
  t.sequence(:name)       { |n| "Tag ##{n}"}
  t.sequence(:id)         { |n| n.to_i }
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

Factory.define :section, :default_strategy => :build do |s|
  s.sequence(:name) { |n| "Section \##{n}" }
  s.sequence(:position) { |n| n }
  s.sequence(:id) { |n| n }
  s.children []
end

Factory.define :section_with_subcategories, :default_strategy => :build, :parent => :section do |s|
  s.children { |p| (1..3).collect { Factory(:section, :parent_id => p.attributes[:id]) } }
end

Factory.define :author, :default_strategy => :build do |a|
  a.sequence(:name) { |n| "Author ##{n}" }
end

Factory.define :account do |a|
  a.sequence(:name) { |n| "Account \##{n}" }
  a.time_zone "What time?"
end

Factory.define :podcast do |p|
  p.account { Factory(:account) }
end

## Templates

Factory.define :template do |t|
  t.design { Factory(:design) }
  t.sequence(:code) { |n| "Template ##{n}" }
end

Factory.define :layout, :parent => :template, :class => 'Layout' do |l|
  l.sequence(:code) { |n| "Layout ##{n} \n{{ page_contents }}" }
end

Factory.define :page_template, :parent => :template, :class => 'PageTemplate' do |p|
  p.sequence(:code) { |n| "Page Template ##{n}" }
end

Factory.define :partial_template, :parent => :template, :class => 'PartialTemplate' do |p|
  p.sequence(:code) { |n| "Partial Template ##{n}" }
end

Factory.define :widget_template, :parent => :template, :class => 'WidgetTemplate' do |p|
  p.sequence(:code) { |n| "Widget Template ##{n}" }
  p.schema [{ 'name' => 'lead_articles', 'model' => 'Article', 'quantity' => "2", 'description' => "" }]
end

Factory.define :front_page_template, :parent => :template, :class => 'FrontPageTemplate' do |f|
  f.sequence(:code) { |n| "Front page template ##{n}" }
  f.schema [{ 'name' => 'lead_articles', 'model' => 'Article', 'quantity' => "2", 'description' => "" }]
end

##

Factory.define :widget do |w|
  w.sequence(:name) { |n| "Widget ##{n}" }
  w.design { |v| Factory(:design) }
  w.template { |v| Factory(:widget_template, :design => v.design) }
end

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

Factory.define :redesign do |f|
  f.account   { Factory(:account) }
  f.design { |g| Factory(:design, :account => g.account) }
end

Factory.define :comment do |c|
  c.sequence(:email) { |n| "email#{n}@address.com"  }
  c.sequence(:name) { |n| "Commenter ##{n}" }
  c.body "This is what I say!"
  c.account { Factory(:account) }
end

Factory.define :page do |p|
  p.sequence(:name) { |n| "Page ##{n}" }
  p.account { Factory(:account) }
  p.bodytext "Page page bodytext"
end

Factory.define :template_file do |t|
  t.design  { Factory(:design) }
  t.file  { File.new(RAILS_ROOT + '/spec/fixtures/hotink.gif') }
end

Factory.define :javascript_file do |t|
  t.design  { Factory(:design) }
  t.file  { File.new(RAILS_ROOT + '/spec/fixtures/sample.js') }
end

Factory.define :stylesheet do |t|
  t.design  { Factory(:design) }
  t.file  { File.new(RAILS_ROOT + '/spec/fixtures/sample.css') }
end

Factory.define :account do |a|
  a.sequence(:account_resource_id) { |n| n }
end