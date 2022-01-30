using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace MG.PowerShell.Show.Models
{
    public class FolderDialogResult : DialogResultBase
    {
        public string FolderPath { get; }

        public FolderDialogResult(DialogResult result, FolderBrowserDialog dialog)
            : base(result)
        {
            this.FolderPath = dialog.SelectedPath;
        }
    }
}
