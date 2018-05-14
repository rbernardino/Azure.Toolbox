function New-AzureRmJsonTemplateDeployment
{
<#
  .SYNOPSIS
    Deploys a Json template to Azure.

  .DESCRIPTION
    Deploys a Json template to Azure.

  .EXAMPLE
    New-AzureRmJsonTemplateDeployment -ResourceGroupName 'myResourceGroup' -Location 'Southeast Asia' -DeploymentName 'myDeployment' -Path 'C:\temp\myJsonTemplate'
#>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $True)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $True)]
    [string]$DeploymentName,

    [Parameter(Mandatory = $True)]
    [string]$Location,

    [Parameter(Mandatory = $True)]
    [ValidateScript({
            if (! (Test-Path -Path $_ -PathType Leaf))
            {
                Throw "File $_ does not exist."
            } else { return $true }
        })]
    [string]$Path,

    [switch]$Force,

    [hashtable]$AdditionalParams,

    [string]$TemplateParameterFile
  )

  $Prgname = $($MyInvocation.MyCommand)
  Write-Verbose "$(Log($Prgname)) Starting"

	$newAzureRmResourceGroupParams = @{
      Name     = $ResourceGroupName
      Location = $Location
	}
  $newAzureRmResourceGroupDeploymentParams = @{
      Name                  = $DeploymentName
      ResourceGroupName     = $ResourceGroupName
      TemplateFile          = $Path
  }

	if( $PSBoundParameters.ContainsKey('Force') )
	{
		$newAzureRmResourceGroupParams.add('Force', $Force)
    $newAzureRmResourceGroupDeploymentParams.add('Force', $Force)
	}

  if( $PSBoundParameters.ContainsKey('TemplateParameterFile') )
	{
		$newAzureRmResourceGroupDeploymentParams.add('TemplateParameterFile', $TemplateParameterFile)
	}

	Write-Verbose "$(Log($Prgname)) Creating/Updating resource group $ResourceGroupName"
	New-AzureRmResourceGroup @newAzureRmResourceGroupParams

  Write-Verbose "$(Log($Prgname)) Deploying resources defined in $Path"
  if( $PSBoundParameters.ContainsKey('AdditionalParams') )
	{
    New-AzureRmResourceGroupDeployment @newAzureRmResourceGroupDeploymentParams @AdditionalParams
	} else {
    New-AzureRmResourceGroupDeployment @newAzureRmResourceGroupDeploymentParams
  }

}
