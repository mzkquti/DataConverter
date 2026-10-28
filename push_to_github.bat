@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set "REPO=https://github.com/mzkquti/DataConverter.git"

where git >nul 2>nul
if errorlevel 1 set "PATH=C:\Program Files\Git\cmd;%PATH%"

echo.
echo === 1. Moving ci.yml into .github\workflows ===
if exist ci.yml (
    if not exist .github\workflows mkdir .github\workflows
    move /y ci.yml .github\workflows\ci.yml
)
if not exist .github\workflows\ci.yml (
    echo [ERROR] .github\workflows\ci.yml not found
    goto :fail
)

echo.
echo === 2. Creating local git repository ===
if not exist .git git init
git config user.name "mzkquti"
git config user.email "mzkquti@users.noreply.github.com"
git config core.autocrlf true
git branch -M main
git remote remove origin 2>nul
git remote add origin %REPO%

echo.
echo === 3. Commit ===
git add -A
git commit -m "DataConverter project with GitHub Actions CI"
git status --short

echo.
echo === 4. Push to GitHub (a GitHub sign-in window may open) ===
git push -u origin main
if errorlevel 1 goto :fail

echo.
echo Done! Open https://github.com/mzkquti/DataConverter/actions
pause
exit /b 0

:fail
echo.
echo Something went wrong. Take a screenshot of this window and send it to the chat.
pause
exit /b 1
