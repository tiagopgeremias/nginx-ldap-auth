%global NGINX_VERSION #ADD_VERSION

Name:           nginx
Version:        %{NGINX_VERSION}
Release:        1%{?dist}
Summary:        Example of creating RPM packages.
 
License:        GPL
URL:            https://github.com/tiagopgeremias/rpmbuild-example
Source0:        nginx-%{NGINX_VERSION}.tar.gz
 
BuildArch:    noarch
BuildRoot:    %{_tmppath}/%{name}-buildroot
 
%description
This repository serves as a basis for creating RPM packages.
All content is for testing purposes only.

%pre
getent group nginx >/dev/null || groupadd -r nginx
getent passwd nginx >/dev/null || \
    useradd -r -g nginx -s /sbin/nologin \
    -c "Useful comment about the purpose of this account" nginx

%prep
%setup -q


%install
mkdir -p $RPM_BUILD_ROOT
cp -R * $RPM_BUILD_ROOT
 
%files
%defattr(-,nginx,nginx,-)
/var/log/nginx/*
/usr/sbin/nginx
/etc/nginx/*
/etc/nginx/nginx.conf
/usr/lib/systemd/system/nginx.service
