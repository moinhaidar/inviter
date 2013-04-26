# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_inviter_session_id',
  :secret      => 'fc580caf72a0ef64c6bb7b47ae6975e344a81872329f48f5438c702836d69dbd7ede658475e3798a676aa3fc29c44e6b2a0218f5c3db4b3e07d93964a91f9074'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
