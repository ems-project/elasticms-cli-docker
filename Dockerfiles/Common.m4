ENV PHP_EXT_SQLSRV_VERSION=${PHP_EXT_SQLSRV_VERSION:-5.12.0} \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

LABEL be.fgov.elasticms.client.build-date=$BUILD_DATE_ARG \
      be.fgov.elasticms.client.name="elasticms-cli" \
      be.fgov.elasticms.client.description="Command client of the ElasticMS suite." \
      be.fgov.elasticms.client.url="https://hub.docker.com/repository/docker/elasticms/cli" \
      be.fgov.elasticms.client.vcs-ref=$VCS_REF_ARG \
      be.fgov.elasticms.client.vcs-url="https://github.com/ems-project/elasticms-cli-docker" \
      be.fgov.elasticms.client.vendor="sebastian.molle@gmail.com" \
      be.fgov.elasticms.client.version="$VERSION_ARG" \
      be.fgov.elasticms.client.release="$RELEASE_ARG" \
      be.fgov.elasticms.client.schema-version="1.0"

USER root

COPY --from=builder --chmod=775 --chown=1001:0 /app/src/elasticms /app/src/elasticms
COPY --from=builder --chmod=775 --chown=1001:0 /app/bin/tika-app.jar /app/bin/tika-app.jar

COPY --chmod=775 --chown=1001:0 bin/ /usr/local/bin/
COPY --chmod=770 --chown=1001:0 etc/ /usr/local/etc/

RUN apk add --update --no-cache --virtual .extra-php-ext-build-deps $PHPIZE_DEPS unixodbc-dev ; \
    docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC ; \
    docker-php-ext-install -j "$(nproc)" pdo_odbc ; \
    pecl install sqlsrv-${PHP_EXT_SQLSRV_VERSION} ; \
    pecl install pdo_sqlsrv-${PHP_EXT_SQLSRV_VERSION} ; \
    docker-php-ext-enable sqlsrv pdo_sqlsrv ; \
    runDeps="$( \
       scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
       | tr ',' '\n' \
       | sort -u \
       | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
       )" ; \
    apk add --update --no-cache --virtual .ems-phpext-rundeps $runDeps ; \
    apk del .extra-php-ext-build-deps ; \
    rm -rf /var/cache/apk/* ; \
    \
    apk add --update --no-cache tini \
                                chromium \
                                nss \
                                freetype \
                                harfbuzz \
                                ca-certificates \
                                ttf-freefont \
                                openjdk17-jre \
                                tesseract-ocr \
                                msttcorefonts-installer \
                                ttf-dejavu \
                                fontconfig \
                                supervisor \
                                supercronic ; \
    update-ms-fonts ; \
    fc-cache -f -v ; \
    rm /etc/supervisord.conf /etc/crontabs/root ; \
    mkdir -p /etc/supervisord/supervisord.d ; \
    touch /var/log/supervisord.log /var/run/supervisord.pid ; \
    mkdir -p /home/default/Downloads /app ; \
    chown -R 1001:0 /app/src/elasticms \
                    /home/default/Downloads \
                    /app \
                    /etc/crontabs \
                    /etc/supervisord \
                    /var/log/supervisord.log \
                    /var/run/supervisord.pid ; \
    chmod -R ug+rw /app/src/elasticms \
                   /home/default/Downloads \
                   /app \
                   /etc/crontabs \
                   /etc/supervisord \
                   /var/log/supervisord.log \
                   /var/run/supervisord.pid ; \
    find /app/src/elasticms -type d -exec chmod ug+x {} \; 

WORKDIR /app/src/elasticms

USER 1001

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/container-entrypoint"]

CMD ["/bin/sh", "-ec", "while :; do echo '.'; sleep 5 ; done"]