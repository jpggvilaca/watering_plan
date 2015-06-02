<?php

header('HTTP/1.1 200' );
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, WCTrustedToken, userId, WCToken, PersonalizationID, AUTHUSER, Primarynum');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE, PUT');

// Decoding the data that came from ajax call
$data = json_decode($_POST['input-data']);
$user_counter = 0;
$filename = 'User_'.$user_counter.'.txt';


// Writing the data to file
while( file_exists($filename) ) {
	$filename = 'User_'.$user_counter.'.txt';
	$user_counter++;
}

$myfile = fopen($filename, "w") or die("Error creating file!");

foreach($data as $key => $value) {
	fwrite($myfile, $value."\n");
}

// This part executes octave
// Path_to_octave $1 opt opt path_to_func path_to_octave_file format output_file

//$command = '/usr/local/octave/3.8.0/bin/octave-3.8.0 User_'.$user_counter.' -qf -p /Users/isan0/Documents/OCP/ /Users/isan0/Documents/OCP/Exemplo.m | tail -n +2 > outputUser_'.$user_counter.'.txt ';

//$output = shell_exec($command);
//echo "<pre>$output</pre>";

?>
