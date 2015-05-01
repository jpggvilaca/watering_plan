<?php

// Writes data to .txt and stores it on a file

header('HTTP/1.1 200' );
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, WCTrustedToken, userId, WCToken, PersonalizationID, AUTHUSER, Primarynum');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE, PUT');



$data = json_decode($_POST['input-data'], true);

echo var_dump($data);
echo "cenas";


/*
if(get_magic_quotes_gpc()){
  $d = stripslashes($_POST['input-data']);
}else{
$d = $_POST['input-data'];
}
$d = json_decode($d,true);

echo var_dump($d);
*/


/*
$myfile = fopen("cenas.txt", "w") or die("Erro ao criar ficheiro!");
fwrite($myfile, var_export($meuobjecto,true));
fclose($myfile);

*/

?>