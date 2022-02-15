
const ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;


function validate_ip_address( inputText, context )
{
    if( inputText.val().match(ipformat) )
    {
        return true;
    }
    else
    {
        alert("You have entered an invalid " + context);
        inputText.focus();
        return false;
    }
}


function validate_form()
{
    var my_ip   = $('#_my_ip');
    var netmask = $('#_subnet_mask');
    var gateway = $('#_gateway_ip');

    if( !validate_ip_address( my_ip, "IP address" ) )
        return false;

    if( !validate_ip_address( netmask, "subnet mask" ) )
        return false;

    // a blank gateway is allowed as OK.
    if( gateway.val().length > 0 )
        if( !validate_ip_address( gateway, "gateway IP address" ) )
            return false;

    return true;
}


function on_doc_ready()
{
    $.ajax({

        url: "/cgi-bin/net-config-read-current-settings.sh",
        dataType: "script",

        error: function( XMLHttpRequest, textStatus, errorThrown )
        {
            alert( "Request: " + JSON.stringify(XMLHttpRequest) + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown );
        },

        success: function( script )
        {
            console.log( 'script:' + script );

            $( '#_my_ip' ).val( my_ip );
            $( '#_gateway_ip' ).val( gateway_ip );
            $( '#_subnet_mask' ).val( subnet_mask );
        }
    });
}

$(on_doc_ready);
