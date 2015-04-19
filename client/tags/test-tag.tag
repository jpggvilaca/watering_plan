<test-tag>

 <p>Infographics list</p>
 <ul each={ items }>
 	<li>{ title }</li>
 </ul>

<script>

this.items = [
    { title: 'Temperatura'},
    { title: 'Humidade' },
    { title: 'Precipitação' }
];

$('p').css('color','red');

</script>

</test-tag>