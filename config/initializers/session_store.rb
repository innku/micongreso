# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_diputado_session',
  :secret      => '32f881a5167e5cd6f420119042623140eeee869e70e3578b1af314af20eb6ff42c6b6a66e042796b4a2a2eac04d7f0640414c6d6cc05173d068f91b6dd01e1ce'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
