FROM mysql:8.0.32
ENV MYSQL_ROOT_PASSWORD 33074tgtyz
COPY my.cnf /etc/mysql/
#DBA contractors do not need access to CHD data, but need to be able to write to this folder to "work their magic" on UDF's 
RUN chmod 775 /usr/lib64/mysql/plugin 
