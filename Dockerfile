
# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
# ARG RUBY_VERSION=3.2.0
# FROM ruby:$RUBY_VERSION

# # Rails app lives here
# WORKDIR /rails

# # Set production environment
# ENV RAILS_ENV="production" \
#     BUNDLE_DEPLOYMENT="1" \
#     BUNDLE_PATH="/usr/local/bundle" \
#     BUNDLE_WITHOUT="development"\
#     RAILS_MASTER_KEY=81b944aba69380abde878c434272261e \
#     REDIS_URL="redis://redis_app:6379"


# # Throw-away build stage to reduce size of final image
# FROM base as build

# # Install libvips for Active Storage preview support
# RUN apt-get update -qq && \
#     apt-get install -y build-essential libvips bash bash-completion libffi-dev tzdata postgresql nodejs npm yarn && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# # Install application gems
# COPY Gemfile Gemfile.lock ./
# RUN bundle install 

# # Copy application code
# COPY . .

# # Precompile bootsnap code for faster boot times
# RUN bundle exec bootsnap precompile app/ lib/

# # Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# # # Final stage for app image
# # FROM base

# # # Install packages needed for deployment
# # RUN apt-get update -qq && \
# #     apt-get install --no-install-recommends -y curl libvips postgresql-client && \
# #     rm -rf /var/lib/apt/lists /var/cache/apt/archives

# # # Copy built artifacts: gems, application
# # COPY --from=build /usr/local/bundle /usr/local/bundle
# # COPY --from=build /rails /rails

# # # Run and own only the runtime files as a non-root user for security
# # RUN useradd rails --create-home --shell /bin/bash && \
# #     chown -R rails:rails db log storage tmp
# # USER rails:rails

# # Entrypoint prepares the database.
# ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# # Start the server by default, this can be overwritten at runtime
# EXPOSE 3000
# CMD ["./bin/rails", "server"]


ARG RUBY_VERSION=3.2.0
FROM ruby:$RUBY_VERSION

# Install libvips for Active Storage preview support
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips bash bash-completion libffi-dev tzdata postgresql nodejs npm yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="production" \
    BUNDLE_WITHOUT="development"

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]