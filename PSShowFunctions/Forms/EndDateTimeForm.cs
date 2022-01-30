using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MG.PowerShell.Show.Forms
{
    internal class EndDateTimeForm : DateTimeForm
    {
        public EndDateTimeForm(bool topMost)
            : base("Pick an End Time", Components.DateTimeFormType.End, topMost)
        {
        }
    }
}
