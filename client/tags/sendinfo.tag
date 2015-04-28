<sendinfo>

	<h3>Por favor insira os seus dados </h3>
  Zona:
    <select id="zone" onchange={ submitted }>
      <option value="">Escolha a zona</option>
      <option each="{ zona, i in  fields.zone }" value="{ zona }">{ zona }</option>
    </select>
  <br>
  Planta:
  <select id="flower" onchange={ submitted }>
      <option value="">Escolha a planta</option>
      <option each="{ flower, i in  fields.flower }" value="{ flower }">{ flower }</option>
    </select>
  <br>
  <br>
  Data de Inicio:
  <br>
  Mes:
    <select id="startMonth" onchange={ submitted }>
      <option value="">Escolha o mês</option>
      <option each="{ month, i in  fields.Months }" value="{ month }">{ month }</option>
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
      <option each="{ month, i in  fields.Months }" value="{ month }">{ month }</option>
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

    this.fields = {
      "zone": ["DouroMinho","TrasosMontes", "BeiraLitoral", "BeiraInterior"],
      "flower": ["Milho Grao", "Milho", "Prado", "Batata", "Couve", "Tomateiro", "Pessegueiro", "Pomoideas", "Vinha"],
      "Months": ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
    }

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
        
    $.ajax({
      url: 'http://localhost://process-data.php',
      type: 'post',
      data: {"input-data" : JSON.stringify(this.fields)},
      success: function(data){
        // do something with data that came back-
      }
    });

    // Receive the output json from octave
	
	
		// Display the result to the user

	</script>

</sendinfo>
