@ECHO OFF
chcp 65001

powershell -command "Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force"

@REM Création de la session 
echo *** Création de la session Ere ***
net user /add Ere <password>

@REM Ajout dans le groupe Admin
echo *** Ajout de la session Ere dans le groupe administrateur ***
net localgroup administrators Ere /add

pause
exit 1;