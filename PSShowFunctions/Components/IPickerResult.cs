using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MG.PowerShell.Show.Components
{
    public interface IPickerResult
    {
        DateTimeFormType FormType { get; }
        bool PressedOK { get; }
        DateTimeResult Result { get; }
        DateTimeReturnType ReturnType { get; }
    }
}
