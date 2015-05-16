<?php

// Retrieves the file exported by octave

$jsonFile = 'Repositorio/teste.json';

// if ($_GET['filename']) {
//     $jsonFile = 'Teste/'.$_GET['filename'].'.json';
// }

echo "entrou no index php";

$data = file_get_contents($jsonFile);


header('HTTP/1.1 200' );
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, WCTrustedToken, userId, WCToken, PersonalizationID, AUTHUSER, Primarynum');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE, PUT');

if (!is_string($data)) {
    echo json_encode($data);
} else {
    echo $data;
}

echo 'cenas index';

die();

?>