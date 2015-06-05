FROM alpine:3.2
MAINTAINER Georg Kunz, CloudGear <contact@cloudgear.net>

RUN apk add --update openssh && \
    rm -rf /var/cache/apk/* && \
    mkdir /var/run/sshd && \
    # generate keys once for all containers to prevent
    # REMOTE HOST IDENTIFICATION HAS CHANGED! notifications
    # during development
    ssh-keygen -t dsa -N '' -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t ecdsa -N '' -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -N '' -f /etc/ssh/ssh_host_ed25519_key

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /entrypoint.sh

ENV SSH_PUBKEY=""
EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]