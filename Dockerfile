FROM golang:1.12.6 AS build-env
ADD . /opt
WORKDIR /opt
RUN sh build.sh

FROM alpine
COPY localtime /etc/localtime
RUN mkdir /app && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
COPY --from=build-env /usr/local/go/lib/time/zoneinfo.zip /usr/local/go/lib/time/zoneinfo.zip
COPY --from=build-env /opt/conf/sms.yaml /app/conf/
COPY --from=build-env /opt/prometheus-alert-sms /app
WORKDIR /app
EXPOSE 9000
ENTRYPOINT ["/app/prometheus-alert-sms"]