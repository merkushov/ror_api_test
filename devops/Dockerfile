FROM ruby:2.7.2
#RUN apt-get update -qq && apt-get install -y gcc build-essential

ENV HOMEDIR /opt/funbox
RUN mkdir $HOMEDIR
WORKDIR $HOMEDIR

COPY Gemfile "${HOMEDIR}/Gemfile"
COPY Gemfile.lock "${HOMEDIR}/Gemifle.lock"
RUN bundle install
COPY . $HOMEDIR

# Add a script to be executed every time the container starts.
COPY devops/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]