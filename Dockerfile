FROM ruby:2.7.2
RUN apt-get update -qq && \
    apt-get install -y nodejs \
                       npm && \
    npm install -g yarn

WORKDIR /study_management_app

COPY Gemfile /study_management_app/Gemfile
COPY Gemfile.lock /study_management_app/Gemfile.lock
RUN bundle install
COPY . /study_management_app
RUN mkdir -p /study_management_app/tmp/sockets

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]