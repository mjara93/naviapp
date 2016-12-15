// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){

    $(document).on( "focusout", ".cantidad", function() {
        var cantidad = parseFloat($(this).val());
        var abuelo = $(this).parent().parent();
        var precio = abuelo.children().children(".precio");
        var valor = precio.val();
        if(valor!="" && valor != null && !isNaN(valor)){
            var valorSubtotal = parseInt(valor)*cantidad;
            var subtotal = abuelo.children().children(".subtotal");
            subtotal.val(valorSubtotal);
            calcularTotal();
        }
    });

    $(document).on( "focusout", ".precio", function() {
        var precio = parseInt($(this).val());
        var abuelo = $(this).parent().parent();
        var cantidad = abuelo.children().children(".cantidad");
        var valor = cantidad.val();
        if(valor!="" && valor != null && !isNaN(valor)){
            var valorSubtotal = parseFloat(valor)*precio;
            var subtotal = abuelo.children().children(".subtotal");
            subtotal.val(valorSubtotal);
            calcularTotal();
        }
    });


    $('#details').on('cocoon:after-remove', function(e, insertedItem) {
       calcularTotal();
    });

    function calcularTotal(){
      var total = 0;
      $(".subtotal").each(function(e){
        if (!isNaN($(this).val())) {
          var valorSubtotal = parseInt($(this).val());
          total+= valorSubtotal;
        }
      });
      $('.total').val(total);
    }

});
