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
    if (false) {

        var JSON = new Jsonizer();
        var error = Server.GetLastError();

        var network = Server.CreateObject("WScript.Network");
        var jsonData = {
            ApplicationName: "Classic ASP",
            HostName: network.ComputerName,
            Type: "ASP 0x" + GetErrorNumber(error),
            Message: error.Description,
            Source: error.Category,
            StatusCode: 500,
            Detail: GetErrorDetail(error),
            User: "?",
            Form: {},
            QueryString: {},
            Cookies: {},
            ServerVariables: {}
        }

        for (var en = new Enumerator(Request.Form); !en.atEnd(); en.moveNext()) {
            jsonData.Form[en.item()] = new String(Request.Form(en.item()));
        }

        for (en = new Enumerator(Request.Cookies); !en.atEnd(); en.moveNext()) {
            jsonData.Cookies[en.item()] = new String(Request.Cookies(en.item()));
        }

        for (en = new Enumerator(Request.QueryString); !en.atEnd(); en.moveNext()) {
            jsonData.QueryString[en.item()] = new String(Request.QueryString(en.item()));
        }

        for (en = new Enumerator(Request.ServerVariables); !en.atEnd(); en.moveNext()) {
            jsonData.ServerVariables[en.item()] = new String(Request.ServerVariables(en.item()));
        }

        var http = Server.CreateObject("MSXML2.ServerXMLHTTP");
        var webHookUrl = "http://elmahasp.local/webhooks/elmah.ashx";
        http.open("POST", webHookUrl, false);
        http.setRequestHeader("Content-Type", "application/json");
        http.send(JSON.stringify(jsonData));
    }
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
            We've had an unexpected problem trying to process your request. The problem has been recorded, and our engineers will investigate and try to make
            sure it doesn't happen again.</p>
        <p>
            If it's important, you can always call our IT Helpdesk on ??? ???? ???? or email
            helpdesk@company.com</p>
        <p>
            Thanks,</p>
        <p>
            Us</p>
    </div>
</body>
</html>
