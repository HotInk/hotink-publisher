gem 'sinatra', '~>0.9.2'
require 'sinatra/base'

gem 'ruby-openid', '>=2.1.6'
require 'openid'
require 'openid/store/filesystem'

gem 'rack-openid', '>=0.2'
require 'rack/openid'

require 'tmpdir'

require File.dirname(__FILE__)+'/keymaster/helpers/rack'
require File.dirname(__FILE__)+'/keymaster/default'
require File.dirname(__FILE__)+'/keymaster/sso'
require File.dirname(__FILE__)+'/keymaster/middleware'