# Maven 3.5 with openjdk 8 and Git
FROM maven:3.5-jdk-8-alpine

ARG MAVEN_USER=maven
ARG MAVEN_UID=1000
ARG MAVEN_GROUP=maven
ARG MAVEN_GID=1000
ENV MAVEN_HOME_DIR="/var/${MAVEN_USER}_home"
ENV MAVEN_CONFIG="$MAVEN_HOME_DIR/.m2"

# this image is run with user `maven`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN mkdir -p $MAVEN_HOME_DIR \
    && chown ${MAVEN_UID}:${MAVEN_GID} $MAVEN_HOME_DIR \
    && addgroup -g ${MAVEN_GID} ${MAVEN_GROUP} \
    && adduser -h "$MAVEN_HOME_DIR" -u ${MAVEN_UID} -G ${MAVEN_GROUP} -s /bin/sh -D ${MAVEN_GROUP}

# Maven home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME $MAVEN_HOME_DIR

# Add user maven to list of sudoers
RUN echo "$MAVEN_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN \
	# Print executed commands
	set -x \
    # Download the install alpine-base
    && curl -s -o /tmp/install-base.sh https://raw.githubusercontent.com/craftdock/Install-Scripts/master/alpine-base/install-base.sh \
    && sh /tmp/install-base.sh \
    && rm /entrypoint \
    # Update repository indexes
    && apk-update \
    # Install git and openssh
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ \
        git \
        openssh \
    # Install sudo
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
        sudo \
	# Clear apk's cache
	&& apk-cleanup

# Replace default entrypoint
COPY fs/entrypoint /usr/local/bin/entrypoint
RUN chown ${MAVEN_UID}:${MAVEN_GID} /usr/local/bin/entrypoint \
    && chown ${MAVEN_UID}:${MAVEN_GID} /usr/local/bin/mvn-entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint

# Switch to maven user
USER ${MAVEN_USER}

# Define entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]