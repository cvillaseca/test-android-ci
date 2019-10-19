FROM circleci/android:api-29

USER root
RUN mkdir /root/.ssh && chmod 700 /root/.ssh
RUN /bin/echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config