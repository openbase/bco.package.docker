# Baseline image
FROM openbaseorg/bco:latest

# Set variables and locales
ENV \
    EXTRA_JAVA_OPTS="" \
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

# Expose volume
VOLUME ${BCO_HOME} ${OPENHAB_SITEMAP}

# Set entry point
# entrypoint is used to update docker gid and revert back to bco user
COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Configure healthcheck
HEALTHCHECK --interval=1h --timeout=2m CMD bco-validate >/dev/null || exit 1

# switch to root, let the entrypoint drop back to bco user
USER root

# Set command
CMD gosu bco tini -s bco-manager-device-openhab 
#CMD ["a", "b", "c"]
