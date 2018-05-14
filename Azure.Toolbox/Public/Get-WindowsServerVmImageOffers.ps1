function Get-WindowsServerVmImageOffers
{
<#
  .SYNOPSIS
    Gets available VM Image Offers and SKUs for Windows Server.
  .DESCRIPTION
    Gets available VM Image Offers and SKUs for Windows Server.
  .EXAMPLE
    PS C:\> $offers = Get-WindowsServerVmImageOffers -Location 'southeastasia'
    PS C:\> $offers.WindowsServer

    The first line gets all Windows Server offerings in Southeast Asia.
    The second line gets all the available SKUs for the WindowsServer offer.

  .OUTPUTS
    VM Image offer to SKUs mapping.
#>

  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $true)]
    [string]$Location,

    # We can add on this list in the future.
    [ValidateSet('MicrosoftWindowsServer')]
    [string]$PublisherName = 'MicrosoftWindowsServer'
  )

  # Get-AzureRmVMImagePublisher -Location $location | Select-Object $PublisherName
  $offers = Get-AzureRmVMImageOffer -Location $Location -PublisherName $PublisherName |
    Select-Object -ExpandProperty 'Offer'

  $offers.foreach({
    [PSCustomObject]$output = @{
      ($_) = $(Get-AzureRmVMImageSku -Location $Location -PublisherName $PublisherName -Offer $_ |
               Select-Object -ExpandProperty Skus)
    }
    Write-Output $output
  })
}

