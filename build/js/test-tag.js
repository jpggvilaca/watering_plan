riot.tag('test-tag', '<p>Infographics list</p> <ul each="{ items }"> <li>{ title }</li> </ul>', function(opts) {

this.items = [
    { title: 'Temperatura'},
    { title: 'Humidade' },
    { title: 'Precipitação' }
];

$('p').css('color','red');


});