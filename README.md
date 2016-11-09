Railscaptcha
================

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

Rails Composer is supported by developers who purchase our RailsApps tutorials.

Problems? Issues?
-----------

Need help? Ask on Stack Overflow with the tag 'railsapps.'

Your application contains diagnostics in the README file. Please provide a copy of the README file when reporting any issues.

If the application doesn't work as expected, please [report an issue](https://github.com/RailsApps/rails_apps_composer/issues)
and include the diagnostics.

Ruby on Rails
-------------

This application requires:

- Ruby 2.2.3
- Rails 5.0.0.1

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Getting Started
---------------

Production Configuration
---
On Heroku:
    heroku config set ADMIN_NAME='Jonathan Siegel' -a railscaptcha
    heroku config:set ADMIN_NAME='Jonathan Siegel' -a railscaptcha
    heroku config:set ADMIN_EMAIL='jonathan@siegel.io' -a railscaptcha
    heroku config:set ADMIN_PASSWORD='changem123' -a railscaptcha
    heroku config:set DOMAIN_NAME='app.ringcaptcha.com' -a railscaptcha
    heroku config:set SECRET_KEY_BASE="`rake secret`" -a railscaptcha
    heroku domains:add app.ringcaptcha.com -a railscaptcha
    heroku addons:add SENDGRID:BASIC -a railscaptcha
    heroku addons:add POSTGRES:BASIC -a railscaptcha
    heroku run rails db:migrate -a railscaptcha
    heroku run rails db:seed -a railscaptcha

Documentation and Support
-------------------------

Issues
-------------

Similar Projects
----------------

Contributing
------------

Credits
-------

License
-------
