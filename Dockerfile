FROM circleci/android:api-29-ndk

USER root

# Skip checking SSH host keys.
RUN mkdir /root/.ssh && chmod 700 /root/.ssh
RUN /bin/echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# Install Node
RUN apt-get install -y curl \
  && curl -sL https://deb.nodesource.com/setup_9.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh

# Download and install Gradle
RUN \
  cd /usr/local && \
  curl -L https://services.gradle.org/distributions/gradle-6.6.1-bin.zip -o gradle-6.6.1-bin.zip && \
  unzip gradle-6.6.1-bin.zip && \
  rm gradle-6.6.1-bin.zip

# Export some environment variables
ENV GRADLE_HOME=/usr/local/gradle-6.2.1
ENV PATH=$PATH:$GRADLE_HOME/bin

# install Firebase CLI
RUN npm install -g firebase-tools

COPY Gemfile* ./
RUN bundle install
RUN bundle update
