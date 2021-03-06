function InitializeCustomSDKToolset {

  if (-not $restore) {
    return
  }

  # The following frameworks and tools are used only for testing.
  # Do not attempt to install them in source build.
  if ($env:DotNetBuildFromSource -eq "true") {
    return
  }

  $cli = InitializeDotnetCli -install:$true
  $dotnetRoot = $env:DOTNET_INSTALL_DIR
  $installScript = GetDotNetInstallScript $dotnetRoot
  & $installScript -InstallDir $env:DOTNET_INSTALL_DIR -NoPath -Version "3.0.100-preview-010184"

  InstallDotNetSharedFramework "1.0.5"
  InstallDotNetSharedFramework "1.1.2"
  InstallDotNetSharedFramework "2.1.0"
  InstallDotNetSharedFramework "2.2.1"
  InstallDotNetSharedFramework "2.2.2"
}

function InstallDotNetSharedFramework([string]$version) {
  $fxDir = Join-Path $dotnetRoot "shared\Microsoft.NETCore.App\$version"

  if (!(Test-Path $fxDir)) {    
    & $installScript -Version $version -InstallDir $dotnetRoot -Runtime "dotnet"

    if($lastExitCode -ne 0) {
      throw "Failed to install shared Framework $version to '$dotnetRoot' (exit code '$lastExitCode')."
    }
  }
}

InitializeCustomSDKToolset
