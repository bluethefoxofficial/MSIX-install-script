Add-Type -AssemblyName System.Windows.Forms

function Test-IsAdmin {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (Test-IsAdmin) {
    # Create and configure the OpenFileDialog
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Filter = "MSIX Bundle Files (*.msixbundle)|*.msixbundle"
    $OpenFileDialog.Title = "Select an MSIX Bundle File to Install"

    # Show the OpenFileDialog and get the selected file path
    $DialogResult = $OpenFileDialog.ShowDialog()
    if ($DialogResult -eq "OK") {
        $MSIXBundlePath = $OpenFileDialog.FileName

        # Install the selected MSIX bundle
        try {
            Add-AppxPackage -Path $MSIXBundlePath
            Write-Host "MSIX Bundle installed successfully." -ForegroundColor Green
        }
        catch {
            Write-Host "Error installing MSIX Bundle:" $_.Exception.Message -ForegroundColor Red
        }
    }
    else {
        Write-Host "No MSIX Bundle was selected." -ForegroundColor Yellow
    }
}
else {
    Write-Host "Please run this script with administrative privileges." -ForegroundColor Red
}
