ARG XRAY_VERSION=v1.8.24

FROM alpine:3.20 AS fetch
ARG XRAY_VERSION
RUN apk add --no-cache curl unzip ca-certificates \
 && curl -fsSL -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-64.zip \
 && mkdir -p /tmp/xray && unzip -o /tmp/xray.zip -d /tmp/xray

FROM alpine:3.20
RUN apk add --no-cache ca-certificates tzdata
COPY --from=fetch /tmp/xray/xray /usr/local/bin/xray
COPY docker /etc/xray-src
RUN chmod +x /usr/local/bin/xray /etc/xray-src/entrypoint.sh
ENV UUID="" PORT_A="8443" PORT_B="8081" WS_PATH="/vless" WS_PATH_BAK="/vless-bak"
EXPOSE 8443 8081
ENTRYPOINT ["/bin/sh","/etc/xray-src/entrypoint.sh"]
