<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ElmahAsp._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Elmah error logging for classic ASP</title>
</head>
<body>
    <h1>
        ElmahASP</h1>
    <h2>
        Using ELMAH to log classic ASP runtime errors</h2>
    <h4>
        Classic ASP errors (click to cause one)</h4>
    <ul>
        <li><a href="adodb_connection_fail.asp">ADODB Connection Timeout</a></li>
        <li><a href="createobject_fail.asp">Server.CreateObject failure</a></li>
        <li><a href="scripting_fail.asp">JScript Runtime Error</a></li>
        <li>
            <form action="scripting_fail.asp?foo=bar&baz=1237&codes=1&codes=2&codes=3" method="POST">
            <input type="hidden" name="simple" value="simple form value" />
            <input type="hidden" name="multiple" value="value1" />
            <input type="hidden" name="multiple" value="value2" />
            <input type="hidden" name="multiple" value="value3" />
            <input type="submit" name="verb" value="Runtime error during POST" />
            </form>
        </li>
    </ul>
    <h4>
        Other Useful Things</h4>
    <ul>
        <li><a href="fail.aspx">Cause an ASP.NET NullReferenceException</a></li>
    </ul>
    <hr />
    <p>
        <a href="/elmah.axd">Show Elmah logs</a></p>
</body>
</html>
