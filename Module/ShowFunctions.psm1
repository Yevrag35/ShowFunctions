Function Show-FilePicker()
{
    [CmdletBinding()]
    [OutputType([psobject])]
    param
    (
        [Parameter(Mandatory = $false, Position = 0)]
        [string] $InitialDirectory,

        [Parameter(Mandatory = $false)]
        [string] $Title,

        [Parameter(Mandatory = $false)]
        [switch] $AllowMultiselect,

        [Parameter(Mandatory = $false)]
        [switch] $ShowHelp,

        [Parameter(Mandatory = $false)]
        [switch] $ReadOnlyChecked,

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [string] $FilterString
    )
    Begin
    {
        if (-not $PSBoundParameters.ContainsKey("InitialDirectory"))
        {
            $InitialDirectory = [System.Environment]::GetFolderPath("Desktop")
        }
    }
    Process
    {
        $filePicker = New-Object -TypeName 'System.Windows.Forms.OpenFileDialog' -Property @{
            ShowHelp         = $ShowHelp.ToBool()
            Multiselect      = $AllowMultiselect.ToBool()
            ReadOnlyChecked  = $ReadOnlyChecked.ToBool()
            InitialDirectory = $InitialDirectory
        }
        if ($PSBoundParameters.ContainsKey("Title"))
        {
            $filePicker.Title = $Title
        }
        if ($PSBoundParameters.ContainsKey("FilterString"))
        {
            $filePicker.Filter = $FilterString
        }

        $result = $filePicker.ShowDialog()
        [pscustomobject]@{
            PressedOk        = $result.ToString() -eq "OK"
            Response         = $result
            FileName         = $filePicker.FileName
            FileNames        = $filePicker.FileNames
            SafeFileName     = $filePicker.SafeFileName
            SafeFileNames    = $filePicker.SafeFileNames
            SelectedMultiple = $filePicker.FileNames.Length -gt 1
        }
    }
}

Function Show-FolderPicker()
{
    [CmdletBinding()]
    [OutputType([psobject])]
    param
    (
        [Parameter(Mandatory = $false, Position = 0)]
        [System.Environment+SpecialFolder] $RootFolder = [System.Environment+SpecialFolder]::Desktop,

        [Parameter(Mandatory = $false, Position = 1)]
        [string] $Description,

        [Parameter(Mandatory = $false)]
        [switch] $ShowNewFolderButton
    )
    
    $dialog = New-Object -TypeName 'System.Windows.Forms.FolderBrowserDialog' -Property @{
        RootFolder          = $RootFolder
        Description         = $Description
        ShowNewFolderButton = $ShowNewFolderButton.ToBool()
    }
    $result = $dialog.ShowDialog()
    [pscustomobject]@{
        PressedOk    = $result -eq "OK"
        Result       = $result
        SelectedPath = $dialog.SelectedPath
    }
}

Function Show-FormsPopUp()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Message,

        [Parameter(Mandatory = $true, Position = 1)]
        [string] $Title,

        [Parameter(Mandatory = $false)]
        [object[]] $MessageArguments,

        [Parameter(Mandatory = $false)]
        [ValidateSet("AbortRetryIgnore", "OK", "OKCancel", "RetryCancel", "YesNo", "YesNoCancel")]
        [string] $Button = "OK",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Asterisk", "Error", "Exclamation", "Hand", "Information", "None", "Question", "Stop", "Warning")]
        [string] $Icon = "Error",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Button1", "Button2", "Button3")]
        [string] $DefaultButton = "Button1",

        [Parameter(Mandatory = $false)]
        [switch] $PassThru
    )
    Process
    {

        if ($PSBoundParameters.ContainsKey("MessageArguments"))
        {
            $finalMsg = $Message -f $MessageArguments
        }
        else
        {
            $finalMsg = $Message
        }

        $result = [System.Windows.Forms.MessageBox]::Show($finalMsg, $Title, $Button, $Icon, $DefaultButton)
        if ($PassThru)
        {
            $result
        }
    }
}

Function Show-VBInputBox()
{
    [CmdletBinding(DefaultParameterSetName = "None")]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Prompt,

        [Parameter(Mandatory = $false, Position = 1)]
        [AllowNull()]
        [AllowEmptyString()]
        [string] $Title,

        [Parameter(Mandatory = $false, Position = 2)]
        [AllowEmptyString()]
        [AllowNull()]
        [string] $DefaultText,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object[]] $PromptArguments,

        [Parameter(Mandatory = $true, ParameterSetName = "WithPosition")]
        [ValidateRange(0, [int]::MaxValue - 1)]
        [int] $XPosition,

        [Parameter(Mandatory = $true, ParameterSetName = "WithPosition")]
        [ValidateRange(0, [int]::MaxValue - 1)]
        [int] $YPosition,

        [Parameter(Mandatory = $false)]
        [switch] $ReturnAsIs
    )
    Begin
    {
        if ($PSVersionTable.PSVersion.Major -ge 6)
        {
            throw "Microsoft.VisualBasic is not fully supported by the executing PowerShell version.  Consider using 'Show-FormsPopUp' instead."
        }
    }
    Process
    {
        $Prompt = $Prompt.Replace('{newline}', [System.Environment]::NewLine).Replace('{nl}', [System.Environment]::NewLine)
        if ($null -ne $PromptArguments -and $PromptArguments.Count -gt 0)
        {
            $Prompt = $Prompt -f $PromptArguments
        }

        if ($PSCmdlet.ParameterSetName -ne "WithPosition")
        {
            $typedResult = [Microsoft.VisualBasic.Interaction]::InputBox($Prompt, $Title, $DefaultText)
        }
        else
        {
            $typedResult = [Microsoft.VisualBasic.Interaction]::InputBox($Prompt, $Title, $DefaultText, $XPosition, $YPosition)
        }

        if ($ReturnAsIs -or -not [string]::IsNullOrWhiteSpace($typedResult))
        {
            $typedResult
        }
    }
}

Function Show-VBPopUp()
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Message,

        [Parameter(Mandatory = $true, Position = 1)]
        [string] $Title,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object[]] $MessageArguments,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Critical", "Exclamation", "Information", "Question")]
        [string] $Style = "Critical",

        [Parameter(Mandatory = $false)]
        [ValidateSet("DefaultButton1", "DefaultButton2", "DefaultButton3")]
        [string] $DefaultButton = "DefaultButton1",

        [Parameter(Mandatory = $false)]
        [ValidateSet("AbortRetryCancel", "OkCancel", "OkOnly", "RetryCancel", "YesNo", "YesNoCancel")]
        [string] $Button = "OkOnly",

        [Parameter(Mandatory = $false)]
        [switch] $ApplicationModal,

        [Parameter(Mandatory = $false)]
        [switch] $DontBringToForeground,

        [Parameter(Mandatory = $false)]
        [switch] $PassThru
    )
    Begin
    {
        if ($PSVersionTable.PSVersion.Major -ge 6)
        {
            throw "Microsoft.VisualBasic is not fully supported by the executing PowerShell version.  Consider using 'Show-FormsPopUp' instead."
        }
        $builder = New-Object 'System.Collections.Generic.List[string]' -ArgumentList 5
    }
    Process
    {
        $Message = $Message.Replace('{nl', [System.Environment]::NewLine).Replace('{newline}', [System.Environment]::NewLine)

        if ($null -ne $MessageArguments -and $MessageArguments.Count -gt 0)
        {
            $formattedMsg = $Message -f $MessageArguments
        }
        else
        {
            $formattedMsg = $Message
        }

        # Build the Style
        $builder.AddRange([string[]]@($Style, $DefaultButton, $Button))
        if (-not $ApplicationModal)
        {
            $builder.Add("SystemModal")
        }
        else
        {
            $builder.Add("ApplicationModal")
        }

        if (-not $DontBringToForeground)
        {
            $builder.Add("MsgBoxSetForeground")
        }

        $joinedStyle = $builder -join ","

        $boxStyle = [Microsoft.VisualBasic.MsgBoxStyle]$joinedStyle
        $answer = [Microsoft.VisualBasic.Interaction]::MsgBox($formattedMsg, $boxStyle, $Title)
        if ($PassThru)
        {
            $answer.ToString()
        }
    }
}

