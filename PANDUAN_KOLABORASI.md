# Panduan Kolaborasi Tim & Deploy Vercel (Heima Creative)

File script `collab_heima.bat` telah dibuat khusus untuk mempermudah Anda dan teman Anda bekerja sama dalam satu proyek GitHub serta meng-upload langsung ke Vercel tanpa perlu menghafal perintah terminal.

---

## 📌 BAGIAN 1: Untuk Anda (Pemilik Proyek / Owner) - Pertama Kali

Karena repo GitHub belum dibuat, ikuti 3 langkah mudah ini:

### 1. Buat Repositori Baru di GitHub
1. Buka [https://github.com/new](https://github.com/new).
2. Isi **Repository name**: `heima-creative` (atau nama lain yang Anda sukai).
3. Pilih **Public** atau **Private**.
4. ⚠️ **JANGAN centang** *"Add a README file"*, *"Add .gitignore"*, atau *"Choose a license"* (biarkan kosong).
5. Klik tombol hijau **Create repository**.
6. Salin link HTTPS repo Anda (contoh: `https://github.com/USERNAME/heima-creative.git`).

### 2. Hubungkan Proyek ke GitHub
1. Di folder proyek ini, klik ganda file **`collab_heima.bat`**.
2. Pilih menu **[5] Hubungkan Repo GitHub Proyek Ini**.
3. Tempel (Paste) URL repo GitHub Anda tadi, lalu tekan Enter.
4. Script akan otomatis meng-upload kode awal ke GitHub!

### 3. Undang Teman Anda sebagai Collaborator (PENTING!)
Agar teman Anda diizinkan untuk mengirim perubahan (Push) ke repo Anda:
1. Buka repo Anda di browser GitHub.
2. Masuk ke tab **Settings** > menu kiri pilih **Collaborators**.
3. Klik tombol hijau **Add people**.
4. Masukkan username atau email GitHub teman Anda, lalu klik **Add to this repository**.
5. Teman Anda akan menerima email undangan / notifikasi di GitHub dan harus klik **Accept Invitation**.

---

## 📌 BAGIAN 2: Untuk Teman Anda (Rekan Tim)

Ada 2 cara teman Anda mendapatkan proyek ini:

### Cara A (Paling Mudah): Anda kirim file `collab_heima.bat` ke teman Anda
1. Kirimkan file `collab_heima.bat` ke teman Anda (lewat WA, Telegram, email, dll).
2. Teman Anda membuat satu folder kosong di komputernya, lalu menaruh file `collab_heima.bat` di sana dan menjalankannya (klik ganda).
3. Teman Anda memilih menu:
   - **[1] Setup Identitas Akun GitHub Teman**: Masukkan Nama dan Email GitHub miliknya.
   - **[6] Download / Clone Proyek**: Masukkan URL repo GitHub proyek Anda. Proyek akan otomatis ter-download lengkap!

### Cara B: Jika Anda mengirimkan seluruh folder proyek
1. Teman Anda cukup membuka folder proyek.
2. Klik ganda **`collab_heima.bat`**.
3. Pilih menu **[1] Setup Identitas Akun GitHub Teman**.

---

## 🚀 Alur Kerja Sehari-Hari (Untuk Teman & Anda)

Setiap kali hendak bekerja atau setelah selesai mengedit:

1. **Sebelum mulai mengedit:**
   - Jalankan `collab_heima.bat` -> Pilih menu **[2] Ambil Update Terbaru (Git Pull)** agar kode selalu yang paling baru.

2. **Setelah selesai mengedit file (HTML, CSS, gambar, dll):**
   - Jalankan `collab_heima.bat` -> Pilih menu **[3] Simpan & Kirim Perubahan (Git Push)**.
   - Masukkan catatan singkat perubahan yang dilakukan (contoh: "Update bagian portfolio").
   - Perubahan akan otomatis terkirim ke GitHub!

3. **Deploy / Upload ke Vercel:**
   - Jalankan `collab_heima.bat` -> Pilih menu **[4] Upload / Deploy Website ke Vercel**.
   - Pilih **[1] Deploy Production** untuk langsung live ke internet!
   - *(Jika teman Anda belum login Vercel di laptopnya, pilih menu [3] Login Akun Vercel terlebih dahulu).*
