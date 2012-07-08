# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_opw_session',
  :secret      => '0ce636d8a1ad1fefa4ed7bee2d8daf89f1be5dc317f20f8fdf6d2a182ff86768d495a88a17b6aab9b5fb6fcbd24e78ce6501b1087f5bbdfc90c3a72bd30def9a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
