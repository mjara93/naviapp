// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){

    $(".grupo").keyup(function()

    {
        var cantidad=$(this).find("input[id=sale_details_attributes_new_details_cantidad]").val();
        var precio=$(this).find("input[id=sale_details_attributes_new_details_precio]").val();
        $(this).find("input[id=sale_details_attributes_new_details_subtotal]").html(parseInt(precio)*parseInt(cantidad));

        // calculamos el total de todos los grupos

        var total=0;

        $(".grupo .total").each(function(){

            total=total+parseInt($(this).html());

        })

        $(".total .total").html(total);

    });

});
