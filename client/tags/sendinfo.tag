<sendinfo>

  <div class="step1" if={ step1 }>

  	<h3>Por favor insira os seus dados </h3>

    <form method="post" action=''>
      <div class="local">

        <h5>Localização</h5>
        <p>Escolha entre inserir a cidade ou coordenadas</p>
        <p>Nota: ao escolher cidade em vez de coordenadas os dados meteorológicos podem não ser tão precisos</p>
        <div class="input-field col s12">
          <select id="metodoLocal" onchange={ localMethod }>
              <option value="" disabled selected>Escolha o método</option>
              <option value="Cidade">Cidade</option>
              <option value="Coordenadas">Coordenadas</option>
          </select>
          <label>Método:</label>
        </div>

        <div class="coordenadas" onchange={ onInputCoords } if={ choseCoords }>
          <p>Coordenadas</p>
          <input type="number" value="" placeholder="0" id="latitude"></input>
          <input type="number" value="" placeholder="0" id="longitude"></input>
        </div>

        <div class="cidade" if={ choseCity }>
          <input type="text" value="" placeholder="Cidade" id="local" oninput={ onInputPlace }></input>
        </div>

      </div>

      <div class="hydric">
        <h5>Características da planta</h5>

        <select id="typeofplant" onchange={ plantSubmit }>
            <option value="">Escolha a planta</option>
            <option each="{ plant, i in  fields.Cultures }" value="{ plant }">{ plant }</option>
          </select>

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

      <input type="submit" name="submit" onclick={ formSubmitted }/>
    </form>
  
  </div>

  <div class="results" if={ step2 } >
      <h2>Os seus dados:</h2>
      <div class="col-1">
        <p if={ choseCity }>Cidade : { this.city }</p>
        <p if={ choseCoords }>Latitude: { this.lat } </p>
        <p if={ choseCoords }>Longitude: { this.lon } </p>
        <p>Período: <br> De { startDay } de { startMonth } até { endDay } de { endMonth } <br/></p>
        <h5>Necessidade hídricas</h5>
      </div>

      <button type="button" onclick={ insNewData }>Introduzir novos dados</button>
      <button type="button" onclick={ writeToFile } >Enviar dados</button>
      <button type="button" if="{ dataSent }" onclick={ showChart } >Gerar gráfico</button>
  </div>

	<script>
	
    // Variable declaration

		self = this;
    this.teste = '';
    this.step1 = true;
    this.choseCity = this.choseCoords = this.step2 = this.dataSent = false;
		this.startMonth = this.startDay = this.endDay = this.endMonth = this.city = '';
    this.lon = this.lat = this.userLat = this.userLon = 0;
    this.userData = []

    // Object for testing
    this.fields = {
          "Months": ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"],
          "Cultures": ["Algodão","Amendoim","Arroz","Banana","Batata","Beterraba","Cana-de-açucar","Cártamo","Cebola","Citrinos","Couve","Ervilha","Feijão","Feijão-verde","Girassol","Luzema","Melancia","Milho","Oliveira","Pimento","Soja","Sorgo","Tabaco","Tomate","Trigo","Vinha"],
          "Coeficients": [0.776,0.712,1.3,0.86,0.766,0.786,0.746,0.612,0.81,0.76,0.78,0.88,0.622,0.774,0.736,0.715,0.75,0.726,0.5,0.76,0.74,0.818,0.788,0.76,0.742,0.65],
          "TypeofWatering": ["Faixas","Canteiros","Sulcos","Gota-a-gota","Miniaspersão","Aspersão"]
    };



    // The chart is initially hidden

    this.on('mount', function() {
        $('#myChart').addClass('hidechart');
    });


		// Get the data from the user


    // Coordinates
    onInputCoords(e) {
        var ID = $(e.target).attr('id');
        if(ID == 'latitude')
        this.userLat = $(e.target).val();
        if(ID == 'longitude')
        this.userLon = $(e.target).val();
    }

    // Chosen method - Coords or city
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


    // Submitted month
		monthSubmit(e) {
			var ID = $(e.target).attr('id');

			if(ID == 'startMonth')
				this.startMonth = $(e.target).val();
      if(ID == 'endMonth')
        this.endMonth = $(e.target).val();
		};

    // Submitted days
		onInputDays(e) {
      var ID = $(e.target).attr('id');

			if(ID == 'diainicial')
        this.startDay = $(e.target).val();
      if(ID == 'diafinal')
        this.endDay = $(e.target).val();
		};

    // Submitted city
    onInputPlace(e) {
      var string = $(e.target).val();
      this.city = string.charAt(0).toUpperCase() + string.slice(1);
    }

    // When the user wants to introduce new data
    insNewData() {
      this.step2 = false;
      this.step1 = true;
      this.dataSent = false;
      $('#myChart').addClass('hidechart');

      this.update();
    }

    // After form is submitted

    // Change between steps
    formSubmitted(e) {
      this.step1 = false;
      this.step2 = true;


      this.weatherCall();
      self.update();
    }

    // Creates a json object with user data

    
	
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

      this.dataSent = true;
      self.update();
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
        if(this.dataSent) {
          $('#myChart').removeClass('hidechart');
        }
    };

// Poder alterar o periodo de tempo dinamicamente no grafico em vez de o user ter que introduzir tudo novamente
// dados introduzidos aparecer ao lado do grafico

	</script>

</sendinfo>
