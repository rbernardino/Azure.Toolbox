# Module-specific variables
$dateformat = 'yyyyMMdd-HH:mm:ss'

## Private Utility functions
function Log([string]$Prefix)
{
  <#
.SYNOPSIS
Appends timestamp to the prefix passed to it.

.DESCRIPTION
Appends timestamp to the prefix passed to it.
#>
  return "[$Prefix-$(Get-Date -Format $dateformat)]"
}
