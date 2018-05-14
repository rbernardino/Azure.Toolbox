function Get-UbuntuVmImageOffers
{
<#
  .SYNOPSIS
    Gets available VM Image Offers and SKUs for Ubuntu.
  .DESCRIPTION
    Gets available VM Image Offers and SKUs for Ubuntu.
  .EXAMPLE
    PS C:\> $offers = Get-UbuntuVmImageOffers -Location 'southeastasia'
    PS C:\> $offers.UbuntuServer

    The first line gets all Ubuntu offerings in Southeast Asia.
    The second line gets all the available SKUs for the UbuntuServer offer.

  .OUTPUTS
    VM Image offer to SKUs mapping.
#>

  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $true)]
    [string]$Location,

    # We can add on this list in the future.
    [ValidateSet('Canonical')]
    [string]$PublisherName = 'Canonical'
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

