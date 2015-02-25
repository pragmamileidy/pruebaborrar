// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
$(document).ready(function(){


  $('#MyWizard').on('change', function(e, data) {
    console.log('change');
    if(data.step===1 && data.direction==='next') {
    }
  });

  $('#btnWizardNext').on('click', function() {
    console.log('next');
    if(validarForm()==''){
      verificarTarjeta();
    }
    else {alert(validarForm());}
  });

  $('#btnWizardPrev').on('click', function() {
    console.log('prev');
    $('#MyWizard').wizard('previous');
  });

  $('#wizard-fin').on('click', function() {
    console.log('fin');
     $('#MyWizard').wizard('finished');
  });

  $( "input:radio" ).click(function() {
          check3(this);
  });

});

 ////////////// VALIDAR TARJETA DE CREDITO NUMERO ///////
  var CreditCard = {  
    cleanNumber: function(number) {  
      return number.replace(/-/g, "");  
    },  
      
    validNumber: function(number) {  
      var total = 0;  
      number = this.cleanNumber(number);  
      for (var i=number.length-1; i >= 0; i--) {  
        var n = parseInt(number[i]);  
        if ((i+number.length) % 2 == 0) {  
          n = n*2 > 9 ? n*2 - 9 : n*2;  
        }  
        total += n;  
      };  
      return total % 10 == 0;  

    },  

    validaVisa: function(number) {
      if (number.match(/^4\d{3}-?\d{4}-?\d{4}-?\d{4}$/)) {
        return true
      } else {
        return false
      }
    }, 
    validaMaster: function(number) {
      if (number.match(/^5[1-5]\d{2}-?\d{4}-?\d{4}-?\d{4}$/)) {
        return true
      } else {
        return false
      }
    }, 
  }

function validarForm()
{
  var valida = capturar();
  var numero = document.getElementById("payment_cards_number");
  var codigo = document.getElementById("payment_cards_code");
  var resultado = "";

  if (valida == 'ninguno'){
    resultado = "Debe seleccionar una Tarjeta"
  } else if (numero.value == ''){
    resultado = "Debe indicar el número de la Tarjeta"
  }
  else if (codigo.value == ''){
    resultado = "Debe ingresar el codigo de la tarjetaTarjeta"
  }
  return resultado
}

///////////// PROBAR VALOR DE RADIO //////////////////
function capturar()
{
    var resultado="ninguno";
    var porNombre=document.getElementsByName("payment[cards][options]");
    // Recorremos todos los valores del radio button para encontrar el
    // seleccionado
    for(var i=0;i<porNombre.length;i++)
    {
        if(porNombre[i].checked)
            resultado=porNombre[i].value;
    }
    return resultado;
}


function validateCard(number){ 
  var opcion = capturar();
  var respuesta = "";
    if (opcion != 'ninguno'){
      switch(opcion) {
          case 'Visa':
              respuesta =  CreditCard.validaVisa(number.value);
              break;
          case 'Master':
              respuesta =  CreditCard.validaMaster(number.value);
              break;
      }
      if (!respuesta) {
        $("#payment_cards_number_error").text("Invalid credit card number.");
      }
      if (respuesta)  {   
        $("#payment_cards_number_error").text("");
      }
  }else {alert("Debe seleccionar un tipo de tarjeta");}
};


////// desbloquear campos de fecha
function desbloquear(){
  var concatenar = 'payment_cards_date_expired_';
  var fecha = '';
  $.each( $('[id*=payment_cards_date_expired_]'), function(index, campo) {       
        var number = (this.id).match(/[\d]i/);
        //alert(pos);
        fecha = concatenar.concat(number);
          //alert(dato)
        document.getElementById(fecha).disabled = false;
        document.getElementById(fecha).value = '';
      });
}

///////// blanquear campos de tarjeta
function check3(obj) {
     
  desbloquear();
  document.getElementById('payment_cards_number').disabled = false;
  document.getElementById('payment_cards_number').value = '';
  $("#payment_cards_number_error").text("");
  document.getElementById('payment_cards_code').disabled = false;
  document.getElementById('payment_cards_code').value = '';
 }


 /////// validar customer ////

 function verificarCliente(){
  numero = document.getElementById("payment_customers_identification").value;
  name = document.getElementById("payment_customers_name").value;
  
  params = {"numero": numero, "name" : name}

  $.ajax({
        url: "/payments/validate_customer", //controller
        data: params,
        dataType: "json",
        success: function(response) {
          console.log("RESPUESTA OBTENIDA " + response);
          $("#payment_customer_id").val(response);
        },
        error: function(response) {
          console.log("RESPUESTA OBTENIDA ERROR " + response);
            //Do Something to handle error
        }
    });
}

/////// validar tarjetas ////

function verificarTarjeta(){
  numero = document.getElementById("payment_cards_number").value;
  numero = CreditCard.cleanNumber(numero)
  codigo = document.getElementById("payment_cards_code").value;
  
  params = {"codigo": codigo,"numero": numero}

  $.ajax({
        url: "/payments/validate_card", //controller
        data: params,
        dataType: "json",
        success: function(response) {
          console.log("RESPUESTA OBTENIDA " + response);
          if(response){ 
            obtenerValores(); 
            verificarCliente();
            verificarFecha();
          }
          else{alert("No se encontro la tarjeta")}
        },
        error: function(response) {
          console.log("RESPUESTA OBTENIDA ERROR " + response);
          $("#tarjeta_invalida").text("No se encontraron los datos de la tarjeta");
            //Do Something to handle error
        }
    });
}

/////// validar fecha de expiracion /////

function verificarFecha(){
  mes = document.getElementById('payment_cards_date_expired_2i').value;
  anio = document.getElementById('payment_cards_date_expired_1i').value;
  numero = document.getElementById("payment_cards_number").value;
  numero = CreditCard.cleanNumber(numero)
  fecha =  "0"+mes + "/" + anio

  params = {"numero": numero, "fecha": fecha}

  $.ajax({
        url: "/payments/validate_fecha", //controller
        data: params,
        dataType: "json",
        success: function(response) {
          console.log("RESPUESTA OBTENIDA " + response); 
          if(response){ 
           console.log("ok"); 
           $('#MyWizard').wizard('next');
          }
          else{alert("FECHA INVALIDA")}
        },
        error: function(response) {
          console.log("RESPUESTA OBTENIDA ERROR " + response);
          alert("La fecha es incorrecta");
            //Do Something to handle error
        }
    });
}

/////// PRUEBA GET getElementsByName
function obtenerValores(){
  monto = document.getElementById("payment_amount").value;
  tipo = capturar();
  numero_tarjeta = document.getElementById("payment_cards_number").value;
  cliente = document.getElementById("payment_customers_name").value;
  $("#monto_final").text(monto);
  $("#tipo_tarjeta").text(tipo);
  $("#numero_tarjeta").text(numero_tarjeta);
  $("#nombre_tarjetahabiente").text(cliente);
} 