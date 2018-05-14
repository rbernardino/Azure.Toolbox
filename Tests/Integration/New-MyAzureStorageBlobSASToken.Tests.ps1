$module = 'Azure.Toolbox'
$moduleRoot = Join-Path $PSScriptRoot\..\.. -ChildPath $module

# If the module is already in memory, remove it
Get-Module $module | Remove-Module -Force

# Import the module from the local path
Import-Module $moduleRoot\$module.psd1 -Force

Describe 'New-MyAzureStorageBlobSASToken.Tests' {

  . $PSScriptRoot\..\Helpers\TestConfig.ps1

  Context 'Given a file from an Azure storage' {

    It 'Should not be accessible w/o SAS' {
      $remoteFile = 'https://dsclabstoragestd.blob.core.windows.net/windows-powershell-dsc/NewDomain.psd1'
      {Invoke-WebRequest -Uri $remoteFile -ErrorVariable $notFound} | 
        Should Throw "The remote server returned an error: (404) Not Found."
    }

    # Why is this failing on the second run?
    It 'Should be accessible with a SAS' {
      $newMyAzureStorageBlobSASTokenParams = @{
        ResourceGroupName  = 'dscLabStorage'
        StorageAccountName = 'dsclabstoragestd'
        BlobContainerName  = 'windows-powershell-dsc'
        BlobName           = 'NewDomain.psd1'
        Permission         = 'r'
        ExpiryTimeMins     = 5
      }

      $remoteFile = New-MyAzureStorageBlobSASToken @newMyAzureStorageBlobSASTokenParams
      $outfile = "$TestDrive\NewDomain.psd1"
      TestConfig -OutputPath $TestDrive -Uri $remoteFile -Path $outfile
      Start-DscConfiguration -Wait -Force -Path $TestDrive -Verbose
      $outFile | Should Exist
    }
  } 
}

