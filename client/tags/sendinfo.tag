<sendinfo>

	<h3>Por favor insira os seus dados </h3>
  Zona:
    <select id="zone" onchange={ submitted }>
      <option value="DouroMinho">Douro/Minho</option>
      <option value="TrasosMontes">Tras os Montes</option>
      <option value="BeiraLitoral">Beira Litoral</option>
      <option value="BeiraInterior">Beira Interior</option>
    </select>
  <br>
  Planta:
  <select id="flower" onchange={ submitted }>
      <option value="Milho Grao">Milho Grão</option>
      <option value="Milho"> Milho</option>
      <option value="Prado"> Prado</option>
      <option value="Batata"> Batata</option>
      <option value="Couve Macieira"> Couve Macieira</option>
      <option value="Tomateiro"> Tomateiro</option>
      <option value="Pessegueiro"> Pessegueiro</option>
      <option value="Pomoideas"> Pomoídeas</option>
      <option value="Vinha"> Vinha</option>
    </select>
  <br>
  <br>
  Data de Inicio:
  <br>
  Mes:
    <select id="month" onchange={ submitted }>
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
  <input type="number" value="1" oninput={ onInput }></input>
	
	<div class="results">
		<h1>Escolheu:</h1>
		<br/>
		<div class="col-1">
			Zona: { zone } <br/>
			Planta:{ flower } <br/>
			Mes:{ month } <br/>
			Dia:{ day } <br/
		</div>
	</div>

	<script>
	
		self = this;
		this.zone = '';
		this.flower = '';
		this.month = '';
		this.day = '';

		// Get the data from the user
		submitted(e) {
			var ID = $(e.target).attr('id');

			if(ID == 'zone')
				self.zone = $('#zone :selected').text();
				self.update();

			if(ID == 'flower')
				self.flower = $('#flower :selected').text();
				self.update();
			if(ID == 'month')
				self.month = $('#month :selected').text();
				self.update();
			if(ID == 'day')
				self.day = $('#day :selected').text();
				self.update();
		};

		onInput(e) {
			self.day = e.target.value;
			$('.col-1').css('color', 'red');
			self.update();
		}
	
		// Send the data to octave app
	
	
		// Display the result to the user

	</script>

</sendinfo>
