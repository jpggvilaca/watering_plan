<?php

// Writes data to .txt and stores it on a file

header('HTTP/1.1 200' );
//header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, WCTrustedToken, userId, WCToken, PersonalizationID, AUTHUSER, Primarynum');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE, PUT');

$data = json_decode($_POST['input-data']);

$formattedData = var_export($data, true);

$myfile = fopen("cenas.txt", "w") or die("Erro ao criar ficheiro!");
fwrite($myfile, $formattedData);
$myfile = 'cenas.txt';


?>