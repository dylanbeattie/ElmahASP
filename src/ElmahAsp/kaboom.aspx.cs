using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ElmahAsp {
    public partial class kaboom : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e) {
            Label notEvenAThing = MakeNullLabel();
            notEvenAThing.Text = "NULL REFERENCE EXCEPTION! BOOM!";
        }

        private Label MakeNullLabel() {
            return (null);
        }
    }
}