USER 1001

ENV ELASTICMS_CLIENT_VERSION=${VERSION_ARG:-5.1.2} 
ENV ELASTICMS_CLIENT_DOWNLOAD_URL="https://github.com/ems-project/elasticms-cli/archive/refs/tags/${ELASTICMS_CLIENT_VERSION}.tar.gz" 
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN echo "Download and build elasticms-client ..." \
    && mkdir -p /opt/src/elasticms \
    && cd /opt/src/elasticms \
    && echo "Download ${ELASTICMS_CLIENT_DOWNLOAD_URL} package" \
    && curl -sSfL ${ELASTICMS_CLIENT_DOWNLOAD_URL} | tar -xzC /opt/src/elasticms --strip-components=1 \
    && COMPOSER_MEMORY_LIMIT=-1 composer -vvvv install --no-interaction --no-suggest --no-scripts --working-dir /opt/src/elasticms -o \
    && npm install --prefix /opt/src/elasticms /opt/src/elasticms

ENV TIKA_VERSION=${TIKA_VERSION_ARG:-2.7.0} 

USER root

RUN echo "Install Tika App ..." \
    && apk add --update gnupg wget \
    && mkdir -p /opt/bin \
    && NEAREST_TIKA_URL="https://www.apache.org/dyn/closer.cgi/tika/${TIKA_VERSION}/tika-app-${TIKA_VERSION}.jar?filename=tika/${TIKA_VERSION}/tika-app-${TIKA_VERSION}.jar&action=download" \
    && ARCHIVE_TIKA_URL="https://archive.apache.org/dist/tika/${TIKA_VERSION}/tika-app-${TIKA_VERSION}.jar" \
    && DEFAULT_TIKA_ASC_URL="https://downloads.apache.org/tika/${TIKA_VERSION}/tika-app-${TIKA_VERSION}.jar.asc" \
    && ARCHIVE_TIKA_ASC_URL="https://archive.apache.org/dist/tika/${TIKA_VERSION}/tika-app-${TIKA_VERSION}.jar.asc" \
    && wget -t 10 --max-redirect 1 --retry-connrefused -qO- https://downloads.apache.org/tika/KEYS | gpg --import \
    && wget -t 10 --max-redirect 1 --retry-connrefused $NEAREST_TIKA_URL -O /opt/bin/tika-app-${TIKA_VERSION}.jar || rm /opt/bin/tika-app-${TIKA_VERSION}.jar \
    && sh -c "[ -f /opt/bin/tika-app-${TIKA_VERSION}.jar ]" || wget $ARCHIVE_TIKA_URL -O /opt/bin/tika-app-${TIKA_VERSION}.jar || rm /opt/bin/tika-app-${TIKA_VERSION}.jar \
    && sh -c "[ -f /opt/bin/tika-app-${TIKA_VERSION}.jar ]" || exit 1 \
    && wget -t 10 --max-redirect 1 --retry-connrefused $DEFAULT_TIKA_ASC_URL -O /opt/bin/tika-app-${TIKA_VERSION}.jar.asc  || rm /opt/bin/tika-app-${TIKA_VERSION}.jar.asc \
    && sh -c "[ -f /opt/bin/tika-app-${TIKA_VERSION}.jar.asc ]" || wget $ARCHIVE_TIKA_ASC_URL -O /opt/bin/tika-app-${TIKA_VERSION}.jar.asc || rm /opt/bin/tika-app-${TIKA_VERSION}.jar.asc \
    && sh -c "[ -f /opt/bin/tika-app-${TIKA_VERSION}.jar.asc ]" || exit 1 \
    && gpg --verify /opt/bin/tika-app-${TIKA_VERSION}.jar.asc /opt/bin/tika-app-${TIKA_VERSION}.jar \
    && cp /opt/bin/tika-app-${TIKA_VERSION}.jar /opt/bin/tika-app.jar