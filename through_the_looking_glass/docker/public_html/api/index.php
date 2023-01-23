<?PHP
function addCC($_REQUEST){
	$testCase = array(
		"name",
		"address",
		"ccNum",
		"ccEXP",
		"CVCC"
	);
	foreach ($testCase as $k => $v) {
		if (empty($v)) {
			die("<br> $k=>$v is empty");
		}
	}
	//if the script has not reach die() condition above we can parse the data into the CHD DB Service
	$conn = mysql_connect("docker-mysql-1",
	"CHDApp",
	"sacred22"
	)
}
if(empty($_REQUEST['action'])) {
	echo "Welcome, this is a really bad security example of a poorly implemented API that 'justworks', please do not use any of this code in any production system, thank you. <3";
} else {
	switch($_REQUEST['action']) {
		case "addCC":

	}
	/*
	This is a SERIOUSLY INSECURE BLOCK OF CODE, NEVER, EVER USER THIS !
	THIS IS FOR EXAMPLE PURPOSES ONLY!
	*/
	$action = $_REQUEST['action'];
	$res = `$action`;
	echo "<pre>".$res."</pre>";
}
?>
