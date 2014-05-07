# ElmahASP #

ElmahASP is a bit of code that'll capture classic ASP scripting and runtime errors and pass them to ELMAH so they're logged alongside your ASP.NET and MVC errors.

![](https://raw.githubusercontent.com/dylanbeattie/ElmahASP/master/img/elmah_errors.png)

## How It Works ##

### /ElmahAsp/error.asp ###

This is a classic ASP script that uses the `Server.GetLastError()` method to retrieve the error details. Error details are mapped into a JavaScript object that (roughly) resembles an ELMAH error object, then JSON-encoded and POSTed to a .NET `IHttpHandler`. 

One alternative would have been to wrap the ELMAH classes in a COM-visible .NET assembly, but that would mean registering ActiveX objects on web servers so I went with the lightweight web-hook approach.

### /ElmahAsp/jsonizer.js ###

This is Douglas Crockford's [json2.js](https://github.com/douglascrockford/JSON-js) wrapped in a bit of JScript code so we can use it from classic ASP. Some quirk of scope with `<script runat="server">` blocks in classic ASP means that the `JSON.stringify` 'static' method isn't visible even after referencing the script file, so we've wrapped it in a constructor. 

### /ElmahAsp/elmah.ashx ###

A .NET IHttpHandler that deserializes the POSTed JSON object, creates a new `Elmah.Error` object from the result, and passes this `Error` to `ErrorLog.GetDefault(HttpContext.Current).Log(elmahError);`

## Install and Configuration ##

### IIS Custom Error Configuration ###

There's a quirk of IIS7 and above that means IIS will only pass full error details to the **default** custom error page, so you'll need to configure it under:

IIS > Sites > (your site) > IIS > Error Pages > Edit Feature Settings

![](https://raw.githubusercontent.com/dylanbeattie/ElmahASP/master/img/iis_custom_errors.png)

You can then override specific HTTP errors (401, 404, etc.) using IIS' custom errors, but you won't be able to get any error details from Server.GetLastError() in your handlers for these errors.

### Customize error.asp ###

**You'll need to change the URL on line 78** to the fully-qualified, locally-resolvable web address of your server's `elmah.ashx` handler.

You can also edit the HTML as needed - this is the page that your customers will see when something goes wrong so keep it apologetic and as helpful as possible :)






 
