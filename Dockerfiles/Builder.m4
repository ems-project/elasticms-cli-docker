USER 1001

ENV ELASTICMS_CLIENT_VERSION=${VERSION_ARG:-5.1.2} 
ENV ELASTICMS_CLIENT_DOWNLOAD_URL="https://github.com/ems-project/elasticms-cli/archive/refs/tags/${ELASTICMS_CLIENT_VERSION}.tar.gz" 
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN echo "Download and build elasticms-client ..." \
    && mkdir -p /opt/src/elasticms \
    && cd /opt/src/elasticms \
    && curl -sSfL ${ELASTICMS_CLIENT_DOWNLOAD_URL} | tar -xzC /opt/src/elasticms --strip-components=1 \
    && COMPOSER_MEMORY_LIMIT=-1 composer -vvvv install --no-interaction --no-suggest --no-scripts --working-dir /opt/src/elasticms -o \
    && npm install --prefix /opt/src/elasticms /opt/src/elasticms
