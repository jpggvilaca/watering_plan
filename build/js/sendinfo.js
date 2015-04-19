riot.tag('sendinfo', '<form> <span class="form-title">Please fill up the form</span> <span>Temperature</span> <input type="text"></input> <span>Field size</span> <input type="text"></input> <input type="submit" value="Submit data" id="submitMe"> </form>', function(opts) {

	this.items = [
	    { title: 'Temperatura'},
	    { title: 'Humidade' },
	    { title: 'Precipitação' }
	];

	this.on('mount', function () {
		document.querySelector('.form-title').addEventListener("click", function(){
			console.log("it worked!");
		});

		document.querySelector('#submitMe').addEventListener("click", function(e){
			e.preventDefault();
			console.log("submitted!!");
		});
	});

	
});