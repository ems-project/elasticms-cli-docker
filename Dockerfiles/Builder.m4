USER 1001

ENV ELASTICMS_CLIENT_VERSION=${VERSION_ARG:-6.0.0} 
ENV ELASTICMS_CLIENT_DOWNLOAD_URL="https://github.com/ems-project/elasticms-cli/archive/refs/tags/${ELASTICMS_CLIENT_VERSION}.tar.gz" 
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN echo "Download and build elasticms-client ..." \
    && mkdir -p /app/src/elasticms \
    && cd /app/src/elasticms \
    && echo "Download ${ELASTICMS_CLIENT_DOWNLOAD_URL} package" \
    && curl -sSfL ${ELASTICMS_CLIENT_DOWNLOAD_URL} | tar -xzC /app/src/elasticms --strip-components=1 \
    && COMPOSER_MEMORY_LIMIT=-1 composer -vvv install --no-interaction --no-suggest --no-scripts --working-dir /app/src/elasticms -o 

ENV TIKA_VERSION=${TIKA_VERSION_ARG:-2.9.2} 

USER root

RUN echo "Install Tika App ..." \
    && apk add --update gnupg wget \
    && mkdir -p /app/bin \
    && NEAREST_TIKA_URL="https://www.apache.org/dyn/closer.cgi/tika/${TIKA_VERSION}/tika-app-${TIKA_VERSION}.jar?filename=tika/${TIKA_VERSION}/tika-app-${TIKA_VERSION}.jar&action=download" \
    && ARCHIVE_TIKA_URL="https://archive.apache.org/dist/tika/${TIKA_VERSION}/tika-app-${TIKA_VERSION}.jar" \
    && DEFAULT_TIKA_ASC_URL="https://downloads.apache.org/tika/${TIKA_VERSION}/tika-app-${TIKA_VERSION}.jar.asc" \
    && ARCHIVE_TIKA_ASC_URL="https://archive.apache.org/dist/tika/${TIKA_VERSION}/tika-app-${TIKA_VERSION}.jar.asc" \
    && wget -t 10 --max-redirect 1 --retry-connrefused -qO- https://downloads.apache.org/tika/KEYS | gpg --import \
    && wget -t 10 --max-redirect 1 --retry-connrefused $NEAREST_TIKA_URL -O /app/bin/tika-app-${TIKA_VERSION}.jar || rm /app/bin/tika-app-${TIKA_VERSION}.jar \
    && sh -c "[ -f /app/bin/tika-app-${TIKA_VERSION}.jar ]" || wget $ARCHIVE_TIKA_URL -O /app/bin/tika-app-${TIKA_VERSION}.jar || rm /app/bin/tika-app-${TIKA_VERSION}.jar \
    && sh -c "[ -f /app/bin/tika-app-${TIKA_VERSION}.jar ]" || exit 1 \
    && wget -t 10 --max-redirect 1 --retry-connrefused $DEFAULT_TIKA_ASC_URL -O /app/bin/tika-app-${TIKA_VERSION}.jar.asc  || rm /app/bin/tika-app-${TIKA_VERSION}.jar.asc \
    && sh -c "[ -f /app/bin/tika-app-${TIKA_VERSION}.jar.asc ]" || wget $ARCHIVE_TIKA_ASC_URL -O /app/bin/tika-app-${TIKA_VERSION}.jar.asc || rm /app/bin/tika-app-${TIKA_VERSION}.jar.asc \
    && sh -c "[ -f /app/bin/tika-app-${TIKA_VERSION}.jar.asc ]" || exit 1 \
    && gpg --verify /app/bin/tika-app-${TIKA_VERSION}.jar.asc /app/bin/tika-app-${TIKA_VERSION}.jar \
    && cp /app/bin/tika-app-${TIKA_VERSION}.jar /app/bin/tika-app.jar

# https://learn.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-ver16

RUN echo "Install Microsoft ODBC Driver ..." \
    && MSODBCSQL_DRIVER_URL="https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.9.1.1-1_amd64.apk" \
    && MSODBCSQL_DRIVER_ASC_URL="https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.9.1.1-1_amd64.sig" \
    && wget -t 10 --max-redirect 1 --retry-connrefused -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --import \
    && wget -t 10 --max-redirect 1 --retry-connrefused $MSODBCSQL_DRIVER_URL -O /tmp/msodbcsql17.apk || rm /tmp/msodbcsql17.apk \
    && sh -c "[ -f /tmp/msodbcsql17.apk ]" || exit 1 \
    && wget -t 10 --max-redirect 1 --retry-connrefused $MSODBCSQL_DRIVER_ASC_URL -O /tmp/msodbcsql17.sig  || rm /tmp/msodbcsql17.sig \
    && sh -c "[ -f /tmp/msodbcsql17.sig ]" || exit 1 \
    && gpg --verify /tmp/msodbcsql17.sig /tmp/msodbcsql17.apk \
    && cp /tmp/msodbcsql17.apk /app/bin/msodbcsql17.apk