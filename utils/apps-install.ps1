[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Définir les options
$options = @(
    "7zip.7zip", 
    "Google.Chrome", 
    "Mozilla.Firefox", 
    "VideoLAN.VLC", 
    "Microsoft.PowerToys", 
    "Microsoft.Office",
    "Microsoft.Teams",
    "Adobe.Acrobat.Reader.64-bit",
    "OpenVPNTechnologies.OpenVPN",
    "tailscale.tailscale"

)
$selected = @()
for ($i = 0; $i -lt $options.Count; $i++) {
    $selected += $true
}
$currentIndex = 0

function DrawMenu {
    Clear-Host
    Write-Host "==========================="
    Write-Host " Installation des Applications"
    Write-Host "==========================="
    Write-Host "Utilisez les flèches Haut/Bas pour naviguer."
    Write-Host "Appuyez sur ESPACE pour sélectionner/déselectionner."
    Write-Host "Appuyez sur ENTRÉE pour valider."
    Write-Host "==========================="
    Write-Host ""
    for ($i = 0; $i -lt $options.Count; $i++) {
        if ($i -eq $currentIndex) {
            Write-Host "-> " -NoNewline
        } else {
            Write-Host "   " -NoNewline
        }

        if ($selected[$i]) {
            Write-Host "[X] $($options[$i])"
        } else {
            Write-Host "[ ] $($options[$i])"
        }
    }
}

function Get-KeyPress {
    $key = $null
    while ($true) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($key.VirtualKeyCode -in 38, 40, 32, 13) {
            break
        }
    }
    return $key.VirtualKeyCode
}

# Boucle principale
while (-not $exitMenu) {
    DrawMenu
    $key = Get-KeyPress

    switch ($key) {
        38 { # Flèche haut
            $currentIndex--
            if ($currentIndex -lt 0) {
                $currentIndex = $options.Count - 1
            }
        }
        40 { # Flèche bas
            $currentIndex++
            if ($currentIndex -ge $options.Count) {
                $currentIndex = 0
            }
        }
        32 { # Barre d'espace
            $selected[$currentIndex] = -not $selected[$currentIndex]
        }
        13 { # Entrée
            $exitMenu = $true
        }
    }
}

# Résultat final
Clear-Host

for ($i = 0; $i -lt $options.Count; $i++) {
    if ($selected[$i]) {
        Write-Host "***************************"
        Write-Host "    Installation de" $options[$i]
        Write-Host "***************************"
        Write-Host ""

        # Vérifie si l'application est déjà installée
        $installed = winget list $options[$i] --nowarn --accept-source-agreements 2>$null | Select-String -Pattern $i
        if (-not $installed) {
            Write-Host "Installation de "$options[$i]" en cours..."
            try {
                # Installe l'application
                winget install --id $options[$i] --silent --accept-source-agreements --accept-package-agreements
                Write-Host $options[$i] " s'est correctement installé." -ForegroundColor Green
            } catch {
                Write-Host "Erreur lors de l'installation de" $options[$i] : $_
                Write-Host ""
                Read-Host "Appuyez sur Entrée pour continuer..."
            }

        } else {
            Write-Host $options[$i] " est déjà installé." -ForegroundColor Green
        }
        
        #Read-Host "Appuyez sur Entrée pour continuer..."
        Clear-Host
    }
    
}
