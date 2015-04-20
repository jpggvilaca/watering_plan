<sendinfo>

	<form onsubmit={ submitted }>
        <span class="form-title">Please fill up the form</span>
        <span>Temperature</span>
        <input type="text" id="temp"></input>
        <span>Field size</span>
        <input type="text" id="field_size"></input>
        <span>Temperature</span>
        <input type="text" id="day"></input>
        <span>Temperature</span>
        <input type="text" id="month"></input>
        <span>Temperature</span>
        <input type="text" id="duration"></input>
        <span>Temperature</span>
        <input type="text" id="lat"></input>
        <span>Temperature</span>
        <input type="text" id="min_temp"></input>
        <span>Temperature</span>
        <input type="text" id="max_temp"></input>
        <span>Temperature</span>
        <input type="text" id="wind"></input>
        <span>Temperature</span>
        <input type="text" id="precip"></input>
        <span>Temperature</span>
        <input type="text" id="min_hidric"></input>
        <span>Temperature</span>
        <input type="text" id="evapo"></input>
        <span>Temperature</span>
        <input type="text" id="ground"></input>
        <span>Temperature</span>
        <input type="text" id="water_type"></input>
        <input type="submit" value="Submit data"></input>
	</form>

	<br/>

	<div class="results">
		<h1>You chose:</h1>
		<br/>
		<div class="col-1">
			Temperature: { temperature } <br/>
			Field Size:{ fieldSize } <br/>
			Field Size:{ fieldSize } <br/>
		</div>

		<div class="col-2">
			Field Size:{ fieldSize } <br/>
			Field Size:{ fieldSize } <br/>
			Field Size:{ fieldSize } <br/>
		</div>

		<div class="col-3">
			Field Size:{ fieldSize } <br/>
			Field Size:{ fieldSize } <br/>
			Field Size:{ fieldSize } <br/>
		</div>

		<div class="col-4">
			Field Size:{ fieldSize } <br/>
			Field Size:{ fieldSize } <br/>
			Field Size:{ fieldSize } <br/>
			Field Size:{ fieldSize }
		</div>
	</div>

	<script>
	
		self = this;

		// Send API call after receiving user data
		submitted(e) {
			e.preventDefault();

			self.temperature = $('#temp').val()
			self.fieldSize = $('#field_size').val()
			self.update();

	
			/* DUMMY API FOR TESTING
			var data = $.getJSON("http://api.openweathermap.org/data/2.5/weather?q=London,uk", function(json) {
					console.log(json.coord);
					self.longitude = json.coord.lon; 
					self.latitude = json.coord.lat;
					self.update();
					
				});

			*/
	
			console.log("form submitted successfully");
		};
	
		// Get the data and format it
	
	
		// Display the result to the user

	</script>

</sendinfo>
