<%@  language="JScript" %>
<script type="text/javascript" language="jscript" runat="server" src="jsonizer.js"></script>
<%    function GetErrorNumber(error) {
        var errorNumber = error.Number;
        errorNumber = ((errorNumber < 0 ? errorNumber + 0x100000000 : errorNumber).toString(16));
        return (errorNumber);
    }

    function GetErrorDetail(error) {
        var errorContext = new Array();
        errorContext.push(error.Description);
        if (error.ASPCode) errorContext.push("ASP Code: " + error.ASPCode);
        if (error.ASPDescription) errorContext.push("ASPDescription: " + error.ASPDescription);
        if (error.Category) errorContext.push("Category: " + error.Category);
        errorContext.push(error.File + ", line " + error.Line);
        errorContext.push("");
        var errorContextLine;
        var fso = Server.CreateObject("Scripting.FileSystemObject");
        var fileStream = fso.GetFile(Server.MapPath(error.File)).OpenAsTextStream(1);
        var i = 0;
        while (i++ < (error.Line - 5)) {
            if (fileStream.AtEndOfStream) break;
            fileStream.SkipLine();
        }
        while (i < error.Line + 5) {
            if (fileStream.AtEndOfStream) break;
            var line = fileStream.ReadLine();
            errorContext.push(i + ": " + line.replace(/\t/g, " ").replace(/^[ \t]*/g, ''));
            i++;
        }
        fileStream.Close();
        fso = null;
        return (errorContext.join("\r\n"));
    }

    if (Response.Buffer) {
        Response.Clear();
        Response.Status = "500 Internal Server Error";
        Response.Expires = 0;
    }

    var JSON = new Jsonizer();
    var error = Server.GetLastError();

    var network = Server.CreateObject("WScript.Network");
    var jsonData = {
        application: "Classic ASP",
        host: network.ComputerName,
        type: "ASP 0x" + GetErrorNumber(error),
        message: error.Description,
        source: error.Category,
        statusCode: 500,
        detail: GetErrorDetail(error),
        user: "?",
        form: {},
        queryString: {},
        cookies: {},
        serverVariables: {}
    }

    for (var en = new Enumerator(Request.Form); !en.atEnd(); en.moveNext()) {
        jsonData.form[en.item()] = new String(Request.Form(en.item()));
    }

    for (en = new Enumerator(Request.Cookies); !en.atEnd(); en.moveNext()) {
        jsonData.cookies[en.item()] = new String(Request.Cookies(en.item()));
    }

    for (en = new Enumerator(Request.QueryString); !en.atEnd(); en.moveNext()) {
        jsonData.queryString[en.item()] = new String(Request.QueryString(en.item()));
    }

    for (en = new Enumerator(Request.ServerVariables); !en.atEnd(); en.moveNext()) {
        jsonData.serverVariables[en.item()] = new String(Request.ServerVariables(en.item()));
    }

    var http = Server.CreateObject("MSXML2.ServerXMLHTTP");
    var webHookUrl = "http://elmahasp.local/errors/elmah.ashx";
    http.open("POST", webHookUrl, false);
    http.setRequestHeader("Content-Type", "application/json");
    http.send(JSON.stringify(jsonData));
    // If you want to use the response from the web hook, you'll find it in http.responseText
    // Response.Write(http.responseText);
%>
<html>
<head>
    <title>System Error</title>
</head>
<body>
    <div>
        <h1>
            Sorry!</h1>
        <p>
            We've had an unexpected problem trying to process your request. The problem has
            been recorded, and our engineers will investigate and try to make sure it doesn't
            happen again.</p>
        <p>
            If it's important, you can always call our IT Helpdesk on ??? ???? ???? or email
            helpdesk@company.com</p>
        <p>
            Thanks,</p>
        <p>
            Us</p>
        <hr />
        <p>
            <a href="/elmah.axd">Show Elmah logs</a></p>
    </div>
</body>
</html>
