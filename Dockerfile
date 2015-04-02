FROM resin/rpi-raspbian

RUN apt-get update
RUN apt-get -y install build-essential bison libgdbm-dev ruby libssl-dev curl libreadline-dev

ENV RUBY_MAJOR=2.2
ENV RUBY_VERSION=2.2.1

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/src/ruby
RUN curl -o /tmp/ruby.tar.gz -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz"
RUN tar -xvzC /usr/src/ruby --strip-components=1 -f /tmp/ruby.tar.gz
RUN rm /tmp/ruby.tar.gz

WORKDIR /usr/src/ruby
RUN ./configure --disable-install-doc
RUN make -j"$(nproc)"
RUN make install
RUN apt-get purge -y --auto-remove bison libgdbm-dev ruby build-essential
RUN rm -r /usr/src/ruby

# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

# install things globally, for great justice
ENV GEM_HOME=/usr/local/bundle
ENV PATH=$GEM_HOME/bin:$PATH
RUN gem install bundler
RUN bundle config --global path "$GEM_HOME"
RUN bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

CMD [ "irb" ]
