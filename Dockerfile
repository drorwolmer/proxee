FROM mitmproxy/mitmproxy:7.0.4

RUN pip install supervisor
COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY proxee.sh /usr/local/bin/proxee.sh
ENTRYPOINT ["/usr/local/bin/proxee.sh"]

VOLUME /home/mitmproxy/.mitmproxy
EXPOSE 8443
EXPOSE 8080


