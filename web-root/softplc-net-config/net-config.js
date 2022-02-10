

function validate_form()
{
    //console.log( "validate_form() return true" );
    return true;
}


function on_doc_ready()
{
    $.ajax({
        url: "softplc-net-config/config/LAST-NETWORKS.LST",
        //async: false,
        context: document.body,

        error : function(jqXHR, textStatus, errorThrown ) {
                alert( "softplc-net-config/config/LAST-NETWORKS.LST not found" );
            },

        dataType: "script",

        success: function( script, textStatus ) {
            eval( script );

            $( '#_my_ip' ).val( my_ip );
            $( '#_gateway_ip' ).val( gateway_ip );
            $( '#_subnet_mask' ).val( subnet_mask );
        }
    });
}

$(on_doc_ready);
