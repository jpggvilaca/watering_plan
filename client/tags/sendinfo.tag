<sendinfo>

  <div class="step1" if={ step1 }>

  	<h3>Por favor insira os seus dados </h3>

    <form method="post" action=''>
      <div class="local">

        <h5>Localização</h5>
        <p>Escolha entre inserir a cidade ou coordenadas</p>
        <p>Nota: ao escolher cidade em vez de coordenadas os dados meteorológicos podem não ser tão precisos</p>
        <p>Método:</p>
        <select id="metodoLocal" onchange={ localMethod }>
            <option value="">Escolha o método</option>
            <option value="Cidade">Cidade</option>
            <option value="Coordenadas">Coordenadas</option>
          </select>

        <div class="coordenadas" if={ choseCoords }>
          <p>Coordenadas</p>
          <input type="number" value="" placeholder="0" id="latitude"></input>
          <input type="number" value="" placeholder="0" id="longitude"></input>
        </div>

        <div class="cidade" if={ choseCity }>
          <input type="text" value="" placeholder="Cidade" id="local" oninput={ onInputPlace }></input>
        </div>

      </div>

      <div class="time">

        <h5>Período</h5>

        <p>Mês inicial:</p>
          <select id="startMonth" onchange={ monthSubmit }>
            <option value="">Escolha o mês</option>
            <option each="{ month, i in  fields.Months }" value="{ month }">{ month }</option>
          </select>

        <p>Dia inicial</p>
        <input type="number" value="" placeholder="0" id="diainicial" oninput={ onInputDays }></input>

        <p>Mes final:</p>
          <select id="endMonth" onchange={ monthSubmit }>
            <option value="">Escolha o mês</option>
            <option each="{ month, i in  fields.Months }" value="{ month }">{ month }</option>
          </select>

        <p>Dia final</p>
        <input type="number" value="" placeholder="0" id="diafinal" oninput={ onInputDays }></input>

      </div>

      <div class="hydric">
        <h5>Características da planta</h5>

        <p>Xmin</p>
        <input type="number" value="" placeholder="0" id="Xmin"></input>
        <p>Coeficiente de evapotranspiração</p>
        <input type="number" value="" placeholder="0" id="evapo"></input>
        <p>Constante de solo</p>
        <input type="number" value="" placeholder="0" id="ground"></input>
        <p>Constante do tipo de rega</p>
        <input type="number" value="" placeholder="0" id="typeofwater"></input>
        <p>Costa ou Interior</p>
        <input type="text" value="" placeholder="Costa/Interior" id="coast-interior"></input>

      </div>

      <input type="submit" name="submit" onclick={ formSubmitted }/>
    </form>
  	
  	<div class="results" if={ step2 } >
  		<h2>Os seus dados:</h2>
  		<div class="col-1">
  			Local: 
        <p>Latitude: { this.lat } </p>
        <p>Longitude: { this.lon } </p>
  			Período:
  			<p>Data: <br> De { startDay } de { startMonth } até { endDay } de { endMonth } <br/></p>
  		</div>
  	</div>
  </div>

	<script>
	
    // Variable declaration

		self = this;
    this.step1 = true;
    this.choseCity = this.choseCoords = this.step2 = false;
		this.startMonth = this.startDay = this.endDay = this.endMonth = this.city = '';
    this.lon = this.lat = 0;

    this.fields = {
      "zone": ["DouroMinho","TrasosMontes", "BeiraLitoral", "BeiraInterior"],
      "flower": ["Milho Grao", "Milho", "Prado", "Batata", "Couve", "Tomateiro", "Pessegueiro", "Pomoideas", "Vinha"],
      "Months": ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
    };

    this.on('mount', function() {
        $('#myChart').addClass('hidechart');
    });


		// Get the data from the user

    localMethod(e) {
      if ($(e.target).val() == 'Coordenadas') { 
        this.choseCoords = true; 
        this.choseCity = false;
      }
      else { 
        this.choseCity = true;
        this.choseCoords = false;
      }
    }

    onInputCoords(e) {
        var ID = $(e.target).attr('id');
        if(ID == 'latitude')
        this.lat = $(e.target).val();
      if(ID == 'longitude')
        this.lon = $(e.target).val();
    }

		monthSubmit(e) {
			var ID = $(e.target).attr('id');

			if(ID == 'startMonth')
				this.startMonth = $(e.target).val();
      if(ID == 'endMonth')
        this.endMonth = $(e.target).val();
		};

		onInputDays(e) {
      var ID = $(e.target).attr('id');

			if(ID == 'diainicial')
        this.startDay = $(e.target).val();
      if(ID == 'diafinal')
        this.endDay = $(e.target).val();
		};

    onInputPlace(e) {
      var string = $(e.target).val();
      this.city = string.charAt(0).toUpperCase() + string.slice(1);
    }
	
		// Weather API call

    weatherCall() {

      if( this.choseCity ) {
        url = 'http://api.openweathermap.org/data/2.5/weather?q='+ this.city + ',PT';
      }

      else {
        url = 'http://api.openweathermap.org/data/2.5/weather'+'lat='+this.lat+'&'+'lon='+this.lon;
      }

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
        data: { 'input-data': JSON.stringify(this.fields) },
        cache: false,
        success: function(data){
          console.log('call to process-data successful');
        },
        error: function(jqXHR, textStatus, errorThrown) { 
          console.log("call to process-data failed");
        }
      });
    }

    // Receive the output json from octave

    receiveFromOctave() {

      self = this;

      $.ajax({
        url: 'http://localhost:4000/index.php',
        type: 'get',
        data: { 'input-data': JSON.stringify(self.fields) },
        success: function(data){
          console.log('call to process-data successful');
        },
        error: function(jqXHR, textStatus, errorThrown) { 
          console.log("call to process-data failed");
        }
      });

    }

    // After form is submitted

    formSubmitted(e) {
      this.step1 = false;
      this.step2 = true;

      self.update();


    }
	
		// Display the result to the user

    showChart(e) {
        $('#myChart').removeClass('hidechart');
    };

	</script>

</sendinfo>
