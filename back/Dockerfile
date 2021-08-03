FROM ruby:2.7.2
RUN apt-get update -qq && \
    apt-get install -y nodejs \
                       cron

WORKDIR /back

COPY Gemfile /back/Gemfile
COPY Gemfile.lock /back/Gemfile.lock
RUN bundle install
COPY . /back
RUN bundle exec whenever --update-crontab 
RUN mkdir -p /back/tmp/sockets

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]