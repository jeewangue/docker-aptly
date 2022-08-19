# syntax = docker/dockerfile:1.4
FROM debian:buster

LABEL maintainer="jeewangue@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive

# Update APT repository & install packages (except aptly)
RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
  apt-get -q update && \
  apt-get -y upgrade && \
  apt-get -y install \
  bzip2 \
  gnupg2 \
  gpgv \
  graphviz \
  supervisor \
  nginx \
  curl \
  xz-utils \
  apt-utils \
  gettext-base \
  bash-completion

RUN curl -sL https://www.aptly.info/pubkey.txt | gpg --dearmor | tee /etc/apt/trusted.gpg.d/aptly.gpg >/dev/null \
  && echo "deb http://repo.aptly.info/ squeeze main" >> /etc/apt/sources.list

# Install aptly package
RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
  apt-get -q update \
  && apt-get -y install aptly=1.4.0 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/*

# Create volume
VOLUME [ "/opt/aptly" ]
ENV GNUPGHOME="/opt/aptly/gpg"

# Install bash auto-completion
ADD https://raw.githubusercontent.com/aptly-dev/aptly/v1.4.0/completion.d/aptly /usr/share/bash-completion/completions/aptly

RUN echo "if ! shopt -oq posix; then\n\
  if [ -f /usr/share/bash-completion/bash_completion ]; then\n\
  . /usr/share/bash-completion/bash_completion\n\
  elif [ -f /etc/bash_completion ]; then\n\
  . /etc/bash_completion\n\
  fi\n\
  fi" >> /etc/bash.bashrc

# Install configurations
COPY assets/aptly.conf /etc/aptly.conf
COPY assets/nginx.conf.template /etc/nginx/templates/default.conf.template
COPY assets/supervisord.web.conf /etc/supervisor/conf.d/web.conf

# Install scripts
COPY assets/*.sh /opt/

# Declare ports in use
EXPOSE 80 8080

ENV NGINX_CLIENT_MAX_BODY_SIZE=100M

ENTRYPOINT [ "/opt/entrypoint.sh" ]

# Start Supervisor when container starts (It calls nginx)
CMD /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

WORKDIR /opt/aptly
