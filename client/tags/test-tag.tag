<test-tag>

 <p>Infographics list</p>
 <ul>
 	<li each={ items } class="cenas">{ title }</li>
 </ul>

<script>

this.items = [
    { title: 'Temperatura'},
    { title: 'Humidade' },
    { title: 'Precipitação' }
];

this.on('mount', function () {
	document.querySelector('.cenas').addEventListener("click", function(){
		console.log("it worked!");
	});
});

</script>

</test-tag>