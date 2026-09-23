@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title HEIMA CREATIVE - Kolaborasi Tim

set "REPO_URL=https://github.com/spc02/HEIMA.CREATIVE.git"

:MENU
cls
echo =====================================================
echo              HEIMA CREATIVE - TIM PROJECT
echo =====================================================
echo.
echo  [1] Gabung / Ambil Update Terbaru dari GitHub
echo  [2] Simpan dan Kirim Update ke GitHub
echo  [3] Upload / Deploy Website ke Vercel
echo  [0] Keluar
echo.
echo =====================================================
set /p PILIH="Pilih nomor [1/2/3] lalu tekan Enter: "

if "%PILIH%"=="1" goto FITUR_GABUNG
if "%PILIH%"=="2" goto FITUR_KIRIM
if "%PILIH%"=="3" goto FITUR_VERCEL
if "%PILIH%"=="0" exit /b 0

goto MENU


:: =====================================================
:: 1. GABUNG / UPDATE PROYEK
:: =====================================================
:FITUR_GABUNG
cls
echo =====================================================
echo        GABUNG / AMBIL UPDATE TERBARU (PULL)
echo =====================================================
echo.

:: 1. Pastikan nama & email teman sudah ada
set "CEK_NAME="
for /f "tokens=*" %%i in ('git config --global user.name 2^>nul') do set "CEK_NAME=%%i"

if not "!CEK_NAME!"=="" goto LANJUT_SYNC

echo Halo! Sepertinya Anda baru pertama kali memakai Git di laptop ini.
echo Silakan masukkan identitas Anda terlebih dahulu:
echo.
set /p INPUT_NAME="Masukkan Nama Anda        : "
set /p INPUT_EMAIL="Masukkan Email GitHub Anda : "

if not "!INPUT_NAME!"=="" git config --global user.name "!INPUT_NAME!"
if not "!INPUT_EMAIL!"=="" git config --global user.email "!INPUT_EMAIL!"
echo.

:LANJUT_SYNC
:: Jika file bat ini dijalankan di dalam folder proyek:
if exist "%~dp0.git" (
    echo Mengambil update terbaru dari GitHub...
    echo.
    git pull origin main
    echo.
    echo [SUKSES] Proyek Anda sudah yang paling baru!
    echo.
    pause
    goto MENU
)

:: Jika folder HEIMA.CREATIVE sudah ada di samping file bat ini:
if exist "%~dp0HEIMA.CREATIVE\.git" (
    echo [INFO] Folder HEIMA.CREATIVE sudah ada di komputer Anda.
    echo Mengambil update terbaru dari GitHub ke dalam folder tersebut...
    echo.
    git -C "%~dp0HEIMA.CREATIVE" pull origin main
    echo.
    echo [SUKSES] Folder HEIMA.CREATIVE berhasil diperbarui ke versi paling baru!
    echo.
    pause
    goto MENU
)

:: Jika belum ada sama sekali (teman baru):
echo Mengunduh proyek HEIMA.CREATIVE ke komputer Anda...
echo.
git clone %REPO_URL% HEIMA.CREATIVE
if %errorlevel% equ 0 goto CLONE_BERHASIL
echo.
echo [GAGAL] Tidak dapat mengunduh. Pastikan koneksi internet aktif.
pause
goto MENU

:CLONE_BERHASIL
copy "%~f0" "HEIMA.CREATIVE\collab_heima.bat" >nul 2>nul
echo.
echo [SUKSES] Proyek berhasil diunduh ke folder 'HEIMA.CREATIVE'!
echo Silakan buka folder 'HEIMA.CREATIVE' dan jalankan collab_heima.bat di sana.
echo.
pause
goto MENU


:: =====================================================
:: 2. SIMPAN & KIRIM UPDATE KE GITHUB
:: =====================================================
:FITUR_KIRIM
cls
echo =====================================================
echo             KIRIM UPDATE KE GITHUB (PUSH)
echo =====================================================
echo.

set "TARGET_DIR="
if exist "%~dp0.git" set "TARGET_DIR=%~dp0"
if not defined TARGET_DIR if exist "%~dp0HEIMA.CREATIVE\.git" set "TARGET_DIR=%~dp0HEIMA.CREATIVE\"

if not defined TARGET_DIR (
    echo [ERROR] Tidak dapat menemukan folder proyek Git!
    pause
    goto MENU
)

set /p PESAN="Tulis keterangan apa yang Anda ubah (tekan Enter untuk langsung kirim): "
if "!PESAN!"=="" set "PESAN=Update proyek oleh tim"

echo.
echo Menyimpan dan mengirim ke GitHub...
git -C "%TARGET_DIR%" add .
git -C "%TARGET_DIR%" commit -m "!PESAN!"
git -C "%TARGET_DIR%" push origin main

if %errorlevel% equ 0 goto KIRIM_SUKSES
goto KIRIM_GAGAL

:KIRIM_SUKSES
echo.
echo [SUKSES] Perubahan berhasil terkirim ke GitHub!
echo.
pause
goto MENU

:KIRIM_GAGAL
echo.
echo [PERHATIAN] Gagal mengirim ke GitHub.
echo Pastikan pemilik repo sudah mengundang Anda sebagai Collaborator di GitHub.
echo Jika ada file baru dari teman lain, jalankan menu nomor [1] terlebih dahulu.
echo.
pause
goto MENU


:: =====================================================
:: 3. UPLOAD KE VERCEL
:: =====================================================
:FITUR_VERCEL
cls
echo =====================================================
echo             UPLOAD WEBSITE KE VERCEL
echo =====================================================
echo.
echo Memulai proses upload ke Vercel...
echo.
if exist "%~dp0heima-creative.html" (
    call npx -y vercel --prod
) else if exist "%~dp0HEIMA.CREATIVE\heima-creative.html" (
    cd /d "%~dp0HEIMA.CREATIVE"
    call npx -y vercel --prod
    cd /d "%~dp0"
) else (
    call npx -y vercel --prod
)

echo.
echo Proses deploy selesai!
echo.
pause
goto MENU
