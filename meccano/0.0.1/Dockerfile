FROM mhart/alpine-node:4.3.1

ENV NODE_ENV=production
ENV GATEWAY_VERSION=v1.1.0
ENV SERVICEMANAGER_VERSION=v0.0.1
ENV WEBCONSOLE_VERSION=v0.0.9
ENV R_VERSION=3.2.3-r0
ENV ADDRESS=0.0.0.0
ENV SEED_DB=true
ENV MYSQL_URI=mysql://root@localhost:3306/IOTDB
ENV SERVICEMANAGER_URL=http://localhost:8000
ENV TESTS_AUTH=true
ENV TESTS_STATISTIC=false
ENV TESTS_ZERO=false
ENV STATISTICS_SIGMA=6


RUN apk --no-cache add mysql mysql-client curl pcre-dev perl readline-dev libgfortran libgomp build-base && \
   curl -o R-${R_VERSION}.apk -sSL https://github.com/sgerrand/alpine-pkg-R/releases/download/v${R_VERSION}/R-${R_VERSION}.apk && \
   curl -o R-dev-${R_VERSION}.apk -sSL https://github.com/sgerrand/alpine-pkg-R/releases/download/v${R_VERSION}/R-dev-${R_VERSION}.apk && \
   curl -o R-doc-${R_VERSION}.apk -sSL https://github.com/sgerrand/alpine-pkg-R/releases/download/v${R_VERSION}/R-doc-${R_VERSION}.apk && \
   apk add --allow-untrusted R-${R_VERSION}.apk R-dev-${R_VERSION}.apk R-doc-${R_VERSION}.apk && \
   rm -f R-${R_VERSION}.apk R-dev-${R_VERSION}.apk R-doc-${R_VERSION}.apk

WORKDIR /app/
RUN curl -o gateway-${GATEWAY_VERSION}.tar.gz -sSL  https://github.com/meccano-iot/gateway/releases/download/${GATEWAY_VERSION}/meccano-gateway-${GATEWAY_VERSION}.tar.gz && \
   curl -o /schema.sql  -sSL https://raw.githubusercontent.com/meccano-iot/gateway/${GATEWAY_VERSION}/sql/schema.sql && \
   curl -o servicemanager-${SERVICEMANAGER_VERSION}.tar.gz -sSL  https://github.com/meccano-iot/servicemanager/releases/download/${SERVICEMANAGER_VERSION}/meccano-servicemanager-${SERVICEMANAGER_VERSION}.tar.gz && \
   curl -o webconsole-${WEBCONSOLE_VERSION}.tar.gz -sSL  https://github.com/meccano-iot/webconsole/releases/download/${WEBCONSOLE_VERSION}/meccano-webconsole-${WEBCONSOLE_VERSION}.tar.gz && \
   mkdir -p /app/gateway /app/servicemanager /app/webconsole && \
   tar -zxf gateway-${GATEWAY_VERSION}.tar.gz -C /app/gateway && \
   tar -zxf servicemanager-${SERVICEMANAGER_VERSION}.tar.gz -C /app/servicemanager && \
   tar -zxf webconsole-${WEBCONSOLE_VERSION}.tar.gz -C /app/webconsole && \
   rm -f gateway-${GATEWAY_VERSION}.tar.gz servicemanager-${SERVICEMANAGER_VERSION}.tar.gz webconsole-${WEBCONSOLE_VERSION}.tar.gz

# Install RMySQL package
RUN chmod a+x /app/servicemanager/plugins/packages.R
RUN /app/servicemanager/plugins/packages.R

RUN cd /app/gateway && /usr/bin/npm install --prod && \
    cd /app/servicemanager && /usr/bin/npm install --prod && \
    cd /app/webconsole/dist && /usr/bin/npm install --prod

RUN apk del build-base
COPY my.cnf /etc/mysql/my.cnf
COPY mysql-startup.sh /mysql-startup.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh /mysql-startup.sh
CMD /entrypoint.sh
# Expose ports.
EXPOSE 3000 8000 9000
