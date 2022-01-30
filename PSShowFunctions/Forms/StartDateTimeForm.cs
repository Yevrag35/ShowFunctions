using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MG.PowerShell.Show.Forms
{
    internal class StartDateTimeForm : DateTimeForm
    {
        public StartDateTimeForm(bool topMost)
            : base("Pick a Start Time", Components.DateTimeFormType.Start, topMost)
        {
        }
    }
}
