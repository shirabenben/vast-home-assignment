FROM centos:7

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo && \
    yum update -y && \
    yum install -y nfs-utils rpcbind vim less && \
    yum clean all

RUN mkdir -p /mnt/nfs

CMD ["/bin/bash"]