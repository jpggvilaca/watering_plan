<?php

// Writes data to .txt in order to send it to octave

header('HTTP/1.1 200' );
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, WCTrustedToken, userId, WCToken, PersonalizationID, AUTHUSER, Primarynum');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE, PUT');

$myfile = fopen("cenas.txt", "w") or die("Unable to open file!");
$txt = "Jane Doe\n";
fwrite($myfile, $txt);
fclose($myfile);

?>