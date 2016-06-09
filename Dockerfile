FROM gliderlabs/alpine:3.3
MAINTAINER uneidel <uneidel@octonion.de>

RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN apk add --no-cache wget w3m bash
COPY update.sh /bin/
COPY crontab /var/spool/cron/crontabs/root
RUN chmod +x /bin/update.sh
# Run crond in foreground mode with the log level set to 10:
CMD ["crond", "-f", "-l", "10"]
