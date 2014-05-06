using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Web;
using Elmah;
using Newtonsoft.Json;

namespace ElmahAsp.webhooks {
    /// <summary>HTTP handler that takes JSON-encoded error information from other systems and logs it to ELMAH alongside the 
    /// ordinary ASP.NET runtime errors.</summary>
    public class elmah : IHttpHandler {
        public void ProcessRequest(HttpContext context) {
            try {
                var jsonData = new StreamReader(context.Request.InputStream).ReadToEnd();
                var aspError = JsonConvert.DeserializeObject<RemoteError>(jsonData);
                var elmahError = aspError.ToElmahError();
                //TODO: might be worth putting some code in here that will determine the username based on the cookie collection in the deserialized error object.
                ErrorLog.GetDefault(HttpContext.Current).Log(elmahError);
            } catch (Exception ex) {
                ErrorSignal.FromCurrentContext().Raise(ex);
            }
        }

        public bool IsReusable {
            get { return false; }
        }


        public class RemoteError {
            /// <summary> The name of the application that raised the error. </summary>
            public string ApplicationName { get; set; }

            /// <summary>The host (machine name) where the error occurred</summary>
            public string HostName { get; set; }

            /// <summary>The HTTP status code of the original error</summary>
            public int StatusCode { get; set; }

            /// <summary>The short error message describing what happened</summary>
            public string Message { get; set; }

            /// <summary>A detailed description of the error.</summary>
            public string Detail { get; set; }

            ///<summary>The Request.Form collection associated with the error</summary>
            public Dictionary<string, string> Form { get; set; }

            public Dictionary<string, string> QueryString { get; set; }
            public Dictionary<string, string> ServerVariables { get; set; }
            public Dictionary<string, string> Cookies { get; set; }

            /// <summary>The type of error. In .NET this is normally the Type of the exception.</summary>
            public string Type { get; set; }

            public Error ToElmahError() {

                var error = new Elmah.Error();
                error.Time = DateTime.Now; // ELMAH docs confirm this is server local time, not UTC time.
                error.ApplicationName = this.ApplicationName;
                error.HostName = this.HostName;
                error.StatusCode = this.StatusCode;
                error.Message = this.Message;
                error.Detail = this.Detail;
                error.Type = this.Type;

                foreach (var c in this.ServerVariables.Keys) error.ServerVariables.Add(c, this.ServerVariables[c]);
                foreach (var c in this.QueryString.Keys) error.QueryString.Add(c, this.QueryString[c]);
                foreach (var c in this.Form.Keys) error.Form.Add(c, this.Form[c]);
                foreach (var c in this.Cookies.Keys) error.Cookies.Add(c, this.Cookies[c]);

                return (error);
            }
        }
    }
}