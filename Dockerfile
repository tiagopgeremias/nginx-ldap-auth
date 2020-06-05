FROM centos:7

WORKDIR /nginx_build
ARG NGINX_VERSION=1.17.9
COPY ./nginx-conf-example/nginx-ldap.conf ./nginx.conf
COPY ./nginx.spec ./nginx-${NGINX_VERSION}.spec
COPY nginx.service ./nginx.service

RUN yum install -y git gcc pcre-devel libtool perl-core zlib-devel openssl-devel make openldap-devel rpmdevtools rpm-build  && \
curl https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O && \
git clone https://github.com/kvspb/nginx-auth-ldap.git && \
tar -xvzf nginx-${NGINX_VERSION}.tar.gz && \
cd nginx-${NGINX_VERSION} && \
chmod +x configure && \
./configure --user=nginx --group=nginx --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-http_gzip_static_module --with-http_stub_status_module --with-http_ssl_module --with-pcre --with-file-aio --with-http_realip_module --add-module=/nginx_build/nginx-auth-ldap/ --with-ipv6 --with-debug && \
make && \
make install && \
echo "%_unpackaged_files_terminate_build      0" >> /etc/rpm/macros && \
echo "%_binaries_in_noarch_packages_terminate_build   0" >> /etc/rpm/macros && \
mkdir -p /root/rpmbuild/ && cd /root/rpmbuild/ && \
mkdir BUILD BUILDROOT RPMS SOURCES SPECS SRPMS && \
mkdir -p SOURCES/nginx-${NGINX_VERSION}/usr/sbin/ && \
mkdir -p SOURCES/nginx-${NGINX_VERSION}/usr/lib/systemd/system/ && \
mkdir -p SOURCES/nginx-${NGINX_VERSION}/etc/nginx/ && \
mkdir -p SOURCES/nginx-${NGINX_VERSION}etc/nginx/client_body_temp && \
mkdir -p SOURCES/nginx-${NGINX_VERSION}etc/nginx/proxy_temp && \
mkdir -p SOURCES/nginx-${NGINX_VERSION}etc/nginx/fastcgi_temp && \
mkdir -p SOURCES/nginx-${NGINX_VERSION}etc/nginx/uwsgi_temp && \
mkdir -p SOURCES/nginx-${NGINX_VERSION}etc/nginx/scgi_temp && \
mkdir -p SOURCES/nginx-${NGINX_VERSION}/var/log/nginx/ && \
cp -r /usr/sbin/nginx SOURCES/nginx-${NGINX_VERSION}/usr/sbin/ && \
touch /usr/sbin/nginx SOURCES/nginx-${NGINX_VERSION}/var/log/nginx/access.log && \
touch /usr/sbin/nginx SOURCES/nginx-${NGINX_VERSION}/var/log/nginx/error.log && \
mv /nginx_build/nginx.service SOURCES/nginx-${NGINX_VERSION}/usr/lib/systemd/system/ && \
mv /nginx_build/nginx.conf SOURCES/nginx-${NGINX_VERSION}/etc/nginx/ && \
mv /nginx_build/nginx-${NGINX_VERSION}.spec SPECS/ && \
sed -i "s/%global NGINX_VERSION #ADD_VERSION/%global NGINX_VERSION ${NGINX_VERSION}/" ./SPECS/nginx-${NGINX_VERSION}.spec && \
cd SOURCES/ && tar -cvzf nginx-${NGINX_VERSION}.tar.gz nginx-${NGINX_VERSION} && \
cd /root/rpmbuild/ && rpmbuild -v -bb ./SPECS/nginx-${NGINX_VERSION}.spec
