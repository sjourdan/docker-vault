FROM progrium/busybox
MAINTAINER Stephane Jourdan <fasten@fastmail.fm>
ENV REFRESHED_AT 2016-03-15
ENV VAULT_VERSION 0.5.1
ENV VAULT_TMP_FILE /tmp/vault.zip

# x509 expects certs to be in this file only.
ADD https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt

ADD https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip ${VAULT_TMP_FILE}

RUN cd /bin && unzip ${VAULT_TMP_FILE} && chmod +x /bin/vault && rm ${VAULT_TMP_FILE}

EXPOSE 8200
ENV VAULT_ADDR "http://127.0.0.1:8200"

ENTRYPOINT ["/bin/vault"]
CMD ["server", "-dev"]
