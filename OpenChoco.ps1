$ErrorActionPreference = 'SilentlyContinue'
Start-Transcript -Path "C:\ProgramData\chocolatey\installChoco.log" -Append | Out-Null

& ping community.chocolatey.org -n 1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    # internet available
    if (!(Test-Path -Path "$Env:ProgramData\chocolatey")) {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Start-Process -FilePath $Env:ProgramData\chocolatey\choco.exe -ArgumentList 'feature', 'enable', '-n=useRememberedArgumentsForUpgrades' -NoNewWindow -Wait
        Start-Process -FilePath $Env:ProgramData\chocolatey\choco.exe -ArgumentList 'install', 'directx', '-y', '--ignore-checksums' -NoNewWindow -Wait
    }
} else {
    # No internet available
    Stop-Transcript
    [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    [System.Windows.Forms.MessageBox]::Show('Mettez en place une connexion Internet pour télécharger le programme depuis Internet.', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    Exit
}

[int] $global:column = 0
[int] $maxColumn = 1
[int] $separate = 30
[int] $global:lastPos = 50
[bool]$global:install = $false
[bool]$global:update = $false

function generate_checkbox {
    param(
        [string]$checkboxText,
        [string]$package,
        [bool]$enabled = $true
    )
    $checkbox = New-Object System.Windows.Forms.checkbox
    if ($global:column -ge $maxColumn) {
        $checkbox.Location = New-Object System.Drawing.Size(($global:column * 300), $global:lastPos)
        $global:column = 0
        $global:lastPos += $separate
    } else {
        $checkbox.Location = New-Object System.Drawing.Size(30, $global:lastPos)
        $global:column = $column + 1
    }
    $checkbox.Size = New-Object System.Drawing.Size(250, 18)
    $checkbox.Text = $checkboxText
    $checkbox.Name = $package
    $checkbox.Enabled = $enabled

    $checkbox
}

if (!(Test-Path -Path 'C:\ProgramData\chocolatey')) {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

# Set the size of your form
$Form = New-Object System.Windows.Forms.Form
[System.Windows.Forms.Application]::EnableVisualStyles()
$Form.Text = 'MayhemStore' # Titlebar
$Form.ShowIcon = $false
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false
$Form.Size = New-Object System.Drawing.Size(600, 210)
$Form.AutoSizeMode = 0
$Form.KeyPreview = $True
$Form.SizeGripStyle = 2

# label
$Label = New-Object System.Windows.Forms.label
$Label.Location = New-Object System.Drawing.Size(11, 15)
$Label.Size = New-Object System.Drawing.Size(259, 15)
$Label.Text = 'Voici la liste des applications disponibles :'
$Form.Controls.Add($Label)

# https://community.chocolatey.org/packages/steam-client
$Form.Controls.Add((generate_checkbox 'Steam' 'steam-client'))

# https://community.chocolatey.org/packages/epicgameslauncher
$Form.Controls.Add((generate_checkbox 'Epic Games Launcher' 'epicgameslauncher'))

# https://community.chocolatey.org/packages/ea-app
$Form.Controls.Add((generate_checkbox 'EA App' 'ea-app'))

# https://community.chocolatey.org/packages/ubisoft-connect
$Form.Controls.Add((generate_checkbox 'Ubisoft Connect' 'ubisoft-connect'))

# https://community.chocolatey.org/packages/ubisoft-connect
$Form.Controls.Add((generate_checkbox 'Riot Games (Valorant)' 'valorant'))

# https://community.chocolatey.org/packages?q=discord
$Form.Controls.Add((generate_checkbox 'Discord' 'discord'))

# https://community.chocolatey.org/packages/spotify
$Form.Controls.Add((generate_checkbox 'Spotify' 'spotify'))

# https://community.chocolatey.org/packages/obs-studio
$Form.Controls.Add((generate_checkbox 'OBS Studio' 'obs-studio'))

# https://community.chocolatey.org/packages/msiafterburner
$Form.Controls.Add((generate_checkbox 'MSI Afterburner' 'msiafterburner'))

# https://community.chocolatey.org/packages/vlc
$Form.Controls.Add((generate_checkbox 'VLC Media Player' 'vlc'))

# https://community.chocolatey.org/packages/revo-uninstaller
$Form.Controls.Add((generate_checkbox 'Revo Uninstaller' 'revo-uninstaller'))

# https://community.chocolatey.org/packages/lightshot.install
$Form.Controls.Add((generate_checkbox 'Lightshot' 'lightshot.install'))

# https://community.chocolatey.org/packages/notepadplusplus
$Form.Controls.Add((generate_checkbox 'Notepad++' 'notepadplusplus'))

# https://community.chocolatey.org/packages/steelseries-engine
$Form.Controls.Add((generate_checkbox 'SteelSeries Engine' 'steelseries-engine'))

# https://community.chocolatey.org/packages/lghub
$Form.Controls.Add((generate_checkbox 'Logitech G-HUB (pas sur qui fonctionne)' 'lghub'))

if ($global:column -ne 0) {
    $global:lastPos += $separate
}

$Form.height = $global:lastPos + 80

$lastPosWidth = $form.Width - 80 - 31
$UpdateButton = New-Object System.Windows.Forms.Button
$UpdateButton.Location = New-Object System.Drawing.Size($lastPosWidth, $global:lastPos)
$UpdateButton.Size = New-Object System.Drawing.Size(80, 23)
$UpdateButton.Text = 'Mettre à jour'
$UpdateButton.Add_Click({
        $global:update = $true
        $Form.Close()
    })
$Form.Controls.Add($UpdateButton)

$lastPosWidth = $lastPosWidth - 80 - 7
$InstallButton = New-Object System.Windows.Forms.Button
$InstallButton.Location = New-Object System.Drawing.Size($lastPosWidth, $global:lastPos)
$InstallButton.Size = New-Object System.Drawing.Size(80, 23)
$InstallButton.Text = 'Installer'
$InstallButton.Add_Click({
        $global:install = $true
        $Form.Close()
    })
$Form.Controls.Add($InstallButton)

# Activate the form
$Form.Add_Shown({ $Form.Activate() })
[void] $Form.ShowDialog()

if ($global:install) {
    $installPackages = [System.Collections.ArrayList]::new()
    $installSeparatedPackages = [System.Collections.ArrayList]::new()
    $Form.Controls | Where-Object { $_ -is [System.Windows.Forms.Checkbox] } | ForEach-Object {
        if ($_.Checked) {
            if ($_.Name.contains('--')) {
                # Packages with parameters are installed separately from the others
                [void]$installSeparatedPackages.Add($_.Name)
            } else {
                # are all installed in series
                [void]$installPackages.Add($_.Name)
            }
        }
    }

    if ($installPackages.count -ne 0) {
        Write-Host "$Env:ProgramData\chocolatey\choco.exe install $($installPackages -join ' ') -y"
        Start-Process -FilePath "$Env:ProgramData\chocolatey\choco.exe" -ArgumentList "install $($installPackages -join ' ') -y --ignore-checksums" -Wait
    }
    if ($installSeparatedPackages.count -ne 0) {
        foreach ($paket in $installSeparatedPackages) {
            Write-Host "$Env:ProgramData\chocolatey\choco.exe install $paket -y"
            Start-Process -FilePath "$Env:ProgramData\chocolatey\choco.exe" -ArgumentList "install $paket -y --ignore-checksums" -Wait
            if ($paket.contains('--version')) {
                # Packages with version parameters should not be updated
                Write-Host "$Env:ProgramData\chocolatey\choco.exe pin add -n $($paket.split(' ')[0])"
                Start-Process -FilePath "$Env:ProgramData\chocolatey\choco.exe" -ArgumentList "pin add -n $($paket.split(' ')[0])" -Wait
            }
        }
    }
} elseif ($global:update) {
    Write-Host "$Env:ProgramData\chocolatey\choco.exe upgrade all"
    Start-Process -FilePath "$Env:ProgramData\chocolatey\choco.exe" -Verb RunAs -ArgumentList 'upgrade all' -Wait
}
Stop-Transcript
