<sendinfo>

  <div class="step1" if={ step1 }>

  	<h3>Por favor insira os seus dados </h3>

    <form method="post" action='' onsubmit={ onSubmit }>
      <div class="local">

        <h4>Localização</h4>
        <label>Escolha entre inserir a cidade ou coordenadas
        Nota: ao escolher cidade em vez de coordenadas os dados meteorológicos podem não ser tão precisos</label>
        <label>Método:</label>
        <select class="form-control" onchange={ localMethod }>
            <option value="">Escolha o método</option>
            <option value="Cidade">Cidade</option>
            <option value="Coordenadas">Coordenadas</option>
        </select>

        <div class="coordenadas" onchange={ onInputCoords } if={ choseCoords }>
          <label>Coordenadas</label>
          <input class="form-control" type="number" value="" placeholder="0" name="latitude"></input>
          <input class="form-control" type="number" value="" placeholder="0" name="longitude"></input>
        </div>

        <div class="cidade" if={ choseCity }>
          <input type="text" class="form-control" value="" placeholder="Cidade" id="local" oninput={ onInputPlace }></input>
        </div>

      </div>

      <div class="hydric">
        <h4>Planta</h4>

        <select class="form-control" id="typeofplant" onchange={ plantSubmit }>
            <option value="">Escolha a planta</option>
            <option each="{ plant, i in  fields.Cultures }" value="{ plant }">{ plant }</option>
          </select>

      </div>

      <div class="time">

        <h4>Período</h4>

        <label>Mês inicial:</label>
          <select class="form-control" id="startMonth" onchange={ monthSubmit }>
            <option value="">Escolha o mês</option>
            <option each="{ month, i in  fields.Months }" value="{ month }">{ month }</option>
          </select>

        <label>Dia inicial</label>
        <input class="form-control" type="number" max="31" min="1" value="" placeholder="0" id="diainicial" oninput={ onInputDays }></input>

        <label>Mes final:</label>
          <select class="form-control" id="endMonth" onchange={ monthSubmit }>
            <option value="">Escolha o mês</option>
            <option each="{ month, i in  fields.Months }" value="{ month }">{ month }</option>
          </select>

        <label>Dia final</label>
        <input class="form-control" type="number" maxlength="2" value="" placeholder="0" id="diafinal" oninput={ onInputDays }></input>

      </div>

      <input type="submit" class="btn btn-primary center-block" name="submit" onclick={ formSubmitted }/>
    </form>
  
  </div>

  <div class="results" if={ step2 } >
      <h2>Os seus dados:</h2>
      <div class="col-1">
        <p if={ choseCity }>Cidade : { this.city }</p>
        <p if={ choseCoords }>Latitude: { this.lat } </p>
        <p if={ choseCoords }>Longitude: { this.lon } </p>
        <p>Período: <br> De { startDay } de { startMonth } até { endDay } de { endMonth } <br/></p>
        <h4>Necessidade hídricas</h4>
      </div>

      <button class="btn btn-default" type="button" onclick="{ insNewData }">Introduzir novos dados</button>
      <button class="btn btn-primary" type="button" onclick="{ writeToFile }" >Enviar dados</i></button>
      <button class="btn btn-default" type="button" if="{ dataSent }" onclick="{ showChart }" >Gerar gráfico</button>
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
        this.userLat = this.latitude.value;
        this.userLon = this.longitude.value;    }

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

    // Submitted city - this function formats the string
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

    // Going from step1 to step2
    formSubmitted(e) {
      e.preventDefault();

      this.step1 = false;
      this.step2 = true;


      this.weatherCall(e);
      self.update();
    }

    // Creates a json object with user data

    
	
		// Weather API call

    weatherCall(e) {
      e.preventDefault();

      self = this;
      urlResult = '';
      dataValue = '';

      if( this.choseCity ) {
        urlResult = 'http://api.openweathermap.org/data/2.5/weather?q='+ this.city + ',PT';
      }

      else {
        urlResult = 'http://api.openweathermap.org/data/2.5/weather?'+'lat='+this.lat+'&'+'lon='+this.lon;
      }

      $.ajax({
        url: urlResult,
        dataType: 'json',
        done: function(data) {
          dataValue = data.sys.country;
          this.teste = dataValue;
          console.log("Weather Data retrieved successfuly!");
          console.log(this.teste);
        },
        error: function(jqXHR, textStatus, errorThrown) { 
            console.log("call to weather-data failed");
          }
      });

      console.log(dataValue);

      

      return false;

    }

    // Format input data into json and write it to txt file
      writeToFile(e) {
        e.preventDefault();

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
        

        return false;
      }

    // Receive the output json from octave

      receiveFromOctave(e) {

        e.preventDefault();

        self = this;

        $.ajax({
          url: 'http://localhost:4000/index.php',
          type: 'get',
          data: { 'input-data': JSON.stringify(self.fields) },
          success: function(data){
            console.log('call to index-data successful');
          },
          error: function(jqXHR, textStatus, errorThrown) { 
            console.log("call to index-data failed");
          }
        });

        return false;

      }
	
		// Display the result to the user

    showChart(e) {
      e.preventDefault();

        if(this.dataSent) {
          $('#myChart').removeClass('hidechart');
        }
    };

    onSubmit(e) {
      e.preventDefault();
    }

// Poder alterar o periodo de tempo dinamicamente no grafico em vez de o user ter que introduzir tudo novamente
// dados introduzidos aparecer ao lado do grafico

	</script>

</sendinfo>
