<%@  language="JScript" %>
<script type="text/javascript" language="jscript" runat="server" src="/errors/jsonizer.js"></script>
<%
    var json = new Jsonizer();
    Response.Write(json.stringify({ "foo" : { "bar" : " baz" } }));
%>   