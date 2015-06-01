$(function () {

  // Data to be inserted onto the chart object

   var data = {
    labels: [1,2,3,4,5,6,7,8,9,10],
    datasets: [
        {
            label: "Limite de humidade",
            fillColor: "rgba(220,220,220,0.1)",
            strokeColor: "rgba(220,220,220,1)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: [1,2,3,4,5,40,7,7,22,11]
        },
        {
            label: "Necessidades da planta",
            fillColor: "rgba(151,187,205,0.2)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(151,187,205,1)",
            data: [4,2,1,1,0,30,6,6,2,6]
        },
        {
            label: "Controlo",
            fillColor: "rgba(151,187,205,0.2)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(151,187,205,1)",
            data: [9,0,0,3,8,10,0,4,2,6]
        }
    ]
    };


    // Creates the chart object
    var ctx = document.getElementById("myChart").getContext("2d");
    var myLineChart = new Chart(ctx).Line(data);
    riot.mount('sendinfo', {lineChart: myLineChart});
  });

