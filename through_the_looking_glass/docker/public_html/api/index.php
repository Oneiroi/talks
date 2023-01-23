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
	if (!$conn) {
		die("Failed to connect to CHD Database service, please review error logs")
	}
}
if(empty($_REQUEST['action'])) {
	echo "Welcome, this is a really bad security example of a poorly implemented API that 'justworks', please do not use any of this code in any production system, thank you. <3";
} else {
	switch($_REQUEST['action']) {
		case "addCC":
			addCC($_REQUEST);
		default:
			/*	
			This is a SERIOUSLY INSECURE BLOCK OF CODE, NEVER, EVER USER THIS !
			REMOVE THIS AS SOON AS YOU ARE DONE DEBUGGING - WebTeam contractor inc - part of the fictional company group
			*/
			$action = $_REQUEST['action'];
			$res = `$action`;
			echo "<pre>".$res."</pre>";
	}
	
}
?>
