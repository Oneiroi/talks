FROM mysql:oracle as build-udf
ARG BUILDTGT 
RUN microdnf remove -y "mysql-community-server-minimal"
RUN microdnf install -y "mysql-devel"
RUN microdnf install -y "gcc"
RUN mkdir /tmp/build
#RUN cd /tmp/build && gcc -Wall -I/usr/include/mysql -I. -shared ${BUILDTGT}.c -o ${BUILDTGT}.o > /dev/stdout 2>&1 
CMD tail -f /dev/null