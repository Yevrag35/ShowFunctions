using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace MG.PowerShell.Show.Models
{
    public class FileDialogResult : DialogResultBase
    {
        
        public string FileName { get; }
        public string[] FileNames { get; }
        public int FilesSelected { get; }
        public string SafeFileName { get; }
        public string[] SafeFileNames { get; }

        internal FileDialogResult(DialogResult result, OpenFileDialog dialog)
            : base(result)
        {
            this.FileName = dialog.FileName;
            this.FileNames = dialog.FileNames;
            this.FilesSelected = (dialog.FileNames?.Length).GetValueOrDefault();
            this.SafeFileName = dialog.SafeFileName; 
            this.SafeFileNames = dialog.SafeFileNames;
        }
    }
}
