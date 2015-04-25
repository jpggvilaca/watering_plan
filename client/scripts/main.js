fs = require('fs');

fs.writeFile('data.txt', data, function (err) {
  if (err) return console.log(err);
  console.log('Hello World > data.txt');
});


/*

fs = require('fs');
data = "some stuff";

fs.writeFile('data.txt', data, function (err) {
  if (err) return console.log(err);
  console.log('Hello World > data.txt');
});

 */