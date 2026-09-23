@echo off
echo Mengompilasi collab_heima.exe...
"C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe" /nologo /target:exe /out:collab_heima.exe CollabHeima.cs
if %errorlevel% equ 0 (
    echo [SUKSES] collab_heima.exe berhasil dibuat!
) else (
    echo [GAGAL] Gagal mengompilasi.
)
pause
