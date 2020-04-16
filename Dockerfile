FROM anapsix/alpine-java:8_jdk

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="e.g. https://github.com/turo/marvin"

ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"

ENV ANDROID_HOME "/android-sdk"
ENV ANDROID_COMPILE_SDK "28"
ENV ANDROID_BUILD_TOOLS "28.0.3"
ENV ANDROID_SDK_TOOLS "3859397"
ENV FIREBASE_TOOLS "v8.0.3"
ENV PATH "$PATH:${ANDROID_HOME}/platform-tools"

RUN apk update && \
    apk add --no-cache \
        git \
        bash \
        curl \
        wget \
        zip \
        unzip \
        ruby \
        ruby-rdoc \
        ruby-irb \
        ruby-dev \
        openssh \
        g++ \
        make \
    && rm -rf /tmp/* /var/tmp/*

# Skip checking SSH host keys.
RUN mkdir /root/.ssh && chmod 700 /root/.ssh
RUN /bin/echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

RUN apk --no-cache add ca-certificates wget
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-2.26-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-bin-2.26-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-i18n-2.26-r0.apk

RUN apk add glibc-2.26-r0.apk
RUN apk add glibc-bin-2.26-r0.apk
RUN apk add glibc-i18n-2.26-r0.apk
RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8

RUN gem install fastlane -NV

ADD https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip sdk-tools-linux.zip

RUN unzip sdk-tools-linux.zip -d ${ANDROID_HOME} && \
    rm sdk-tools-linux.zip && \
    echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}"

#firebase-tools setup
ADD https://github.com/firebase/firebase-tools/releases/download/${FIREBASE_TOOLS}/firebase-tools-linux firebase-tools-linux
RUN chmod +x firebase-tools-linux
RUN ./firebase-tools-linux --open-sesame appdistribution