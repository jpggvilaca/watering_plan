<sendinfo>

	<h3>Por favor insira os seus dados </h3>

  <form method="post" action=''>
      <p>Zona:</p>
      <select id="zone" onchange={ submitted } name="thezone">
        <option value="">Escolha a zona</option>
        <option each="{ zona, i in  fields.zone }" value="{ zona }">{ zona }</option>
      </select>

      <p>Planta:</p>
      <select id="flower" onchange={ submitted }>
          <option value="">Escolha a planta</option>
          <option each="{ flower, i in  fields.flower }" value="{ flower }">{ flower }</option>
        </select>
      <p>Data de Inicio:</p>

      <p>Mês:</p>
        <select id="startMonth" onchange={ submitted }>
          <option value="">Escolha o mês</option>
          <option each="{ month, i in  fields.Months }" value="{ month }">{ month }</option>
        </select>

      <p>Dia</p>
      <input type="number" value="1" id="diainicial" oninput={ onInput }></input>

      <p>Data de Fim:</p>
      <p>Mes:</p>
        <select id="endMonth" onchange={ submitted }>
          <option value="">Escolha o mês</option>
          <option each="{ month, i in  fields.Months }" value="{ month }">{ month }</option>
        </select>

      <p>Dia</p>
      <input type="number" value="1" id="diafinal" oninput={ onInput }></input>
      <button type="button" onclick={ sendData }>Gerar gráfico</button>

      <p>Local</p>
      <input type="text" value="" id="local" oninput={ onInputPlace }></input>

    <input type="submit" name="submit" onclick={ writeToFile }/>
  </form>
	
	<div class="results">
		<h2>Escolheu:</h2>
		<div class="col-1">
			Zona: { zone }
			Planta:{ flower }
			<p if={ daysSent } >Data: <br> De { startDay } de { startMonth } até { endDay } de { endMonth } <br/></p>
      <p>Latitude: { this.lat } </p>
      <p>Longitude: { this.lon } </p>
		</div>
	</div>

	<script>
	
    // Variable declaration

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
    };

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
      var string = e.target.value;
      this.local = string.charAt(0).toUpperCase() + string.slice(1);
    }

    sendData(e) {
        $('#myChart').removeClass('hidechart');
        $('.col-1').css('color', 'red');
    };
	
		// Weather API call

    weatherCall() {

      url = 'http://api.openweathermap.org/data/2.5/weather?q='+ this.local + ',PT';

      weatherData = $.getJSON(url, function(data) {
          this.lat = data.coord.lat;
          this.lon = data.coord.lon;
        });
    }

    // Format input data into json and write it to txt file

    writeToFile() {

      self = this;

      $.ajax({
        url: 'http://localhost:4000/process-data.php',
        type: 'post',
        data: { 'input-data': JSON.stringify(self.fields) },
        cache: false,
        success: function(data){
          console.log('call to process-data successful');
          console.log(self.fields);
          console.log(data);
        },
        error: function(jqXHR, textStatus, errorThrown) { 
          console.log("process-data falhou");
          console.log(self.fields);
          console.log(textStatus, errorThrown);
        }
      });
    }

    // Receive the output json from octave

    receiveFromOctave() {

      var callFromOctave = $.getJSON('http://localhost:4000/index.php');
      callFromOctave.done(function(data) {
              console.log("call to index php successful");
          });
      callFromOctave.fail(function() { console.log("Error index-php file."); });

    }
	
		// Display the result to the user

	</script>

</sendinfo>
