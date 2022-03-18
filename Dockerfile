FROM ruby:2.6.6-alpine

RUN apk add --update --virtual \
    libpq-dev \
    libffi-dev \
    readline \
    build-base \
    postgresql-dev \
    postgresql \
    build-base \
    nodejs \
    yarn \
    git \
    wget \
    && rm -rf /var/cache/apk./*

WORKDIR /app
COPY . /app/

# RUN git clone https://github.com/Coder1221/rncs_worker_api_entreprise
# WORKDIR /rncs_worker_api_entreprise
# RUN git checkout regex_correction

ENV BUNDLE_PATH /gems
RUN gem install bundler:2.2.4
RUN bundle install

# RUN bundle exec sidekiq -e production
ENTRYPOINT [ "bin/rails" ]
CMD ["s", "-b", "0.0.0.0"] 
# , "-e","production"]
EXPOSE 3000