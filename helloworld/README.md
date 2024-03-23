
gcloud init
 gcloud config set project heidless-pfolio-deploy-5

# Write the sample application
 mkdir helloworld
cd helloworld

app.rb
-
require "sinatra"

set :bind, "0.0.0.0"
port = ENV["PORT"] || "8080"
set :port, port

get "/" do
  name = ENV["NAME"] || "World"
  "Hello #{name}!"
end
-
Gemfile
-
source "https://rubygems.org"

gem "sinatra", "~>3.1"
gem "thin"

group :test do
  gem "rack-test"
  gem "rest-client"
  gem "rspec"
  gem "rspec_junit_formatter"
  gem "rspec-retry"
  gem "rubysl-securerandom"
end
-

bundle install

Dockerfile
-

# Use the official Ruby image.
# https://hub.docker.com/_/ruby
FROM ruby:3.2-buster

# Install production dependencies.
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true
RUN gem install bundler && bundle config set --local without 'test'

# Copy local code to the container image.
COPY . ./
RUN bundle install

# Run the web service on container startup.
CMD ["ruby", "./app.rb"]
-

.dockerignore
-
Dockerfile
README.md
.ruby-version
.bundle/
vendor/
-

# Deploy to Cloud Run from source
gcloud run deploy

