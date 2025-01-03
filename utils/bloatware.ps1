
Write-Host 'Désinstallation des applications bloatware...'; 

$options = @(
    'Clipchamp.Clipchamp'
    'Microsoft.3DBuilder'
    'Microsoft.549981C3F5F10'   #Cortana app
    'Microsoft.BingFinance'
    'Microsoft.BingFoodAndDrink'            
    'Microsoft.BingHealthAndFitness'         
    'Microsoft.BingNews'
    'Microsoft.BingSports'
    'Microsoft.BingTranslator'
    'Microsoft.BingTravel'
    'Microsoft.BingWeather'
    'Microsoft.Getstarted'   # Cannot be uninstalled in Windows 11
    'Microsoft.Messaging'
    'Microsoft.Microsoft3DViewer'
    'Microsoft.MicrosoftJournal'
    'Microsoft.MicrosoftOfficeHub'
    'Microsoft.MicrosoftPowerBIForWindows'
    'Microsoft.MicrosoftSolitaireCollection'
    'Microsoft.MicrosoftStickyNotes'
    'Microsoft.MixedReality.Portal'
    'Microsoft.NetworkSpeedTest'
    'Microsoft.News'
    'Microsoft.Office.OneNote'
    'Microsoft.Office.Sway'
    'Microsoft.OneConnect'
    'Microsoft.Print3D'
    'Microsoft.SkypeApp'
    'Microsoft.Todos'
    'Microsoft.WindowsAlarms'
    'Microsoft.WindowsFeedbackHub'
    'Microsoft.WindowsMaps'
    'Microsoft.WindowsSoundRecorder'
    'Microsoft.XboxApp'   # Old Xbox Console Companion App, no longer supported
    'Microsoft.ZuneVideo'
    'MicrosoftCorporationII.MicrosoftFamily'   # Family Safety App
    'MicrosoftCorporationII.QuickAssist'
    'MicrosoftTeams'   # Old MS Teams personal (MS Store)

    'ACGMediaPlayer',
    'ActiproSoftwareLLC',
    'AdobeSystemsIncorporated.AdobePhotoshopExpress',
    'Amazon.com.Amazon',
    'AmazonVideo.PrimeVideo',
    'Asphalt8Airborne' ,
    'AutodeskSketchBook',
    'CaesarsSlotsFreeCasino',
    'COOKINGFEVER',
    'CyberLinkMediaSuiteEssentials',
    'DisneyMagicKingdoms',
    'Disney',
    'DrawboardPDF',
    'Duolingo-LearnLanguagesforFree',
    'EclipseManager',
    'Facebook',
    'FarmVille2CountryEscape',
    'fitbit',
    'Flipboard',
    'HiddenCity',
    'HULULLC.HULUPLUS',
    'iHeartRadio',
    'Instagram',
    'king.com.BubbleWitch3Saga',
    'king.com.CandyCrushSaga',
    'king.com.CandyCrushSodaSaga',
    "Kindle"
    'LinkedInforWindows',
    'MarchofEmpires',
    'Netflix',
    'NYTCrossword',
    'OneCalendar',
    'PandoraMediaInc',
    'PhototasticCollage',
    'PicsArt-PhotoStudio',
    'Plex',
    'PolarrPhotoEditorAcademicEdition',
    'Royal Revolt',
    'Shazam',
    'Sidia.LiveWallpaper',
    'SlingTV',
    'Spotify',
    'TikTok',
    'TuneInRadio',
    'Twitter',
    'Viber',
    'WinZipUniversal',
    'Wunderlist',
    'XING'
); 

$selected = @()
for ($i = 0; $i -lt $options.Count; $i++) {
    $selected += $true
}
$currentPage = 0
$currentIndex = 0
$pageSize = 10 # Nombre d'options par page

function DrawMenu {
    Clear-Host
    Write-Host "==========================="
    Write-Host " Suppression des applications inutiles"
    Write-Host "==========================="
    Write-Host "Utilisez les flèches Haut/Bas pour naviguer."
    Write-Host "Utilisez les flèches Gauche/Droite pour changer de page."
    Write-Host "Appuyez sur ESPACE pour sélectionner/déselectionner."
    Write-Host "Appuyez sur ENTRÉE pour valider."
    Write-Host "==========================="
    Write-Host ""

    $startIndex = $currentPage * $pageSize
    $endIndex = [Math]::Min($startIndex + $pageSize, $options.Count) - 1

    if ($currentIndex -lt $startIndex) { $currentIndex = $startIndex }
    if ($currentIndex -gt $endIndex) { $currentIndex = $endIndex }

    for ($i = $startIndex; $i -le $endIndex; $i++) {
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
    Write-Host ""
    Write-Host "=========================== Page $($currentPage + 1)/$([Math]::Ceiling($options.Count / $pageSize))"
}

function Get-KeyPress {
    $key = $null
    while ($true) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($key.VirtualKeyCode -in 37, 39, 38, 40, 32, 13) {
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
        37 { # Flèche gauche (page précédente)
            if ($currentPage -gt 0) {
                $currentPage--
                $currentIndex = $currentPage * $pageSize
            }
        }
        39 { # Flèche droite (page suivante)
            if (($currentPage + 1) * $pageSize -lt $options.Count) {
                $currentPage++
                $currentIndex = $currentPage * $pageSize
            }
        }
    }
}

# Résultat final
Clear-Host



for ($i = 0; $i -lt $options.Count; $i++) {
    if ($selected[$i]) {
        Get-AppxPackage -Name $options[$i] -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue; 
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $options[$i] | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue 
        Write-Host "  -  " $options[$i] " a été désinstallé.." -ForegroundColor Green
    }
}; 