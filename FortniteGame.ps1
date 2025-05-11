[System.Console]::Title = "FortniteGame - @MayhemTweaks"

$FortniteGameFolder = "$env:LOCALAPPDATA\FortniteGame"
if (Test-Path -Path $FortniteGameFolder) {
    try {
        Remove-Item -Path $FortniteGameFolder -Recurse -Force
        Write-Output "Le dossier FortniteGame a été supprimé avec succès."
    } catch {
        Write-Output "Erreur lors de la suppression du dossier FortniteGame : $_"
        exit
    }
} else {
    Write-Output "Le dossier FortniteGame n'existe pas déjà."
}

$FortniteConfigFolder = "$FortniteGameFolder\Saved\Config\WindowsClient"
$FortniteConfigFile = Join-Path -Path $FortniteConfigFolder -ChildPath "GameUserSettings.ini"

$configUrl = "https://github.com/Zeer0z/files/releases/download/1/GameUserSettings.ini"
if (-not (Test-Path -Path $FortniteConfigFolder)) {
    New-Item -ItemType Directory -Path $FortniteConfigFolder -Force | Out-Null
    Write-Output "Le dossier de configuration de Fortnite a été créé."
}
try {
    $tempConfigPath = Join-Path -Path $env:TEMP -ChildPath "GameUserSettings.ini"
    Invoke-WebRequest -Uri $configUrl -OutFile $tempConfigPath
    Write-Output "Le fichier de configuration a été téléchargé avec succès."
} catch {
    Write-Output "Erreur lors du téléchargement du fichier de configuration : $_"
    exit
}

$fpsLimit = Read-Host -Prompt "Entrez la limite de FPS souhaitée (0 pour aucune limite)"
if (-not [int]::TryParse($fpsLimit, [ref]$null)) {
    Write-Output "Veuillez entrer une valeur numérique valide."
    exit
}
$fpsLimitFormatted = "$fpsLimit.000000"

$settings = Get-Content -Path $tempConfigPath
$settings = $settings | ForEach-Object {
    if ($_ -match "^FrameRateLimit=") {
        "FrameRateLimit=$fpsLimitFormatted"
    } else {
        $_
    }
}
$settings | Set-Content -Path $FortniteConfigFile

Remove-Item -Path $tempConfigPath -Force