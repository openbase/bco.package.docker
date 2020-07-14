# Baseline image
FROM openbaseorg/bco:experimental

# Set variables and locales
ENV \
    EXTRA_JAVA_OPTS="" \
    OPENHAB_SITEMAP="/etc/openhab2/sitemaps" \
    BCO_OPTIONS=""

# Basic build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/device-manager/openhab/Dockerfile" \
    org.label-schema.license="GPL3" \
    org.label-schema.name="bco-device-manager-openhab" \
    org.label-schema.vendor="openbase.org" \
    org.label-schema.version=$VERSION \
    org.label-schema.description="The BCO Device Manager connects all openhab devices to the bco infrastructure." \
    org.label-schema.url="https://www.basecubeone.org" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/openbase/bco.package.docker.git" \
    maintainer="Divine Threepwood <divine@openbase.org>"

# Expose volume
VOLUME ${BCO_HOME} ${OPENHAB_SITEMAP}

# Configure healthcheck
# todo: make sure only device offered by this device manager are checked
HEALTHCHECK --interval=1h --timeout=2m CMD bco-validate >/dev/null || exit 1

# switch to root, let the entrypoint drop back to bco user
USER root

# Set command
CMD bco-manager-device-openhab --bco-home ${BCO_HOME} ${BCO_OPTIONS}
