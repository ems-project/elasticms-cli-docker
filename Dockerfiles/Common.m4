ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
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

COPY --from=builder --chmod=775 --chown=1001:0 /opt/src/elasticms /opt/src/elasticms
COPY --from=builder --chmod=775 --chown=1001:0 /opt/bin/tika-app.jar /opt/bin/tika-app.jar
COPY --chmod=775 --chown=1001:0  bin/ /usr/local/bin/

RUN echo "Install required runtime ..." \
    && apk add --update --no-cache tini \
      chromium \
      nss \
      freetype \
      harfbuzz \
      ca-certificates \
      ttf-freefont  \
      openjdk13-jre-headless \
      tesseract-ocr \
      msttcorefonts-installer \
      ttf-dejavu \
      fontconfig \
    && echo "Configure container ..." \
    && update-ms-fonts \
    && fc-cache -f -v \
    && mkdir -p /home/default/Downloads /app \
    && chown -R 1001:0 /opt/src/elasticms /home/default/Downloads /app \
    && chmod -R ug+rw /opt/src/elasticms /home/default/Downloads /app \
    && find /opt/src/elasticms -type d -exec chmod ug+x {} \; \
    && chmod +x /usr/local/bin/container-entrypoint \
                /usr/local/bin/elasticms

WORKDIR /opt/src/elasticms

USER 1001

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/container-entrypoint"]

CMD ["/bin/sh", "-ec", "while :; do echo '.'; sleep 5 ; done"]