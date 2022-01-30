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
    public abstract class ShowCmdletBase : PSCmdlet
    {
        protected bool TryGetInitialDirectory(InvocationInfo invoc, string parameter, out string path)
        {
            path = null;
            if (!invoc.BoundParameters.ContainsKey(parameter))
            {
                path = string.IsNullOrWhiteSpace(invoc.PSScriptRoot)
                    ? Environment.GetFolderPath(Environment.SpecialFolder.Desktop)
                    : invoc.PSScriptRoot;
            }

            return !string.IsNullOrWhiteSpace(path);
        }
    }
}
