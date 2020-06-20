# Baseline image
FROM azul/zulu-openjdk-debian:11

# Set variables and locales
ENV \
    EXTRA_JAVA_OPTS="" \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    BCO_USER="bco" \
    BCO_USER_HOME="/home/bco" \
    BCO_HOME="/home/bco/data" \
    BCO_BINARY="/usr/bin/bco" \
    OPENHAB_SITEMAP="/etc/openhab2/sitemaps"

# Basic build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="GPL3" \
    org.label-schema.name="bco" \
    org.label-schema.vendor="openbase.org" \
    org.label-schema.version=$VERSION \
    org.label-schema.description="A behaviour based smart environment plattform" \
    org.label-schema.url="https://www.basecubeone.org" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/openbase/bco.package.docker.git" \
    maintainer="Divine Threepwood <divine@openbase.org>"

# Setup Openbase Debian Repository
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AAF438A589C2F541
RUN echo "deb https://dl.bintray.com/openbase/deb buster main" | tee -a /etc/apt/sources.list
RUN echo "deb https://dl.bintray.com/openbase/deb buster testing" | tee -a /etc/apt/sources.list

# Install bco
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    gosu \
    tini \
    fontconfig \
    locales \
    locales-all \
    bco

# Create bco user because bco does not need any root privileges
RUN groupadd -r bco && \
    useradd --no-log-init --home-dir /home/bco --system --create-home -g bco bco

# Expose volume
VOLUME ${BCO_HOME} ${OPENHAB_SITEMAP}

# Set working dir
WORKDIR ${BCO_USER_HOME}

# Set entry point
# entrypoint is used to update docker gid and revert back to bco user
COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Set healthcheck
HEALTHCHECK CMD bco-validate >/dev/null || exit 1

# switch to root, let the entrypoint drop back to bco user
USER root

# Set command
CMD gosu bco tini -s bco -v --log-level debug
CMD ["bco", "-v", "--log-level", "debug"]
#CMD gosu ${BCO_USER} tini -s bco -v
#CMD ["gosu", ${BCO_USER}, "tini", "bco"]
