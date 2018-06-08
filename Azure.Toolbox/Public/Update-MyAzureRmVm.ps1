function Update-MyAzureRmVm {
<#
  .SYNOPSIS
    Upgrades/downgrades the size of an existing Azure Rm VM.

  .DESCRIPTION
    Upgrades/downgrades the size of an existing Azure Rm VM.

  .EXAMPLE
    Update-MyAzureRmVm -ResourceGroup $resourceGroup -Name $vmName -VmSize 'Standard_F2S'
    DESCRIPTION
    ------------
    Upgrades a VM to Standard_F2S and keeps it de-allocated. Add -Start if you want to start
    the VM as well.

  .NOTES
    TODO: Add validation for the SKU since a VM does not to be stopped if upgrading under the
    same SKU
#>

  [CmdletBinding()]
  Param(
    [string]$ResourceGroup,
    [string]$Name,
    [string]$VmSize,
    [switch]$Start
  )

  Write-Verbose "Getting VM: $Name"
  $vm = Get-AzureRmVM -ResourceGroupName $ResourceGroup -Name $Name

  Write-Verbose "Stopping VM: $Name"
  Stop-AzureRmVM `
        -ResourceGroupName $ResourceGroup `
        -Name $Name -Force
  $vm.HardwareProfile.VmSize = $VmSize

  Write-Verbose "Upgrading VM: $Name"
  Update-AzureRmVM `
        -ResourceGroupName $ResourceGroup `
        -VM $Vm

  if ($Start) {
    Write-Verbose "Starting VM: $Name"
    Start-AzureRmVm `
        -ResourceGroupName $resourceGroup `
        -Name $Name
  }
}
