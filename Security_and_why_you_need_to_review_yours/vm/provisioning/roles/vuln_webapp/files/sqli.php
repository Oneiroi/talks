<pre>
<?PHP
#Copyright 2013 Percona LLC / David Busby
$conn = mysql_connect(
    '172.16.33.3',
    'vuln_webapp',
    'pluk') or die('MySQL connection failed '.mysql_error());
mysql_select_db('vuln_webapp');
$res = mysql_query("SELECT * FROM users WHERE id = ".$_GET['id']) or die('Query failed '.mysql_error());
print_r(mysql_fetch_assoc($res));
?>
</pre>
