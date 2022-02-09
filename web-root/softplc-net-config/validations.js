function ValidateIPaddress(inputText, context)
{
    var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
    if( inputText.value.match(ipformat) )
    {
        return true;
    }
    else
    {
        alert("You have entered an invalid " + context);
        document.Form.gateway_ip.focus();
        return false;
    }
}
