﻿<%@  language="JScript" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Classic ASP error page</title>
</head>
<body>
    <%
        var conn = Server.CreateObject("ADODB.Connection");
        conn.ConnectionTimeout = 1;
        conn.ConnectionString = "not a valid connection string";
        conn.Open();
    %>
</body>
</html>
