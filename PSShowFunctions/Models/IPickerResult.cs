using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MG.PowerShell.Show.Components;

namespace MG.PowerShell.Show.Models
{
    public interface IPickerResult
    {
        DateTimeFormType FormType { get; }
        bool PressedOK { get; }
        DateTimeResult Result { get; }
        DateTimeReturnType ReturnType { get; }
    }
}
