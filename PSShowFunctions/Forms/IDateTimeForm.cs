using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using MG.PowerShell.Show.Components;

namespace MG.PowerShell.Show.Forms
{
    public interface IDateTimeForm : IDisposable
    {
        Font Font { get; set; }
        bool TopMost { get; set; }

        IPickerResult ShowPicker();
        IPickerResult ShowPicker(DateTimeReturnType returnType);
    }
}
