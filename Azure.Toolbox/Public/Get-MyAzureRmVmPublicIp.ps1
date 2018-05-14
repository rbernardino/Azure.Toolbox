function Get-MyAzureRmVmPublicIp
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $True)]
    [string]$ResourceGroup,

    [Parameter(Mandatory = $True)]
    [string]$VmName
  )

  $Prgname = $($MyInvocation.MyCommand)
  Write-Verbose "$(Log($Prgname)) Starting"

  $myvm = Get-AzureRmVM -Name $VmName -ResourceGroupName $ResourceGroup

  # The IP address is not a direct property of the VM, so let's first
  # get the nic name
  $nicName = $myvm.NetworkProfile.NetworkInterfaces.Id.Split('/')[-1]
  Write-Verbose "$(Log($Prgname)) Got the name of the NIC: $nicName"

  $mynic = Get-AzureRmNetworkInterface -ResourceGroupName $resourceGroup -Name $nicName

  $myPublicIpName = $mynic.IpConfigurations.PublicIpAddress.Id.Split('/')[-1]
  Write-Verbose "$(Log($Prgname)) Got the name of the public IP resource: $myPublicIpName"
  $myPublicIp = Get-AzureRmPublicIpAddress -ResourceGroupName $ResourceGroup -Name $myPublicIpName

  Write-Output $mypublicIp.IpAddress
  Write-Verbose "$(Log($Prgname)) Ending"

}
