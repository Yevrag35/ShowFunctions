using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace MG.PowerShell.Show.Models
{
    public abstract class DialogResultBase
    {
        public bool PressedOK => this.Response == DialogResult.OK;
        public DialogResult Response { get; }

        public DialogResultBase(DialogResult result)
        {
            this.Response = result;
        }
    }
}
