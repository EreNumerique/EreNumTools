@echo off
chcp 65001

cd /d %~dp0
echo:
echo:

@REM Création d'un dossier Ere à la racine du C:
    echo **************************************************
    echo *** Création du dossier Ere à la racine du C:\ ***
    echo **************************************************
    echo:
    mkdir c:\ERE
    cls

@REM Changement de fond d'écran
    echo **********************************
    echo *** Changement de fond d'écran ***
    echo **********************************
    echo:
    
    mkdir c:\Ere\img\
    copy /y .\img c:\Ere\img
    
    reg add "HKCU\control panel\desktop" /v wallpaper /t REG_SZ /d "" /f 
    reg add "HKCU\control panel\desktop" /v wallpaper /t REG_SZ /d "C:\Ere\img\bg1.jpg" /f 
    reg delete "HKCU\Software\Microsoft\Internet Explorer\Desktop\General" /v WallpaperStyle /f
    reg add "HKCU\control panel\desktop" /v WallpaperStyle /t REG_SZ /d 2 /f
    
    RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters 
    
    echo Le fond d'écran a bien été changé
    cls

@REM Lancer la suppression des bloatwares via PowerShell
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\utils\bloatware.ps1"
    cls

@REM Mettre à jour les applications Microsoft Store via PowerShell
    echo ********************************************
    echo *** Mise à jour des application MS Store ***
    echo ********************************************
    echo:
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\utils\msstore-appupdate.ps1"
    cls

@REM Vérification si winget est installé
    echo ************************************************
    echo *** Vérification de l'installation de winget ***
    echo ************************************************
    echo:
    winget --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo Winget n'est pas installé. Installation en cours...
        powershell -NoProfile -ExecutionPolicy Bypass -File ".\utils\winget-install.ps1"
        echo:
        echo Winget installé avec succès !
    ) else (
        echo Winget est déjà installé.
    )
    cls

@REM Installation application via winget
    winget source reset --force
    setlocal enabledelayedexpansion
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\utils\apps-install.ps1"
    
@REM Ajout des applis sur la barre des tâches
    .\utils\pttb.exe 
pause    