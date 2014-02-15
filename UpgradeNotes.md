# Rails 4 Upgrade Notes/Steps
* Kill the vendor directory.  Should be totally safe.
* delete Gemfile.lock
* update the gems in the gem file AND update rails to 4.0.0
* Add a config.secret_key with a LONG hex guid
  * You might want to do this after you attempt...and FAIL...to start the app
*  remove 'config.whiny_nils' from all environment files
* follow this config.eager_load pattern:
  * config.eager_load is set to nil. Please update your config/environments/*.rb files accordingly:
  * development - set it to false
  * test - set it to false (unless you use a tool that preloads your test environment)
  * production - set it to true
* As a quick fix, add the "protected_attributes" gem to the GEM file.  There's a new way to do this now.
* Pull the gems from the 'assets' group into the standard gem list
* Updated gem file to use rails 4.0.2
* Had to delete the Gemfile.lock again :cry:
* `config.active_record.auto_explain_threshold_in_seconds` needed to be commented out.
* Using new routing style.
* Upgraded bootstrap to 3
* `config.assets.initialize_on_precompile = true` now, but Heroku may not like this.
* `rake rails:update:bin` to create a special bin folder that Heroku needs

* Upgrade Complete, but should have happened *BEFORE* additional changes took place.
* General lesson learned: When in doubt, delete Gemfile.lock and bunle again. :grin: