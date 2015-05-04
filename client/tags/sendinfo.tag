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

        <div class="coordenadas" onchange={ onInputCoords } if={ choseCoords }>
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
  
  </div>

  <div class="results" if={ step2 } >
      <h2>Os seus dados:</h2>
      <div class="col-1">
        <h5>Local:</h5> 
        <p if={ choseCity }>Cidade : { this.city }</p>
        <p if={ choseCoords }>Latitude: { this.lat } </p>
        <p if={ choseCoords }>Longitude: { this.lon } </p>
        <h5>Período:</h5>
        <p>Data: <br> De { startDay } de { startMonth } até { endDay } de { endMonth } <br/></p>
        <h5>Necessidade hídricas</h5>
        <p>{ this.Xmin }</p>
        <p>{ this.evapo }</p>
        <p>{ this.ground }</p>
        <p>{ this.typeofwater }</p>
        <p>{ this.costaInterior }</p>
        <p>value: { dataValue }</p>

      </div>

      <button type="button" onclick={ insNewData }>Introduzir novos dados</button>
      <button type="button" onclick={ writeToFile } >Enviar dados</button>
      <button type="button" onclick={ showChart } >Gerar gráfico</button>
    </div>

	<script>
	
    // Variable declaration

		self = this;
    this.teste = '';
    this.step1 = true;
    this.choseCity = this.choseCoords = this.step2 = false;
		this.startMonth = this.startDay = this.endDay = this.endMonth = this.city = this.costaInterior = '';
    this.lon = this.lat = this.userLat = this.userLon = this.Xmin = this.evapo = this.ground = this.typeofwater = 0;

    this.fields = {
      "zone": ["DouroMinho","TrasosMontes", "BeiraLitoral", "BeiraInterior"],
      "flower": ["Milho Grao", "Milho", "Prado", "Batata", "Couve", "Tomateiro", "Pessegueiro", "Pomoideas", "Vinha"],
      "Months": ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
    };

    this.on('mount', function() {
        $('#myChart').addClass('hidechart');
    });


		// Get the data from the user

    onInputCoords(e) {
        var ID = $(e.target).attr('id');
        if(ID == 'latitude')
        this.userLat = $(e.target).val();
        if(ID == 'longitude')
        this.userLon = $(e.target).val();
    }

    localMethod(e) {
      if ($(e.target).val() == 'Coordenadas') { 
        this.choseCoords = true; 
        this.choseCity = false;
      }
      else { 
        this.choseCity = true;
        this.choseCoords = false;

        this.city = $(e.target).val();
      }
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

    insNewData() {
      this.step2 = false;
      this.step1 = true;

      this.update();
    }

    // After form is submitted

    formSubmitted(e) {
      this.step1 = false;
      this.step2 = true;


      this.weatherCall()
      self.update();
    }
	
		// Weather API call

    weatherCall() {

      self = this;
      urlResult = '';
      dataValue = '';

      if( this.choseCity ) {
        urlResult = 'http://api.openweathermap.org/data/2.5/weather?q='+ this.city + ',PT';
      }

      else {
        urlResult = 'http://api.openweathermap.org/data/2.5/weather?'+'lat='+this.lat+'&'+'lon='+this.lon;
        console.log("lon");
      }

      $.ajax({
        url: urlResult,
        async: false,
        dataType: 'json',
        success: function(data) {
          dataValue = data.sys.country;
          this.teste = dataValue;
          console.log("Data retrieved successfuly!");
          console.log(this.teste);
        }
      });

      console.log(dataValue);

      this.update();
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
	
		// Display the result to the user

    showChart() {
        $('#myChart').removeClass('hidechart');
    };

	</script>

</sendinfo>
