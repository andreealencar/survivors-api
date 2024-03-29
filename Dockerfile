FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /survivors-api
WORKDIR /survivors-api
COPY Gemfile /survivors-api/Gemfile
COPY Gemfile.lock /survivors-api/Gemfile.lock
RUN bundle install
COPY . /survivors-api

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]