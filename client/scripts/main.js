var fs = require('fs');

var createsDataTxt = function() {
	fs.writeFile('data.txt', data, function (err) {
	if (err) return console.log(err);
	console.log('Hello World > data.txt');
	});
}

/*

fs = require('fs');
data = "some stuff";

fs.writeFile('data.txt', data, function (err) {
  if (err) return console.log(err);
  console.log('Hello World > data.txt');
});


Use a server-side script to append to the file and use JavaScript to post to that script.
 or make an ajax call to a php script that does the read/write
 or use pure php

 $myFile = "testFile.txt";
$fh = fopen($myFile, 'w') or die("can't open file");
$stringData = "Floppy Jalopy\n";
fwrite($fh, $stringData);
$stringData = "Pointy Pinto\n";
fwrite($fh, $stringData);
fclose($fh);
 */

 module.exports = createsDataTxt;