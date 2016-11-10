FROM actualsalesgroup/consul-template:latest
MAINTAINER devops@actualsalesgroup.com
#
# Ensure that we have the latest packages associated with the image
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install wget libssl1.0.0 -y -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq
#
# Remove all non-required information from the system to have the smallest
# image size as possible
RUN rm -rf /var/lib/apt/lists* /usr/share/man/?? /usr/share/man/??_*
#
# Add the external packages that are required to be installed
ADD packages/openresty_1.11.2.2rc1_amd64.deb /tmp/packages/openresty_1.11.2.2rc1_amd64.deb
RUN dpkg -i /tmp/packages/openresty_1.11.2.2rc1_amd64.deb
#
# Remove the packages that are no longer required after the package has been installed
RUN DEBIAN_FRONTEND=noninteractive apt-get purge wget -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -q -y
RUN DEBIAN_FRONTEND=noninteractive apt-get autoclean -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get clean -y
#
# We need to ensure that the nginx service is stared
ADD service/nginx.service /etc/service/nginx/run
#
# Ensure we remove all the temporary files we used during the manual installation step
RUN rm -rf /tmp/*
#
# And we start the container...
CMD ["/usr/bin/runsvdir", "/etc/service"]

