module Liquid
  class Commentform < ::Liquid::Block
    def self.article
      Thread.current[:comment_form_article]
    end
    
    def self.article=(value)
      Thread.current[:comment_form_article] = value
    end
  
    # Provides the required input, error, and form fields
    # TODO: make this more accessible to users (let them mess it up, rather than forcing a structure on them)
    def render(context)
      result = []
      context.stack do
        if context['message'].blank? 
          errors = context['errors'].blank? ? '' : %Q{<ul id="comment-errors"><li>#{context['errors'].join('</li><li>')}</li></ul>}

          submitted = context['submitted'] || {}
          submitted.each{ |k, v| submitted[k] = CGI::escapeHTML(v) }
          
          context['form'] = {
            'body'   => %(<textarea id="comment_body" name="comment[body]">#{submitted['body']}</textarea>),
             'name'   => %(<input type="text" id="comment_name" name="comment[name]" value="#{submitted['author']}" />),
             'email'  => %(<input type="text" id="comment_email" name="comment[email]" value="#{submitted['email']}" />),
             'url'    => %(<input type="text" id="comment_url" name="comment[url]" value="#{submitted['url']}" />),
             'captcha_answer'    => %(<input type="text" id="captcha_answer" name="captcha_answer" value="" />),            
             'submit' => %(<input type="submit" value="Submit" />)
          }
          
          result << %(<form id="comment-form" method="post" action="#{context.registers[:account].url}/articles/#{context['article'].id}/comments"><input name="authenticity_token" type="hidden" value="#{context.registers[:form_authenticity_token]}" /><input name="captcha_id" type="hidden" value="#{context.registers[:captcha_id]}" />#{[errors]+render_all(@nodelist, context)}</form>)
        else
          result << %(<p id="comment-message">#{context['message']}</p>)
        end
      end
      result
    end
  end
Liquid::Template.register_tag('commentform', Commentform)
end
