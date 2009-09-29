xml.instruct!
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title @feed_title
    xml.link @feed_url
    xml.description @feed_description
    xml.language "en-gb"

    for article in @articles
      xml.item do
        xml.pubDate Time.parse(article.published_at).rfc822
        xml.title h(article.title)
        xml.link "http://" + request.host_with_port + "/articles/#{article.id}"
        xml.guid "http://" + request.host_with_port + "/articles/#{article.id}"
        xml.description do
          if article.authors_list
            xml << "<p><strong>#{article.authors_list}</strong></p>"
          end
          if article.attributes['section']
            xml << "<p><strong>#{article.attributes['section']}</strong></p>"
          end
          xml << markdown(article.bodytext)
        end
      end
    end
  end
end
