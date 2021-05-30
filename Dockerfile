FROM alpine:3.13
ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US:en"
ENV LC_ALL "en_US.UTF-8"
ENV TIMEZONE "Europe/Zurich"
ENV DB_URL "ecto://{user}:{password}@{host}/postgres"
ENV APP_DOMAIN "{domain}"
ENV SECRET_KEY "{secret_key}"
COPY release.tar .
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    ca-certificates \
    ncurses-libs \
    tzdata && \
    update-ca-certificates && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" >/etc/timezone && \
    tar -xf release.tar -C /opt && \
    rm release.tar && \
    mv /opt/release /opt/crea && \
    chown -R nobody:nobody /opt/crea
WORKDIR /opt/crea
COPY --chown=nobody:nobody ./dkim/private-key.pem .
USER nobody:nobody
EXPOSE 4000
ENTRYPOINT ["bin/api"]
CMD ["start"]
