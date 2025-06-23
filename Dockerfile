# Dockerfile.production

# --- Base Stage ---
FROM ruby:3.4.3-bookworm AS base
ENV INSTALL_PATH=/a
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY Gemfile* ./
#RUN chown -R user:user $INSTALL_PATH

# --- Bundle Install ---
#FROM base AS builder


# --- Final Stage (Smallest Image) ---
FROM base
#RUN bundle config set --local force_ruby_platform false
#RUN bundle config unset force_ruby_platform
#RUN bundle update --bundler

RUN apt-get update && apt-get install -y \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev

RUN bundle update --bundler
#RUN bundle config set force_ruby_platform true

RUN bundle lock --add-platform x86_64-linux
RUN bundle install #--jobs $(nproc) --retry 3
#COPY --from=builder $INSTALL_PATH $INSTALL_PATH
COPY . .
RUN bundle exec rails assets:precompile 

#RUN chown -R user:user $INSTALL_PATH

ARG BUILD_ENV=production 
ENV ENVIRONMENT=%{BUILD_ENV}

#ARG  SECRET_KEY_BASE=cd62774c04eff82aaea3033c416e1415faad7cd1930358d2ba1273aac7bee8fd0eaaa1b6685a66122e9e9be6f25d2ec69b44510dcbc7c44a9359cb8f2d0031af


EXPOSE 3000
#CMD ["bundle", "exec", "rails", "server", "-p", "3000"]

