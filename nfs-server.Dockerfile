FROM centos:7

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo && \
    yum update -y && \
    yum install -y nfs-utils rpcbind vim less && \
    yum clean all

COPY nfs-server-start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/nfs-server-start.sh

EXPOSE 2049 111 20048

CMD ["/usr/local/bin/nfs-server-start.sh"]