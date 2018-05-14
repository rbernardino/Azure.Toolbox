$source = 'Azure.Toolbox'

Deploy ToLocalFilesystem {
  by Filesystem {
    FromSource $source
    To $(Join-Path -Path $env:PSModulePath.split(';')[0] -ChildPath $source)
    Tagged Dev
    WithOptions @{
      Mirror = $true
    }
  }
}