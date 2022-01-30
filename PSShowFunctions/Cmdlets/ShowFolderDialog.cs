using MG.PowerShell.Show.Components;
using MG.PowerShell.Show.Forms;
using MG.PowerShell.Show.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Windows.Forms;
using static System.Environment;

namespace MG.PowerShell.Show.Cmdlets
{
    [Cmdlet(VerbsCommon.Show, "FolderDialog", ConfirmImpact = ConfirmImpact.None)]
    [Alias("Show-FolderPicker")]
    [OutputType(typeof(FolderDialogResult))]
    public class ShowFolderDialog : ShowCmdletBase
    {
        private bool _newFolder;

        [Parameter(Mandatory = false)]
        public string Description { get; set; }

        [Parameter(Mandatory = false)]
#if NET5_0_OR_GREATER
        public string InitialDirectory { get; set; }
#else
        public SpecialFolder RootFolder { get; set; }

        [Parameter(Mandatory = false)]
        public SwitchParameter ShowNewFolderButton
        {
            get => _newFolder;
            set => _newFolder = value;
        }
#endif

#if NET5_0_OR_GREATER
        protected override void BeginProcessing()
        {
            if (this.TryGetInitialDirectory(this.MyInvocation, nameof(this.InitialDirectory), out string useThis))
            {
                this.InitialDirectory = useThis;
            }
        }
#endif

        protected override void ProcessRecord()
        {
            using (var dialog = new FolderBrowserDialog
            {
                Description = this.Description,
                ShowNewFolderButton = _newFolder,
#if NET5_0_OR_GREATER
                InitialDirectory = this.InitialDirectory
#else
                RootFolder = this.RootFolder
#endif
            })
            {
                DialogResult result = dialog.ShowDialog();
                base.WriteObject(new FolderDialogResult(result, dialog));
            }
        }
    }
}
