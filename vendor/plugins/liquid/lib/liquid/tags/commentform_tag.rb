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

      
      # s = <<-end
      #   <form id="comment-form" method="post" action="/accounts/#{context.registers[:account].id}/articles/#{context.registers[:article].id}/comments/">
      #   <input name="authenticity_token" type="hidden" value="#{context.registers[:form_authenticity_token]}" />
      #   <input type="hidden" id="comment_content_id" name="comment[content_id]" value="#{context.registers[:article].id" />
      #   
      #   <label for="comment_body">Comment:</label><br />
      #   <textarea rows="10" cols="40"  id="comment_body" name="comment[body]"></textarea><br />
      #   
      #   <label for="comment_name">Your name:</label><br />
      #   <input type="text" id="comment_name" name="comment[name]"/><br />
      #   
      #   <label for="comment_email">Your email:</label><br />
      #   <input type="text" id="comment_email" name="comment[email]"/><br />
      #   
      #   <label for="comment_url">Your url:</label><br />
      #   <input type="text" id="comment_url" name="comment[url]"/><br />
      #   
      #   <input type="submit" value="Post" />
      # end
      
      return s
      
    end

  end
  Liquid::Template.register_tag('commentform', Commentform)  
end