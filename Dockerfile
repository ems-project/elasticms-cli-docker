FROM docker.io/elasticms/base-php-cli-dev:8.1 as builder

ARG VERSION_ARG
ARG RELEASE_ARG
ARG BUILD_DATE_ARG
ARG VCS_REF_ARG

USER 1001

ENV ELASTICMS_CLIENT_VERSION=${VERSION_ARG:-0.0.1} 
ENV ELASTICMS_CLIENT_DOWNLOAD_URL="https://github.com/ems-project/elasticms-cli/archive/refs/tags/${ELASTICMS_CLIENT_VERSION}.tar.gz" 

RUN echo "Download and build elasticms-client ..." \
    && mkdir -p /opt/src/elasticms \
    && cd /opt/src/elasticms \
    && curl -sSfL ${ELASTICMS_CLIENT_DOWNLOAD_URL} | tar -xzC /opt/src/elasticms --strip-components=1 \
    && COMPOSER_MEMORY_LIMIT=-1 composer -vvvv install --no-interaction --no-suggest --no-scripts --working-dir /opt/src/elasticms -o 

FROM docker.io/elasticms/base-php-cli:8.1

ARG VERSION_ARG
ARG RELEASE_ARG
ARG BUILD_DATE_ARG
ARG VCS_REF_ARG

ENV NODE_ENV production

LABEL eu.elasticms.client.build-date=$BUILD_DATE_ARG \
      eu.elasticms.client.name="elasticms-cli" \
      eu.elasticms.client.description="Command client of the ElasticMS suite." \
      eu.elasticms.client.url="https://hub.docker.com/repository/docker/elasticms/cli" \
      eu.elasticms.client.vcs-ref=$VCS_REF_ARG \
      eu.elasticms.client.vcs-url="https://github.com/ems-project/elasticms-cli-docker" \
      eu.elasticms.client.vendor="sebastian.molle@gmail.com" \
      eu.elasticms.client.version="$VERSION_ARG" \
      eu.elasticms.client.release="$RELEASE_ARG" \
      eu.elasticms.client.schema-version="1.0" 

USER root

COPY --from=builder --chmod=775 --chown=1001:0 /opt/src/elasticms /opt/src/elasticms
COPY --chmod=775 --chown=1001:0  bin/ /usr/local/bin/

RUN echo "Install required runtime ..." \
    && apk add --update --no-cache tini \
    && echo "Configure container ..." \
    && chmod +x /usr/local/bin/container-entrypoint \
                /usr/local/bin/elasticms 

WORKDIR /opt/src/elasticms

USER 1001

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/container-entrypoint"]

CMD ["/bin/sh", "-ec", "while :; do echo '.'; sleep 5 ; done"]