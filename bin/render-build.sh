#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# In case we want to reset the database, uncomment the following line:
# bundle exec rails db:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1

# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:
bundle exec rails db:migrate