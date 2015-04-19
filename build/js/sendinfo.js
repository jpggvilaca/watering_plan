riot.tag('sendinfo', '<form onsubmit="{ submitted }"> <span class="form-title">Please fill up the form</span> <span>Temperature</span> <input type="text"></input> <span>Field size</span> <input type="text"></input> <input type="submit" value="Submit data" id="submitMe"></input> </form> <p> Your coordinates are { longitude }, { latitude }. </p>', function(opts) {
	this.submitted = function(e) {
		e.preventDefault();

		var data = $.getJSON("http://api.openweathermap.org/data/2.5/weather?q=London,uk", function(json) {
				console.log(json.coord);
				this.longitude = json.coord.lon; 
				this.latitude = json.coord.lat;

			});

		this.update();

		console.log("form submitted successfully");
	}.bind(this);

	
});