<sendinfo>

  <div class="step1" if={ step1 }>
    <form method="post" action='' onsubmit={ onSubmit }>
      <div class="local">

        <div class="form-description" id="first-descript">
          <h4>Localização</h4>
        </div>
        <label>Escolha entre inserir a cidade ou coordenadas
        Nota: ao escolher cidade em vez de coordenadas os dados meteorológicos podem não ser tão precisos.</label>
        <select class="form-control" onchange="{ localMethod }">
            <option value="">Escolha o método</option>
            <option value="Cidade">Cidade</option>
            <option value="Coordenadas">Coordenadas</option>
        </select>

        <div class="coordenadas" onchange="{ onInputCoords }" if="{ choseCoords }">
          <label>Coordenadas</label>
          Latitude<input class="form-control" type="number" value="" placeholder="0" name="latitude"></input>
          Longitude<input class="form-control" type="number" value="" placeholder="0" name="longitude"></input>
        </div>

        <div class="cidade" if={ choseCity }>
          <input type="text" class="form-control" value="" placeholder="Cidade" id="local" oninput="{ onInputPlace }"></input>
        </div>

      </div>

      <div class="hydric">
        <div class="form-description">
          <h4>Planta</h4>
        </div>

        <select class="form-control" name="typeofplant" onchange="{ plantSubmit }">
            <option value="">Escolha a planta</option>
            <option each="{ plant, i in  fields.Cultures }" value="{ plant }">{ plant }</option>
        </select>

      </div>

      <div class="water">
        <div class="form-description">
          <h4>Outros</h4>
        </div>

        <label>Tipo de solo</label>
        <select class="form-control" name="typeofground" onchange="{ groundSubmit }">
            <option value="">Escolha o tipo</option>
            <option each="{ ground, i in  fields.TypeofGround }" value="{ ground }">{ ground }</option>
        </select>

        <label>Altitude</label>
        <input class="form-control" type="number" value="" placeholder="0" name="altitude" oninput="{ altitudeSubmit }"></input>

        <label>Estado inicial da planta</label>
        <input class="form-control" type="number" value="" placeholder="0" name="estadoinicial" oninput="{ initStateSubmit }"></input>

        <label>Humidade do solo</label>
        <input class="form-control" type="number" value="" placeholder="0" name="groundHumidity" oninput="{ groundHumidity }"></input>

        <label>Costa ou Interior</label>
        <select class="form-control" name="coast" onchange="{ coastInterior }">
            <option value="">Escolha o tipo</option>
            <option value="1">Costa</option>
            <option value="2">Interior</option>
        </select>
      </div>

      <div class="water">
        <div class="form-description">
          <h4>Tipo de Rega</h4>
        </div>

        <select class="form-control" name="typeofwatering" onchange="{ wateringSubmit }">
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
          <p if="{ choseCity }">Cidade : { this.city }</p>
          <p if="{ choseCoords }">Latitude: { this.lat } </p>
          <p if="{ choseCoords }">Longitude: { this.lon } </p>
          <p>Planta: { typeofplant.value }</p>
          <p>Tipo de Rega: { typeofwatering.value }</p>
        </div>

        <button class="btn btn-default" type="button" onclick="{ insNewData }">Introduzir novos dados</button>
        <button class="btn btn-primary" type="button" onclick="{ writeToFile }" >Enviar dados</i></button>
        <button class="btn btn-success" type="button" if="{ dataSent }" onclick="{ showChart }" >Gerar gráfico</button>

    </div>
  </div>

	<script>

    // ToDo
    // Exportar o weather data em arrays de 5 elementos

    // Variable declaration

    // rain, wind, tmin, tmax, fazer media dos 8 calculos por dia, e dar um array de 5 elementos
    // com essas medias

		self = this;
    this.step1 = true; // To toggle the graphic step
    this.tmin = this.tmax = this.wind = 0; // Weather variables
    this.wateringCoeficient = 0;
    this.coeficient = 0; // Plant coeficient
    this.wateringType = '';
    this.choseCity = this.choseCoords = this.step2 = this.dataSent = false;
		this.city = '';
    this.lon = this.lat = this.userLat = this.userLon = 0;
    this.groundHumidity = -1; // -1 is the default in case the user doesnt specifiy one
    this.pfraction = 0; // plant pfraction
    this.coast = 1; // coast by default, else interior
    this.day = this.month = this.year = 0; // Default date will be now
    this.altitude = 0; // altitude of the field
    this.zr = 0; // plant zr
    this.thetafc = 0; // groundthetafc
    this.thetawp = 0; // groundthetawp
    this.initialstate = 0; // initial state of the plant

    // Main object initialization
    this.fields = {
          "Cultures": ["Algodão","Amendoim","Arroz","Banana","Batata","Beterraba","Cana-de-açucar","Cártamo","Cebola","Citrinos","Couve","Ervilha","Feijão","Feijão-verde","Girassol","Luzema","Melancia","Milho","Oliveira","Pimento","Soja","Sorgo","Tabaco","Tomate","Trigo","Vinha"],
          "Coeficients": [0.776,0.712,1.3,0.86,0.766,0.786,0.746,0.612,0.81,0.76,0.78,0.88,0.622,0.774,0.736,0.715,0.75,0.726,0.5,0.76,0.74,0.818,0.788,0.76,0.742,0.65],
          "ProfRadMax": [1.4,0.75,0.75,0.7,0.5,0.8,0.5,1.5,0.45,1.3,0.5,0.8,0.75,0.6,1.2,1.5,1.1,1.4,0.5,0.75,0.9,1.5,0.5,1.1,1.3,0.5],
          "PFraction": [0.6,0.5,0.2,0.35,0.35,0.5,0.5,0.6,0.5,0.5,0.5,0.35,0.45,0.45,0.45,0.5,0.4,0.55,0.5,0.3,0.5,0.55,0.5,0.4,0.55,0.5],
          "TypeofWatering": ["Faixas","Canteiros","Sulcos","Gota-a-gota","Miniaspersão","Aspersão"],
          "WateringCoeficient": [0.57, 0.59, 0.58, 0.9, 0.85, 0.8],
          "TypeofGround": ["Arenoso", "Areno-franco", "Areno-limoso", "Franco", "Franco-limoso", "Limoso", "Franco-limo-argiloso", "Limo-argiloso", "Argiloso"],
          "GroundThetaFc": [0.12,0.04, 0.23, 0.26, 0.30, 0.32, 0.34, 0.36, 0.36],
          "GroundThetaWp": [0.04, 0.04, 0.1, 0.12, 0.15, 0.15, 0.19, 0.21, 0.21]
    };

    // The chart is initially hidden

    this.on('mount', function() {
      $('#myChart').addClass('hidechart');
    });


		// Get the data from the user

    // Coordinates
    onInputCoords(e) {
        this.lat = this.latitude.value;
        this.lon = this.longitude.value;
        this.update();
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
      this.update();
    }

    // Gets the index of plant to retrieve the coeficient

    function getCoeficients(chosenPlant) {
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

    // Gets the index of plant to retrieve the Zr

    function getZr(chosenPlant) {
      plants = self.fields.Cultures;
      Zrs = self.fields.ProfRadMax;

      for (i = 0; i < plants.length; i++) {
          if (chosenPlant == plants[i]) {
            return i;
          }
      }

      return -1;
    }

    // Gets the index of watering to retrieve the wateringcoeficient

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

    // Gets the index of ground to retrieve the thetafc

    function getThetaIndex(chosenGround) {
      typeofground = self.fields.TypeofGround;

      for (i = 0; i < typeofground.length; i++) {
          if (chosenGround == typeofground[i]) {
            return i;
          }
      }

      return -1;
    }

    // TODO -> HANDLE TYPE OF GROUND SUBMISSION

    // Handle type of plant submission
    groundSubmit() {
      groundChosen = this.typeofground.value;
      index = getThetaIndex(groundChosen);

      this.thetafc = this.fields.GroundThetaFc[index];
      this.thetawp = this.fields.GroundThetaWp[index];
      this.update();
    }

    // Handle type of plant submission
    plantSubmit() {
      plantChosen = this.typeofplant.value;
      index = getCoeficients(plantChosen);
      indextwo = getZr(plantChosen);

      this.zr = this.fields.ProfRadMax[index];
      this.coeficient = this.fields.Coeficients[index];
      this.pfraction = this.fields.PFraction[index];
      this.update();
    }

    // Handle ground humidity submission
    groundHumidity() {

      humidity = $("[name='groundHumidity']");

      if ($(humidity).val() != '') {
        this.groundHumidity = $(humidity).val();
      }
      else {
        this.groundHumidity = -1;
      }
      this.update();
    }

    // Handle altitude submission
    altitudeSubmit() {

      altitude = $("[name='altitude']");

      if ($(altitude).val() != '') {
        this.altitude = $(altitude).val();
      }
      this.update();
    }

    initStateSubmit() {
        estadoinicial = $("[name='estadoinicial']");

        if ($(estadoinicial).val() != '') {
          this.estadoinicial = $(estadoinicial).val();
        }
        else {
          this.estadoinicial = this.Xmin;
        }
        this.update();
      }

    // Handle coast submission
    coastInterior(e) {
      optionChosed = $(e.target).val();
      if (optionChosed == 2) {
        this.coast = 2;
      }
      // else it will be 1 by default
      this.update();
    }

    // Handle type of watering submission
    wateringSubmit() {
      waterChosen = this.typeofwatering.value;
      index = getIndexTwo(waterChosen);

      this.wateringType = waterChosen;
      this.wateringCoeficient = this.fields.WateringCoeficient[index];
      $('#firstButton').removeClass('disabled');
      this.update();
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

      this.update();
    }

    // After form is submitted

    // Going from step1 to step2
    formSubmitted(e) {
      e.preventDefault();

      this.step2 = true;
      this.step1 = false;

      this.weatherCall(e);

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

     // Data to send to octave

    // Data-to-file and runs octave
      writeToFile(e) {
        e.preventDefault();

        self = this;
        this.octaveData = {
          "Dia": new Date().getDate(),
          "Mes": new Date().getMonth() + 1,
          "Ano": new Date().getFullYear(),
          "EstadoInicial": this.estadoinicial,
          "Altitude": this.altitude,
          "Latitude": this.lat, // Latitude from user's location
          "Longitude": this.lon, // Longitude from user's location
          "Tmin": this.tmin, // Minimum temperature
          "Tmax": this.tmax, // Maximum temperature
          "Vento": this.wind, // Wind conditions
          "Xmin": 1, // Minimum humidity
          "Evapo": this.coeficient, // Plant coeficient
          "TipodeRegaConst": this.wateringCoeficient, // Type of watering coeficient
          "Costa": this.coast,
          "groundthetaFC": this.thetafc, // ground fc
          "groundthetaWP": this.thetawp, // ground wp
          "pFraction": this.pfraction, // plant pFraction
          "ProfRadMax": this.zr // Plant radicular depth
        };

        $.ajax({
          url: 'http://localhost:4000/process-data.php',
          type: 'post',
          data: { 'input-data': JSON.stringify(this.octaveData) },
          cache: false
        })
        .then(this.onWriteToTheFile.bind(this))
        .fail(function(jqXHR, textStatus, errorThrown) {
          console.log("Something went wrong");
        });

        return false;
      }

      // New helper function writetofile
      onWriteToTheFile() {
          this.dataSent = true;

        //for (var key in this.octaveData) {
        //  console.log(key + " -> " + this.octaveData[key]);
        //}
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

      if(this.dataSent) {
        $('#myChart').removeClass('hidechart');
      }
    }

	</script>
</sendinfo>
