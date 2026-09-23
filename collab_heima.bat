@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title HEIMA CREATIVE - Git dan Vercel Collaboration Tool

:: URL default repositori proyek
set "DEFAULT_REPO_URL=https://github.com/spc02/HEIMA.CREATIVE.git"
set "REPO_CONFIG_FILE=%~dp0repo_info.txt"

:MAIN_MENU
cls
echo =====================================================================
echo          HEIMA CREATIVE - PUSAT KOLABORASI DAN DEPLOYMENT
echo =====================================================================
echo.

:: Cek status Git
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [PERINGATAN] Git belum terinstall di komputer ini!
    echo Silakan download dan install Git terlebih dahulu: https://git-scm.com
    echo.
)

:: Cek apakah sudah ada info repo tersimpan atau gunakan default
set "SAVED_REPO=%DEFAULT_REPO_URL%"
if exist "%REPO_CONFIG_FILE%" (
    set /p SAVED_REPO=<"%REPO_CONFIG_FILE%"
)
if not "!SAVED_REPO!"=="" (
    echo [Status Repo] Terhubung ke: !SAVED_REPO!
) else (
    echo [Status Repo] Belum ada URL GitHub tersimpan.
)

echo.
echo Silakan pilih menu di bawah ini:
echo ---------------------------------------------------------------------
echo  [1] Setup Identitas Akun GitHub Teman (Nama dan Email)
echo  [2] Ambil Update Terbaru dari GitHub (Git Pull)
echo  [3] Simpan dan Kirim Perubahan ke GitHub (Git Add, Commit, Push)
echo  [4] Upload / Deploy Website ke Vercel
echo  [5] Hubungkan Repo GitHub Proyek Ini (Pertama Kali oleh Pemilik)
echo  [6] Download / Clone Proyek Ini ke Folder Baru (Untuk Teman Baru)
echo  [7] Cek Status Proyek (Git dan Vercel)
echo  [0] Keluar
echo ---------------------------------------------------------------------
set /p MENU_CHOICE="Pilih nomor [0-7] lalu tekan ENTER: "

if "%MENU_CHOICE%"=="1" goto SETUP_GITHUB_ACCOUNT
if "%MENU_CHOICE%"=="2" goto GIT_PULL
if "%MENU_CHOICE%"=="3" goto GIT_PUSH
if "%MENU_CHOICE%"=="4" goto VERCEL_MENU
if "%MENU_CHOICE%"=="5" goto SETUP_REMOTE_GITHUB
if "%MENU_CHOICE%"=="6" goto CLONE_PROJECT
if "%MENU_CHOICE%"=="7" goto CHECK_STATUS
if "%MENU_CHOICE%"=="0" goto EXIT_SCRIPT

echo Pilihan tidak valid. Silakan pilih 0 sampai 7.
ping 127.0.0.1 -n 3 >nul
goto MAIN_MENU


:: =====================================================================
:: MENU 1: SETUP AKUN GITHUB TEMAN
:: =====================================================================
:SETUP_GITHUB_ACCOUNT
cls
echo =====================================================================
echo                SETUP IDENTITAS AKUN GITHUB TEMAN
echo =====================================================================
echo.
echo Langkah ini mengatur Nama dan Email Anda untuk riwayat perubahan (commit).
echo.

:: Tampilkan konfigurasi saat ini
for /f "tokens=*" %%i in ('git config --global user.name 2^>nul') do set CURRENT_NAME=%%i
for /f "tokens=*" %%i in ('git config --global user.email 2^>nul') do set CURRENT_EMAIL=%%i

echo Akun saat ini terdaftar di komputer:
echo   - Nama  : !CURRENT_NAME!
echo   - Email : !CURRENT_EMAIL!
echo.

set /p NEW_NAME="Masukkan Nama / Username GitHub Anda : "
if "!NEW_NAME!"=="" (
    echo Nama tidak boleh kosong!
    pause
    goto MAIN_MENU
)

set /p NEW_EMAIL="Masukkan Email GitHub Anda            : "
if "!NEW_EMAIL!"=="" (
    echo Email tidak boleh kosong!
    pause
    goto MAIN_MENU
)

git config --global user.name "!NEW_NAME!"
git config --global user.email "!NEW_EMAIL!"

echo.
echo [SUKSES] Identitas Git berhasil diatur ke:
echo   - Nama  : !NEW_NAME!
echo   - Email : !NEW_EMAIL!
echo.
echo Catatan: Saat pertama kali melakukan Push/Upload ke GitHub,
echo Windows akan menampilkan jendela login GitHub otomatis (Git Credential Manager).
echo Cukup klik 'Sign in with your browser' untuk login.
echo.
pause
goto MAIN_MENU


:: =====================================================================
:: MENU 2: GIT PULL (AMBIL UPDATE TERBARU)
:: =====================================================================
:GIT_PULL
cls
echo =====================================================================
echo               AMBIL UPDATE TERBARU DARI GITHUB (PULL)
echo =====================================================================
echo.
echo Mengambil kode terbaru yang telah diupload teman / rekan Anda...
echo.

if not exist "%~dp0.git" (
    echo [ERROR] Folder ini bukan repositori Git!
    echo Silakan jalankan opsi 5 untuk setup repo atau opsi 6 untuk clone.
    pause
    goto MAIN_MENU
)

git pull origin main
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Mencoba pull dengan branch master jika main tidak ada...
    git pull origin master
)

echo.
echo Selesai memeriksa update.
pause
goto MAIN_MENU


:: =====================================================================
:: MENU 3: GIT PUSH (SIMPAN DAN KIRIM PERUBAHAN)
:: =====================================================================
:GIT_PUSH
cls
echo =====================================================================
echo             SIMPAN DAN KIRIM PERUBAHAN KE GITHUB (PUSH)
echo =====================================================================
echo.

if not exist "%~dp0.git" (
    echo [ERROR] Folder ini bukan repositori Git!
    pause
    goto MAIN_MENU
)

echo Status perubahan file saat ini:
echo ---------------------------------------------------------------------
git status --short
echo ---------------------------------------------------------------------
echo.

set /p COMMIT_MSG="Tulis keterangan perubahan Anda (misal: ganti teks hero): "
if "!COMMIT_MSG!"=="" set "COMMIT_MSG=Update proyek oleh rekan tim"

echo.
echo [1/3] Menambahkan file yang diubah...
git add .

echo [2/3] Menyimpan catatan perubahan (commit)...
git commit -m "!COMMIT_MSG!"

echo [3/3] Mengirim perubahan ke GitHub...
git push origin main
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Mencoba push ke branch master...
    git push origin master
)

if %errorlevel% equ 0 (
    echo.
    echo [SUKSES] Perubahan berhasil dikirim ke GitHub!
) else (
    echo.
    echo [PERHATIAN] Gagal push ke GitHub!
    echo Kemungkinan penyebab:
    echo 1. Anda belum diundang sebagai 'Collaborator' di repo pemilik.
    echo    (Minta pemilik repo invite username GitHub Anda di Settings ^> Collaborators).
    echo 2. Ada perubahan baru dari teman lain di GitHub (Coba jalankan menu 2: Pull dulu).
)

echo.
pause
goto MAIN_MENU


:: =====================================================================
:: MENU 4: DEPLOY KE VERCEL
:: =====================================================================
:VERCEL_MENU
cls
echo =====================================================================
echo                  UPLOAD / DEPLOY WEBSITE KE VERCEL
echo =====================================================================
echo.
echo  [1] Deploy Cepat ke Production (Live Online)
echo  [2] Deploy Preview (Untuk Uji Coba Sementara)
echo  [3] Login Akun Vercel (Pertama kali untuk Teman)
echo  [4] Sambungkan ke Project Vercel yang Sama (Vercel Link)
echo  [0] Kembali ke Menu Utama
echo ---------------------------------------------------------------------
set /p VERCEL_CHOICE="Pilih opsi Vercel [0-4]: "

if "%VERCEL_CHOICE%"=="1" (
    echo.
    echo Menjalankan deploy ke Vercel Production...
    call npx -y vercel --prod
    pause
    goto VERCEL_MENU
)
if "%VERCEL_CHOICE%"=="2" (
    echo.
    echo Menjalankan deploy ke Vercel Preview...
    call npx -y vercel
    pause
    goto VERCEL_MENU
)
if "%VERCEL_CHOICE%"=="3" (
    echo.
    echo Membuka proses login Vercel di browser...
    call npx -y vercel login
    pause
    goto VERCEL_MENU
)
if "%VERCEL_CHOICE%"=="4" (
    echo.
    echo Menghubungkan direktori ini ke project Vercel...
    call npx -y vercel link
    pause
    goto VERCEL_MENU
)
if "%VERCEL_CHOICE%"=="0" goto MAIN_MENU

echo Pilihan tidak valid.
pause
goto VERCEL_MENU


:: =====================================================================
:: MENU 5: SETUP REMOTE GITHUB (UNTUK PEMILIK)
:: =====================================================================
:SETUP_REMOTE_GITHUB
cls
echo =====================================================================
echo          HUBUNGKAN KE REPOSITORI GITHUB (KHUSUS PEMILIK)
echo =====================================================================
echo.
echo Langkah-langkah bagi Pemilik Repo:
echo 1. Buka browser: https://github.com/new
echo 2. Beri nama repo (contoh: heima-creative).
echo 3. Pilih 'Public' atau 'Private'.
echo 4. JANGAN centang 'Add a README file' (biarkan kosong).
echo 5. Klik tombol 'Create repository'.
echo 6. Salin link HTTPS repo Anda (contoh: https://github.com/akun/heima-creative.git).
echo.
set /p INPUT_REPO_URL="Tempel (Paste) URL repo GitHub Anda di sini: "

if "!INPUT_REPO_URL!"=="" (
    echo URL tidak boleh kosong!
    pause
    goto MAIN_MENU
)

:: Simpan URL ke file konfigurasi agar teman otomatis membaca
echo !INPUT_REPO_URL! > "%REPO_CONFIG_FILE%"

cd /d "%~dp0"
git remote remove origin 2>nul
git remote add origin !INPUT_REPO_URL!
git branch -M main

echo.
echo Mengirim kode awal proyek ke GitHub...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo [SUKSES!] Repositori berhasil terhubung dan kode terkirim ke GitHub!
    echo Sekarang Anda bisa mengundang teman Anda di GitHub:
    echo Masuk ke Repo ^> Settings ^> Collaborators ^> Add people (masukkan username teman Anda).
) else (
    echo.
    echo [PERINGATAN] Gagal push awal ke GitHub. Pastikan URL benar dan Anda sudah login.
)

echo.
pause
goto MAIN_MENU


:: =====================================================================
:: MENU 6: CLONE / DOWNLOAD PROYEK UNTUK TEMAN BARU
:: =====================================================================
:CLONE_PROJECT
cls
echo =====================================================================
echo               DOWNLOAD / CLONE PROYEK KE KOMPUTER TEMAN
echo =====================================================================
echo.

set "TARGET_REPO=%DEFAULT_REPO_URL%"
if exist "%REPO_CONFIG_FILE%" (
    set /p TARGET_REPO=<"%REPO_CONFIG_FILE%"
)

if "!TARGET_REPO!"=="" (
    set /p TARGET_REPO="Masukkan URL GitHub repo (contoh: https://github.com/user/repo.git): "
) else (
    echo Ditemukan URL repo tersimpan: !TARGET_REPO!
    set /p USE_SAVED="Gunakan URL ini? [Y/N]: "
    if /i "!USE_SAVED!"=="N" (
        set /p TARGET_REPO="Masukkan URL GitHub baru: "
    )
)

if "!TARGET_REPO!"=="" (
    echo URL tidak boleh kosong!
    pause
    goto MAIN_MENU
)

echo.
set /p CLONE_DIR="Nama folder untuk proyek (tekan ENTER untuk default 'heima-creative'): "
if "!CLONE_DIR!"=="" set "CLONE_DIR=heima-creative"

echo.
echo Mengunduh proyek dari GitHub...
git clone !TARGET_REPO! "!CLONE_DIR!"

if %errorlevel% equ 0 (
    echo.
    echo [SUKSES!] Proyek berhasil di-clone ke folder: !CLONE_DIR!
    echo.
    :: Salin file bat ini ke dalam folder hasil clone agar teman mudah menggunakannya
    copy "%~f0" "!CLONE_DIR!\collab_heima.bat" >nul 2>nul
    echo File collab_heima.bat sudah otomatis ditaruh di dalam folder '!CLONE_DIR!'.
    echo Teman Anda tinggal masuk ke folder '!CLONE_DIR!' dan jalankan 'collab_heima.bat'.
) else (
    echo.
    echo [GAGAL] Tidak dapat meng-clone repositori. Periksa kembali URL dan koneksi internet Anda.
)

echo.
pause
goto MAIN_MENU


:: =====================================================================
:: MENU 7: CEK STATUS PROYEK
:: =====================================================================
:CHECK_STATUS
cls
echo =====================================================================
echo                      STATUS GIT DAN VERCEL
echo =====================================================================
echo.
echo --- KONFIGURASI GIT ---
git config user.name 2>nul
git config user.email 2>nul
echo.
echo --- REMOTE GITHUB ---
git remote -v
echo.
echo --- STATUS FILE SAAT INI ---
git status
echo.
pause
goto MAIN_MENU


:EXIT_SCRIPT
cls
echo Terima kasih telah menggunakan Heima Creative Collaboration Tool!
echo.
exit /b 0
