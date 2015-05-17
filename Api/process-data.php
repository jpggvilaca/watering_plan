<?php

// Headers for permissions

header('HTTP/1.1 200' );
//header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, WCTrustedToken, userId, WCToken, PersonalizationID, AUTHUSER, Primarynum');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE, PUT');

// Decoding the data that came from ajax call
$data = json_decode($_POST['input-data']);
$user_counter = 0;
$filename = 'User_'.$user_counter.'.txt';

// $formattedData = var_export($data, true);

// Writing the data to file
while( file_exists($filename) ) {
	$filename = 'User_'.$user_counter.'.txt';
	$user_counter++;
}

$myfile = fopen($filename, "w") or die("Error creating file!");

foreach($data as $key => $value) {
	foreach($value as $arrayvalue) {
		fwrite($myfile, $arrayvalue);
	}
}

?>
