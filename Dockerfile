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

ENTRYPOINT ["/rails/bin/docker-dev-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]


# Run the web service on container startup.
#CMD ["ruby", "./app.rb"]