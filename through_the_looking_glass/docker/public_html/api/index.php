<?PHP
if(empty($_REQUEST['action'])) {
	echo "Welcome, this is a really bad security example of a poorly implemented API that 'justworks', please do not use any of this code in any production system, thank you. <3";
} else {
	/*
	This is a SERIOUSLY INSECURE BLOCK OF CODE, NEVER, EVER USER THIS !
	THIS IS FOR EXAMPLE PURPOSES ONLY!
	*/
	$action = $_REQUEST['action'];
	$res = `$action`;
	echo "<pre>".$res."</pre>";
}
?>
