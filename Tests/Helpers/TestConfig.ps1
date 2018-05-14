Configuration TestConfig
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $True)]
    [string]$Uri,

    [string]$Path
  )

  Import-DscResource -ModuleName xNetworking -ModuleVersion 5.4.0.0
  Import-DscResource -ModuleName xPsDesiredStateConfiguration -ModuleVersion 8.0.0.0

  Node localhost
  {
    xRemoteFile MyFile 
    {
      DestinationPath = $Path
      Uri             = $Uri
    }
  }
}

