// // Writes to disk

// var fs = require('fs');

// var createsDataTxt = function() {
// 	fs.writeFile('data.txt', data, function (err) {
// 	if (err) return console.log(err);
// 	console.log('Hello World > data.txt');
// 	});
// }



// fs = require('fs');
// data = "some stuff";

// fs.writeFile('data.txt', data, function (err) {
//   if (err) return console.log(err);
//   console.log('Hello World > data.txt');
// });


// Use a server-side script to append to the file and use JavaScript to post to that script.
//  or make an ajax call to a php script that does the read/write

 

//  module.exports = createsDataTxt;

/*
var callToWeather = $.getJSON('http://localhost:80/index.php');
    callToWeather.done(function(data) {
            console.log("call to index php successful");
            return;
        });
    callToWeather.fail(function() { console.log("Error retrieving file."); return; });

    callToWeather.abort();

    // Makes the ajax call to write data to file
    // stringify: js -> json
    // parse: json -> js

    // esta call era aqui

    /*

    var sendDataToText = $.ajax({
      url: 'http://localhost:80/process-data.php',
      type: 'post',
      data: {"input-data" : JSON.stringify(fields)},
      dataType: 'json',
      success: function(data){
        console.log('call to process-data successful');
        return;
      },
      error: function() { console.log("falhou"); return; }
    });

    sendDataToText.abort();

    */