using MG.PowerShell.Show.Components;
using MG.PowerShell.Show.Forms;
using MG.PowerShell.Show.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Windows.Forms;

namespace MG.PowerShell.Show.Cmdlets
{
    [Cmdlet(VerbsCommon.Show, "FileDialog", ConfirmImpact = ConfirmImpact.None)]
    [OutputType(typeof(FileDialogResult))]
    [CmdletBinding(DefaultParameterSetName = "UsingExtensions")]
    public class ShowFileDialog : ShowCmdletBase
    {
        private const string _DEFAULT_FILTER = "All Files (*.*)|*.*";

        private bool _multiSelect;
        private bool _readOnly;
        private bool _noHelp;

        #region PARAMETERS
        [Parameter(Mandatory = false, Position = 0)]
        public string WindowTitle { get; set; }

        [Parameter(Mandatory = false, Position = 1, ParameterSetName = "UsingExtensions")]
        public string[] FilterExtensions { get; set; }

        [Parameter(Mandatory = true, ParameterSetName = "UsingCustomFilter")]
        [AllowEmptyString]
        [AllowNull]
        public string CustomFileFilter { get; set; }

        [Parameter(Mandatory = false)]
        public SwitchParameter AllowMultiSelect
        {
            get => _multiSelect;
            set => _multiSelect = value;
        }

        [Parameter(Mandatory = false)]
        public string InitialDirectory { get; set; }

        [Parameter(Mandatory = false)]
        public SwitchParameter NoHelpButton
        {
            get => _noHelp;
            set => _noHelp = value;
        }

        [Parameter(Mandatory = false)]
        public SwitchParameter ReadOnlyChecked
        {
            get => _readOnly;
            set => _readOnly = value;
        }

        #endregion
        protected override void BeginProcessing()
        {
            if (this.MyInvocation.BoundParameters.ContainsKey(nameof(this.FilterExtensions)))
            {
                this.CustomFileFilter = CreateFileFilterFromExtensions(this.FilterExtensions);
            }
            else if (!this.MyInvocation.BoundParameters.ContainsKey(nameof(this.CustomFileFilter)) || 
                string.IsNullOrWhiteSpace(this.CustomFileFilter))
            {
                this.CustomFileFilter = _DEFAULT_FILTER;
            }

            if (this.TryGetInitialDirectory(this.MyInvocation, nameof(this.InitialDirectory), out string useThis))
            {
                this.InitialDirectory = useThis;
            }
        }

        protected override void ProcessRecord()
        {
            using (var openFileDialog = new OpenFileDialog
            {
                Filter = this.CustomFileFilter,
                InitialDirectory = this.InitialDirectory,
                Multiselect = _multiSelect,
                ShowHelp = !_noHelp,
                ReadOnlyChecked = _readOnly,
                Title = this.WindowTitle
            })
            {
                DialogResult result = openFileDialog.ShowDialog();
                var outputResult = new FileDialogResult(result, openFileDialog);
                base.WriteObject(outputResult);
            }
        }

        private static string CreateFileFilterFromExtensions(string[] extensions)
        {
            var sb = new StringBuilder(extensions.Length * 3);
            for (int i = 0; i < extensions.Length; i++)
            {
                string ext = extensions[i];
                sb.Append(ext.ToUpper()).Append(" files ")
                    .Append("(*.").Append(ext).Append(char.Parse(")"))
                    .Append("|*.").Append(ext.ToLower());

                if (i >= 0 && i < extensions.Length - 1)
                    sb.Append(char.Parse("|"));
            }

            return sb.ToString();
        }
    }
}
