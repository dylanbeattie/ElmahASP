using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElmahAsp {
    public partial class FailPage : Page {

        protected void Page_Load(object sender, EventArgs e) {
            var notEvenAThing = MakeNullLabel();
            notEvenAThing.Text = "this will fail with a NullReferenceException...";
        }

        private Label MakeNullLabel() {
            return (null);
        }
    }
}