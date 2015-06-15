<sendinfo>

  <div class="step1" if={ step1 }>
    <form method="post" action='' onsubmit={ onSubmit }>
      <div class="local">

        <div class="form-description" id="first-descript">
          <h4>Localização</h4>
        </div>
        <label>Escolha entre inserir a cidade ou coordenadas
        Nota: ao escolher cidade em vez de coordenadas os dados meteorológicos podem não ser tão precisos.</label>
        <select class="form-control" onchange={ localMethod }>
            <option value="">Escolha o método</option>
            <option value="Cidade">Cidade</option>
            <option value="Coordenadas">Coordenadas</option>
        </select>

        <div class="coordenadas" onchange={ onInputCoords } if={ choseCoords }>
          <label>Coordenadas</label>
          Latitude<input class="form-control" type="number" value="" placeholder="0" name="latitude"></input>
          Longitude<input class="form-control" type="number" value="" placeholder="0" name="longitude"></input>
        </div>

        <div class="cidade" if={ choseCity }>
          <input type="text" class="form-control" value="" placeholder="Cidade" id="local" oninput={ onInputPlace }></input>
        </div>

      </div>

      <div class="hydric">
        <div class="form-description">
          <h4>Planta</h4>
        </div>

        <select class="form-control" name="typeofplant" onchange={ plantSubmit }>
            <option value="">Escolha a planta</option>
            <option each="{ plant, i in  fields.Cultures }" value="{ plant }">{ plant }</option>
        </select>

      </div>

      <div class="water">
        <div class="form-description">
          <h4>Tipo de Rega</h4>
        </div>

        <select class="form-control" name="typeofwatering" onchange={ wateringSubmit }>
            <option value="">Escolha o tipo</option>
            <option each="{ water, i in  fields.TypeofWatering }" value="{ water }">{ water }</option>
        </select>
      </div>

      <button class="btn btn-primary disabled" id="firstButton" type="button" onclick="{ formSubmitted }" >Enviar dados</i></button>
    </form>

  </div>

  <div class="step2" if={ step2 }>
    <div class="results">
        <h4 class="description">Os seus dados:</h4>
        <div class="col-1">
          <p if={ choseCity }>Cidade : { this.city }</p>
          <p if={ choseCoords }>Latitude: { this.lat } </p>
          <p if={ choseCoords }>Longitude: { this.lon } </p>
          <p>Planta: { typeofplant.value }</p>
          <p>Tipo de Rega: { typeofwatering.value }</p>
        </div>

        <button class="btn btn-default" type="button" onclick="{ insNewData }">Introduzir novos dados</button>
        <button class="btn btn-primary" type="button" onclick="{ writeToFile }" >Enviar dados</i></button>
        <button class="btn btn-success" type="button" if="{ dataSent }" onclick="{ showChart }" >Gerar gráfico</button>

    </div>
  </div>

	<script>

    // Variable declaration

		self = this;
    this.step1 = true;
    this.tmin = this.tmax = this.wind = 0;
    this.wateringCoeficient = 0;
    this.coeficient = 0;
    this.wateringType = '';
    this.choseCity = this.choseCoords = this.step2 = this.dataSent = false;
		this.city = '';
    this.lon = this.lat = this.userLat = this.userLon = 0;

    // Main object initialization
    this.fields = {
          "Cultures": ["Algodão","Amendoim","Arroz","Banana","Batata","Beterraba","Cana-de-açucar","Cártamo","Cebola","Citrinos","Couve","Ervilha","Feijão","Feijão-verde","Girassol","Luzema","Melancia","Milho","Oliveira","Pimento","Soja","Sorgo","Tabaco","Tomate","Trigo","Vinha"],
          "Coeficients": [0.776,0.712,1.3,0.86,0.766,0.786,0.746,0.612,0.81,0.76,0.78,0.88,0.622,0.774,0.736,0.715,0.75,0.726,0.5,0.76,0.74,0.818,0.788,0.76,0.742,0.65],
          "TypeofWatering": ["Faixas","Canteiros","Sulcos","Gota-a-gota","Miniaspersão","Aspersão"],
          "WateringCoeficient": [0.57, 0.59, 0.58, 0.9, 0.85, 0.8],
          "HydricNeeds": [],
          "TypeofGround": [],
          "GroundConstant": []
    };

    // falta necessidades hidricas da planta , que sao de acordo com a planta
    // pedir o tipo de solo ao utilizador e retornar uma constante associadaa (entre 0 e 20)
    // falta o utilizador introduzir  humidade inicial(percentagem) e altitude
    // a humidade inicial, se ele nao introduzir metemos o dobro da necessidade hidrica minima da planta escolhida
    // litoral ou interior
    // criar key->value object

    // Data to send to octave
    this.octaveData = {
      "Latitude": this.lat,
      "Longitude": this.lon,
      "Tmin": this.tmin,
      "Tmax": this.tmax,
      "Vento": this.wind,
      "Xmin": 1,
      "Evapo": this.coeficient,
      "TipodeRegaConst": this.wateringCoeficient
    };

    // The chart is initially hidden

    this.on('mount', function() {
      $('#myChart').addClass('hidechart');
    });


		// Get the data from the user

    // Coordinates
    onInputCoords(e) {
        this.lat = this.latitude.value;
        this.lon = this.longitude.value;    }

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

    // Auxiliary Method (gets the index of plant to retrieve the coeficient)

    function getIndex(chosenPlant) {
      plants = self.fields.Cultures;
      coeficients = self.fields.Coeficients;
      watering = self.fields.WateringCoeficient;

      for (i = 0; i < plants.length; i++) {
          if (chosenPlant == plants[i]) {
            return i;
          }
      }

      return -1;
    }

    function getIndexTwo(chosenWater) {
      typeofwatering = self.fields.TypeofWatering;
      watering = self.fields.WateringCoeficient;

      for (i = 0; i < typeofwatering.length; i++) {
          if (chosenWater == typeofwatering[i]) {
            return i;
          }
      }

      return -1;
    }

    // Handle type of plant submission
    plantSubmit() {
      plantChosen = this.typeofplant.value;
      index = getIndex(plantChosen);

      this.coeficient = this.fields.Coeficients[index];
    }

    // Handle type of watering submission
    wateringSubmit() {
      waterChosen = this.typeofwatering.value;
      index = getIndexTwo(waterChosen);

      this.wateringType = waterChosen;
      this.wateringCoeficient = this.fields.WateringCoeficient[index];
      $('#firstButton').removeClass('disabled');
    }

    // Submitted city - formats the string
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
      //$('.la-anim-5').removeClass('la-animate');

      this.update();
    }

    // After form is submitted

    // Going from step1 to step2
    formSubmitted(e) {
      e.preventDefault();

      this.step2 = true;
      this.step1 = false;

      this.weatherCall(e);
      // $('.la-anim-5').addClass('la-animate');

      self.update();
    }

		// Weather API call

    weatherCall(e) {
      e.preventDefault();

      self = this;
      urlResult = '';
      vento = tmin = tmax = 0;

      if( this.choseCity ) {
        urlResult = 'http://api.openweathermap.org/data/2.5/weather?q='+ this.city + ',PT';
      }

      else {
        urlResult = 'http://api.openweathermap.org/data/2.5/weather?'+'lat='+this.lat+'&'+'lon='+this.lon;
      }

      $
        .ajax({ url: urlResult, dataType: 'json' })
        .then(this.onGetWeather.bind(this))
        .fail(function() {
          console.log("Something went wrong");
        });

      return false;
    }

    onGetWeather (data) {
      this.wind = data.wind.speed;
      this.tmin = data.main.temp_min;
      this.tmax = data.main.temp_max;

      this.update();
      console.log("Weather Data retrieved successfuly!");
    }

    // Data-to-file and runs octave
      writeToFile(e) {
        e.preventDefault();

        self = this;

        $.ajax({
          url: 'http://localhost:4000/process-data.php',
          type: 'post',
          data: { 'input-data': JSON.stringify(this.octaveData) },
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

        $
          .ajax({
            url: 'http://localhost:4000/index.php',
            type: 'get',
            data: { 'input-data': JSON.stringify(self.fields) }
          })
          .then(function(data){
            console.log('call to index-data successful');
          })
          .fail(function(jqXHR, textStatus, errorThrown) {
            console.log("call to index-data failed");
          });

        return false;

      }

		// Display the result to the user

    showChart(e) {
      e.preventDefault();

      // After we receive the data from octave we inject that into the chart

      // opts.lineChart.addData([100, 100], "August");

      if(this.dataSent) {
        $('#myChart').removeClass('hidechart');
      }
    }

	</script>
</sendinfo>
