Properties {
  $scripts = "Azure.Toolbox" 
}

task default -depends Analyze, Test

task Analyze {
  #$saResults = Invoke-ScriptAnalyzer -Path $scripts -Severity @('Error', 'Warning') -Recurse -Verbose:$false
  $saResults = Invoke-ScriptAnalyzer -Path $scripts -Severity @('Error') -Recurse -Verbose:$false
  if ($saResults) 
  {
    $saResults | Format-Table
    Write-Error -Message  'One or more Script Analyzer errors/warnings where found. Build cannot continue!'   
  }
}

task Test {
  $testResults = Invoke-Pester -Path 'Tests' -PassThru
  if ($testResults.FailedCount -gt 0)
  {
    $testResults | Format-List
    Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
  }
}

task Deploy {
  Invoke-PSDeploy -Path ".\$scripts.psdeploy.ps1" -Force -Verbose:$VerbosePreference
}