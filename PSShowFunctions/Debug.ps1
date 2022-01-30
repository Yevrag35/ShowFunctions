$curDir = Split-Path -Parent $MyInvocation.MyCommand.Definition;
$myDesktop = [System.Environment]::GetFolderPath("Desktop")

Import-Module "$curDir\MG.PowerShell.Show.dll" -ErrorAction Stop

foreach ($format in (Get-ChildItem -Path "$curDir\..\..\..\Formats" -File)) {

	Write-Host "$($format.FullName)"
	Update-FormatData -AppendPath $format.FullName
}

Push-Location $([System.Environment]::GetFolderPath("Desktop"))