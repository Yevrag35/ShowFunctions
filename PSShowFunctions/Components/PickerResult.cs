using System;

namespace MG.PowerShell.Show.Components
{
    public class PickerResult : IPickerResult
    {
        public DateTimeFormType FormType { get; }
        public bool PressedOK { get; }
        public DateTimeResult Result { get; }
        public DateTimeReturnType ReturnType { get; }

        public PickerResult(bool pressedOk, DateTimeFormType formType, DateTimeReturnType returnType, DateTimeResult? result)
        {
            this.PressedOK = pressedOk;
            this.Result = result.GetValueOrDefault();
            this.FormType = formType;
            this.ReturnType = returnType;
        }
    }
}
