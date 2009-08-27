module Liquid
  class Commentform < Tag
    Syntax = /(#{QuotedFragment}+)?/
  
    def initialize(tag_name, markup, tokens)      
      if markup =~ Syntax

        @widget_name = $1

      else
        raise SyntaxError.new("Error in tag 'commentform' - Valid syntax: commentform")
      end

      super
    end

  
    def parse(tokens)      
    end
  
    def render(context)      

      s = <<-end
        <form id="comment-form" method="post" action="/accounts/7/articles/19477/comments/">
        <textarea id="comment_body" name="comment[body]">test</textarea>
        <input type="hidden" id="comment_content_id" name="comment[content_id]" value="19477" />
        <input type="text" id="comment_name" name="comment[name]"/>
        <input type="submit" value="Send" />
      end


      
    end

  end
  Liquid::Template.register_tag('commentform', Commentform)  
end