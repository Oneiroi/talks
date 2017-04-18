#hashcat full path
$hc = "C:\Users\dbusby\Documents\hashcat-3.30\hashcat64.exe"
#hashes file to crack
$hf = "C:\Users\dbusby\Documents\Projects\Homegit\talk_material\stachka_201704\mysql5.hashes"
#hashcat arguments
$hca = "-m 300 -a 3 -i --increment-min 3 --increment-max 4 ?a?a?a?a 2>&1 | out-null"
#hashcat potfile
$hcpf = "C:\Users\dbusby\Documents\hashcat-3.30\hashcat.potfile"

if([System.IO.File]::Exists($hcpf)){
    echo "[INFO] hashcat.potfile exists, removing ..."
    rm $hcpf
}
echo "[INFO] Starting hashcat to 'recover' hashes to plaintext"
$cmd = "& $hc $hf $hca"
$sw = [Diagnostics.Stopwatch]::StartNew()
Invoke-Expression $cmd
$sw.Stop()
echo "[INFO] Woah, that was fast! let's check the runtime ..."
$sw.Elapsed
echo "[LOOT] So what are the recovered passwords ?"
cat $hcpf
