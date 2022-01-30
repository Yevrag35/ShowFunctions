param  (
	[Parameter(Mandatory=$false)]
	[string] $ModuleName = "MG.PowerShell.Show",

	[Parameter(Mandatory=$false)]
	[string] $RuntimeTarget,

	[Parameter(Mandatory=$false)]
	[string[]] $CopyToOutput = @(
		'Ookii.Dialogs.Wpf'
	)
)

$depFile = "$PSScriptRoot\$ModuleName.deps.json"
$json = Get-Content -Path $depFile -Raw | ConvertFrom-Json

if (-not $PSBoundParameters.ContainsKey("RuntimeTarget")) {

	$RuntimeTarget = $json.runtimeTarget.name

	if ([string]::IsNullOrEmpty($RuntimeTarget)) {

		throw "No RuntimeTarget supplied or detected."
	}
}

$targets = $json.targets."$RuntimeTarget"

#$netStd = $json.targets.'.NETStandard,Version=v2.0/'
foreach ($toCopy in $CopyToOutput)
{
	$dependency = $targets.psobject.Properties.Where({$_.Name -like "$toCopy*"}) | Select -First 1

	if ($null -eq $dependency) {
		Write-Warning "'$toCopy' was not found in the list of dependencies."
		continue
	}

	$name, $version = $dependency.Name -split '\/'
	if ([string]::IsNullOrEmpty($name) -or [string]::IsNullOrEmpty($version)) {

		Write-Warning "Unable to parse name and version from '$toCopy'."
		continue
	}

	$pso = $targets."$($dependency.Name)".runtime
	if ($null -eq $pso) {

		Write-Warning "No runtime target was found in '$($dependency.Name)'."
		continue;
	}

	$mems = $pso | Get-Member -MemberType NoteProperty | Where { $_.Name -clike "lib/*" }
	foreach ($mem in $mems)
	{
		$fileName = [System.IO.Path]::GetFileName($mem.Name)
		if (-not (Test-Path -Path "$PSScriptRoot\$fileName" -PathType Leaf))
		{
			$file = "$env:nuget\$name\$version\$($mem.Name)"
			Copy-Item -Path $file -Destination "$PSScriptRoot"
		}
		else
		{
			Write-Host "`"$fileName`" already copied..." -f Yellow
		}
	}
}

Import-Module "$PSScriptRoot\$ModuleName.dll" -ErrorAction Stop -Force
foreach ($format in (Get-ChildItem -Path "$PSScriptRoot\..\..\..\..\Formats" -File)) {

	Write-Host "$($format.FullName)"
	Update-FormatData -AppendPath $format.FullName
}

Set-Location "$env:DESK"
#Show-FileDialog -AllowMultiSelect