function New-MyAzureStorageBlobSASToken
{
<#
  .SYNOPSIS
    Generates SAS token for a given Azure storage blob.
  .DESCRIPTION
    Generates SAS token for a given Azure storage blob.
  .EXAMPLE
    PS C:\> New-MyAzureStorageBlobSASToken -ResourceGroupName dscLabStorage -StorageAccountName dsclabstoragestd -BlobContainerName window
  s-powershell-dsc -BlobName NewDomain.psd1 -ExpiryTimeMins 5

    Generates new SAS that expires after 5 mins.

  .OUTPUTS
    SAS URI
#>

  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $True)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $True)]
    [string]$StorageAccountName,

    [Parameter(Mandatory = $True)]
    [string]$BlobContainerName,

    [Parameter(Mandatory = $True)]
    [string]$BlobName,

    [ValidateSet('r','rwd')]
    [string]$Permission = 'r',

    [string]$ExpiryTimeMins = 5
  )

  $Prgname = $($MyInvocation.MyCommand)
  Write-Verbose "$(Log($Prgname)) Starting"

  $myKeys = Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName

  # Create a context
  $storContext = New-AzureStorageContext `
                    -StorageAccountName $StorageAccountName `
                    -StorageAccountKey $myKeys[0].Value

  # Create an SAS token (container is currently private)
  $newAzureStorageBlobSASTokenParams = @{
      Container = $BlobContainerName
      Blob = $BlobName
      Permission = $Permission
      StartTime = Get-Date
      ExpiryTime = (Get-Date).AddMinutes($ExpiryTimeMins)
      Context = $storcontext
      FullUri = $True
  }

  New-AzureStorageBlobSASToken @newAzureStorageBlobSASTokenParams

  Write-Verbose "$(Log($Prgname)) Ending"
}
