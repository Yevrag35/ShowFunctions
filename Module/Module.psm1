Add-Type -AssemblyName "System.Windows.Forms", "Microsoft.VisualBasic" -ErrorAction Stop
Import-Module "$PSScriptRoot\Ookii.Dialogs.dll" -ErrorAction SilentlyContinue

Export-ModuleMember -Function @(
    'Show-AdvancedFolderPicker', 'Show-AdvancedInputBox',
    "Show-FilePicker", "Show-FolderPicker", "Show-FormsPopUp", "Show-VBInputBox", "Show-VBPopUp"
)