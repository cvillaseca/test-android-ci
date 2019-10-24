FROM circleci/android:api-29

USER root

# Skip checking SSH host keys.
RUN mkdir /root/.ssh && chmod 700 /root/.ssh
RUN /bin/echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# Install Node
RUN apt-get install -y curl \
  && curl -sL https://deb.nodesource.com/setup_9.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh

# install Firebase CLI
RUN npm install -g firebase-tools