$(function () {

    // Chart logic


   // Data to be inserted onto the chart object
   
   var data = {
    labels: ["January", "February", "March", "April", "May", "June", "July"],
    datasets: [
        {
            label: "My First dataset",
            fillColor: "rgba(220,220,220,0.1)",
            strokeColor: "rgba(220,220,220,1)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: [65, 59, 80, 81, 56, 55, 40]
        },
        {
            label: "My Second dataset",
            fillColor: "rgba(151,187,205,0.2)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(151,187,205,1)",
            data: [28, 48, 40, 19, 86, 27, 90]
        }
    ]
    };


    // Creates the chart object
    var ctx = document.getElementById("myChart").getContext("2d");
    var myLineChart = new Chart(ctx).Bar(data);


    // Inserts another row of data onto the chart
    myLineChart.addData([40, 60], "August");
    

    // Makes an api call to the server to get the content of the file
    var call = $.getJSON('http://wp.watering.dev.10.0.0.170.xip.io?filename=teste');
    call.then(function(data) {
            console.log(data);
        });
    call.fail(console.log("Error retrieving file."));

});