# Fetch ruby Image
FROM ruby:2.6.3

# Setting default args, args are overridden in docker-compose.override.yml
ARG BUNDLER_OPTS="--jobs=5 --retry=3 --without development test"
ARG RAILS_ENVIRONMENT="production"

# Setting Environment based on arg
ENV RAILS_ENV=${RAILS_ENVIRONMENT}
ENV APP_HOME /aws_deploy

# Install dependencies

RUN apt-get update && apt-get install -y postgresql-client curl dumb-init nodejs yarn

# Create and set application work directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Copy Gemfiles
COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock

# Install gems
RUN gem install bundler:2.0.1
RUN bundle install ${BUNDLER_OPTS}

# Copy project's files
COPY . $APP_HOME

# Expose port
EXPOSE 3000
