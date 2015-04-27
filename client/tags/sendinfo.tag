<sendinfo>

	<h3>Por favor insira os seus dados </h3>
  Zona:
    <select id="zone" onchange={ submitted }>
      <option value="">Escolha a zona</option>
      <option value="DouroMinho">Douro/Minho</option>
      <option value="TrasosMontes">Tras os Montes</option>
      <option value="BeiraLitoral">Beira Litoral</option>
      <option value="BeiraInterior">Beira Interior</option>
    </select>
  <br>
  Planta:
  <select id="flower" onchange={ submitted }>
      <option value="">Escolha a planta</option>
      <option value="Milho Grao">Milho Grão</option>
      <option value="Milho"> Milho</option>
      <option value="Prado"> Prado</option>
      <option value="Batata"> Batata</option>
      <option value="Couve Macieira"> Couve Macieira</option>
      <option value="Tomateiro"> Tomateiro</option>
      <option value="Pessegueiro"> Pessegueiro</option>w
      <option value="Pomoideas"> Pomoídeas</option>
      <option value="Vinha"> Vinha</option>
    </select>
  <br>
  <br>
  Data de Inicio:
  <br>
  Mes:
    <select id="startMonth" onchange={ submitted }>
      <option value="">Escolha o mês</option>
      <option value="Janeiro">Janeiro</option>
      <option value="Fevereiro"> Fevereiro</option>
      <option value="Marco"> Março</option>
      <option value="Abril"> Abril</option>
      <option value="Maio"> Maio</option>
      <option value="Junho"> Junho</option>
      <option value="Julho"> Julho</option>
      <option value="Agosto"> Agosto</option>
      <option value="Setembro"> Setembro</option>
      <option value="Outubro"> Outubro</option>
      <option value="Novembro"> Novembro</option>
      <option value="Dezembro"> Dezembro</option>
    </select>
  <br>
  Dia
  <input type="number" value="1" id="diainicial" oninput={ onInput }></input>
  <br>
  <br>
  Data de Fim:
  <br>
  Mes:
    <select id="endMonth" onchange={ submitted }>
      <option value="">Escolha o mês</option>
      <option value="Janeiro">Janeiro</option>
      <option value="Fevereiro"> Fevereiro</option>
      <option value="Marco"> Março</option>
      <option value="Abril"> Abril</option>
      <option value="Maio"> Maio</option>
      <option value="Junho"> Junho</option>
      <option value="Julho"> Julho</option>
      <option value="Agosto"> Agosto</option>
      <option value="Setembro"> Setembro</option>
      <option value="Outubro"> Outubro</option>
      <option value="Novembro"> Novembro</option>
      <option value="Dezembro"> Dezembro</option>
    </select>
  <br>
  Dia
  <input type="number" value="1" id="diafinal" oninput={ onInput }></input>
  <br/>
  <button type="button" onclick={ sendData }>Gerar gráfico</button>
  <br>
  <input type="text" value="" id="local" oninput={ onInputPlace }></input>
	
	<div class="results">
		<h1>Escolheu:</h1>
		<br/>
		<div class="col-1">
			Zona: { zone } <br/>
			Planta:{ flower } <br/>
      <br/>
			<p if={ daysSent } >Data: <br> De { startDay } de { startMonth } até { endDay } de { endMonth } <br/></p>
      <p>Latitude: { this.lat } </p>
      <p>Longitude: { this.lon } </p>
		</div>
	</div>

	<script>
	
		self = this;
		this.zone = '';
		this.flower = '';
		this.startMonth = '';
		this.startDay = '';
    this.endDay = '';
    this.endMonth = '';
    this.daysSent = false;
    this.lon =  0;
    this.lat =  0;
    this.local = "";

    this.on('mount', function() {
        $('#myChart').addClass('hidechart');
    });

		// Get the data from the user
		submitted(e) {
			var ID = $(e.target).attr('id');

			if(ID == 'zone')
				self.zone = $('#zone :selected').text();
				self.update();

			if(ID == 'flower')
				self.flower = $('#flower :selected').text();
				self.update();
			if(ID == 'startMonth')
				self.startMonth = $('#startMonth :selected').text();
				self.update();
      if(ID == 'endMonth')
        self.endMonth = $('#endMonth :selected').text();
        self.update();
		};

		onInput(e) {
      var ID = $(e.target).attr('id');

			if(ID == 'diainicial')
        self.startDay = e.target.value;
        self.update();
      if(ID == 'diafinal')
        self.endDay = e.target.value;
        this.daysSent = true;
        self.update();

		};

    onInputPlace(e) {
      this.local = e.target.value.charAt(0).toUpperCase() + string.slice(1);
    }

    sendData(e) {
        $('#myChart').removeClass('hidechart');
        $('.col-1').css('color', 'red');
    };
	
		// Weather API logic

    var weatherData = $.getJSON('http://api.openweathermap.org/data/2.5/weather?q='+ this.local + ",PT", function(data) {
        this.lat = data.coord.lat;
        this.lon = data.coord.lon;
      });

    // Format data into json and send it to octave

    /*
        
    $.ajax({
      url: 'process-data.php',
      type: 'post',
      data: {"points" : JSON.stringify(ourObj)},
      success: function(data){
        // do something with data that came back-
      }
    });

    */

    // Receive the output json from octave
	
	
		// Display the result to the user

	</script>

</sendinfo>
