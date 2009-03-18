# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_newapp_session',
  :secret      => 'a975648893d48def49d8ba363bd2037b9ccf3eaefb209d54e8141ff20acededbb7f9d4025f37ee70e50e149ad0b7fc48a694d9381f6cd9dd28348306bc41a33e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
