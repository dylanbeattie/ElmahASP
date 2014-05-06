<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ElmahAsp._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <asp:Label runat="server" ID="HeadingLabel">Heading</asp:Label>
    <ul>
        <li><a href="kaboom.aspx">click here to cause an ASP.NET runtime error</a></li>
        <li><a href="kaboom.asp">click here to cause a classic ASP error</a></li>
        <li><a href="elmah.axd">click here for the ELMAH logs</a></li>
    </ul>
    <form action="kaboom.asp?foo=bar&baz=1237&codes=1&codes=2&codes=3" method="POST">
    Mission:
    <input type="text" name="simple" title="mission" value="simple form value" /><br />
        <input type="checkbox" name="multiple" value="one" checked="checked "/> One<br />
        <input type="checkbox" name="multiple" value="two" checked="checked "/> Two<br />
        <input type="checkbox" name="multiple" value="three" checked="checked "/> Three<br />

    <input type="submit" value="Click here to POST a classic ASP error" />
    </form>
</body>
</html>
