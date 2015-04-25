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
 */

 module.exports = createsDataTxt;