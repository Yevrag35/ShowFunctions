Function Add-PSOProperty()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [object] $InputObject,

        [Parameter(Mandatory=$true, Position=0)]
        [string] $Name,

        [Parameter(Mandatory=$true, Position=1)]
        [object] $Value,

        [Parameter(Mandatory=$false)]
        [switch] $PassThru
    )
    Process
    {
        $InputObject.psobject.Properties.Add((New-Object psnoteproperty($Name, $Value)))
        if ($PassThru)
        {
            $InputObject
        }
    }
}

Function Show-AdvancedFolderPicker()
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
        [switch] $DontUseDescriptionForTitle,

        [Parameter(Mandatory = $false)]
        [switch] $ShowNewFolderButton
    )
    
    $dialog = New-Object -TypeName 'Ookii.Dialogs.VistaFolderBrowserDialog' -Property @{
        RootFolder             = $RootFolder
        Description            = $Description
        ShowNewFolderButton    = $ShowNewFolderButton.ToBool()
        UseDescriptionForTitle = (-not $DontUseDescriptionForTitle.ToBool())
    }
    $result = $dialog.ShowDialog()
    [pscustomobject]@{
        PressedOk    = $result -eq "OK"
        Result       = $result
        SelectedPath = $dialog.SelectedPath
    }
    $dialog.Dispose()
}

Function Show-AdvancedInputBox()
{
    [CmdletBinding(DefaultParameterSetName = "None")]
    [OutputType([psobject])]
    param
    (
        [Parameter(Mandatory = $false, Position = 0)]
        [string] $Banner,

        [Parameter(Mandatory = $false)]
        [string] $SubText,

        [Parameter(Mandatory = $false)]
        [string] $DefaultText,

        [Parameter(Mandatory = $true, ParameterSetName = "InputValidation")]
        [string] $InputRegex,

        [Parameter(Mandatory = $false, ParameterSetName = "InputValidation")]
        [System.Text.RegularExpressions.RegexOptions[]] $RegexOptions,
        
        [Parameter(Mandatory = $false, Position = 1)]
        [string] $Title,
        
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 32767)]
        [int] $MaxLength = 32767,

        [Parameter(Mandatory = $true, ParameterSetName = "AsSecure")]
        [switch] $UsePasswordMasking
    )

    $inputBox = New-Object -TypeName 'Ookii.Dialogs.InputDialog' -Property @{
        WindowTitle        = $Title
        UsePasswordMasking = $UsePasswordMasking.ToBool()
        MaxLength          = $MaxLength
        MainInstruction    = $Banner
        Content            = $SubText
    }

    if ($PSBoundParameters.ContainsKey("DefaultText") -and -not $UsePasswordMasking)
    {
        $inputBox.Input = $DefaultText
    }

    $result = $inputBox.ShowDialog()
    $pso = [pscustomobject]@{
        PressedOk = $result.ToString() -eq "OK"
        Result    = $result
    }

    if ($UsePasswordMasking)
    {
        #$pso | Add-Member -MemberType NoteProperty -Name "PasswordIsBlank" -Value $([string]::IsNullOrEmpty($inputBox.Input))
        $pso | Add-PSOProperty -Name "PasswordIsBlank" -Value $([string]::IsNullOrEmpty($inputBox.Input))
        $pso | Add-PSOProperty -Name "SecureInput" -Value $($inputBox.Input | ConvertTo-SecureString -AsPlainText -Force)
    }
    else
    {
        $pso | Add-PSOProperty -Name "InputIsBlank" -Value $([string]::IsNullOrEmpty($inputBox.Input))
        $pso | Add-PSOProperty -Name "Input" -Value $inputBox.Input
    }

    if ($PSBoundParameters.ContainsKey("InputRegex"))
    {
        if ($PSBoundParameters.ContainsKey("RegexOptions"))
        {
            [System.Text.RegularExpressions.RegexOptions]$options = ($RegexOptions | ForEach-Object -MemberName ToString) -join ','
            $pass = [regex]::IsMatch($pso.Input, $InputRegex, $options)
        }
        else
        {
            $pass = [regex]::IsMatch($pso.Input, $InputRegex)
        }
        if (-not $pass)
        {
            throw "The provided input did not pass the Regex validation procedure."
        }
    }

    $pso
    $inputBox.Dispose()
}