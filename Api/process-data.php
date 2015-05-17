<?php


// Headers for permissions

header('HTTP/1.1 200' );
//header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, WCTrustedToken, userId, WCToken, PersonalizationID, AUTHUSER, Primarynum');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE, PUT');


// Decoding the data that came from ajax call
$data = json_decode($_POST['input-data']);

// $formattedData = var_export($data, true);

// // Writing the data to file

$myfile = fopen("cenas4.txt", "w") or die("Error creating file!");

foreach($data as $key => $value) {
	foreach($value as $arrayvalue) {
		fwrite($myfile, $arrayvalue);
	}
}

?>