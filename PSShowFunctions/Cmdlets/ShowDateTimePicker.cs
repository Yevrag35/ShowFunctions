using MG.PowerShell.Show.Components;
using MG.PowerShell.Show.Forms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;

namespace MG.PowerShell.Show.Cmdlets
{
    [Cmdlet(VerbsCommon.Show, "DateTimePicker", ConfirmImpact = ConfirmImpact.None)]
    [OutputType(typeof(PickerResult))]
    public class ShowDateTimePicker : PSCmdlet
    {
        private bool _topMost;

        #region PARAMETERS
        [Parameter(Mandatory = false, Position = 0)]
        public DateTimeFormType FormType { get; set; } = DateTimeFormType.Default;

        [Parameter(Mandatory = false)]
        public SwitchParameter TopMost
        {
            get => _topMost;
            set => _topMost = value;
        }

        #endregion

        protected override void ProcessRecord()
        {
            using (IDateTimeForm form = FormFactory.Create(_topMost, this.FormType))
            {
                IPickerResult result = form.ShowPicker();

                base.WriteObject(result);
            }
        }
    }
}
