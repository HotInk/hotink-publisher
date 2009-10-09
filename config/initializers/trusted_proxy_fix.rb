# This is a fix for to prevent resuest.remote_ip from returning the squid proxy IP
# instead of the user's actual ip. This is not for security, but for comment spam 
# reporting to Askimet
# 
# This has been fixed for Rails 2.3.5 (http://github.com/rails/rails/commit/654568e71b1ee36a04acef74b1a8ce4737050882)
# we're simply awaiting its release with this fix.

ActionController::AbstractRequest.const_set("TRUSTED_PROXIES", /^72\.2\.4\.176$|^127\.0\.0\.1$|^(10|172\.(1[6-9]|2[0-9]|30|31)|192\.168)\./i)