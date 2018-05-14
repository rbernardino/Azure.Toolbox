[CmdletBinding()]
Param(
  [string[]]$Task = 'default'
)

Invoke-psake -buildFile "$PSScriptRoot\psakeBuild.ps1" -taskList $Task -Verbose:$VerbosePreference
