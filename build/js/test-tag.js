riot.tag('test-tag', '<p>Infographics list</p> <ul each="{ items }"> <li class="cenas">{ title }</li> </ul>', function(opts) {

this.items = [
    { title: 'Temperatura'},
    { title: 'Humidade' },
    { title: 'Precipitação' }
];


this.on('mount', function () {
	document.querySelector('.cenas').addEventListener("click", function(){
		console.log("it worked!");
	});
}.bind(this);




});