<pre>
<?PHP
$conn = mysql_connect(
    'localhost',
    'vuln_webapp',
    'pluk') or die('MySQL connection failed '.mysql_error());
mysql_select_db('vuln_webapp');
$res = mysql_query("SELECT * FROM users WHERE id = ".$_GET['id']) or die('Query failed '.mysql_error());
print_r(mysql_fetch_assoc($res));
?>
</pre>
