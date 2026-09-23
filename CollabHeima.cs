using System;
using System.Diagnostics;
using System.IO;

namespace HeimaCreative
{
    class Program
    {
        const string REPO_URL = "https://github.com/spc02/HEIMA.CREATIVE.git";

        static int RunProcess(string command, string args, string workingDir = "")
        {
            try
            {
                ProcessStartInfo psi = new ProcessStartInfo
                {
                    FileName = command,
                    Arguments = args,
                    UseShellExecute = false,
                    CreateNoWindow = false
                };
                if (!string.IsNullOrEmpty(workingDir))
                {
                    psi.WorkingDirectory = workingDir;
                }
                using (Process proc = Process.Start(psi))
                {
                    proc.WaitForExit();
                    return proc.ExitCode;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error menjalankan: " + command + " -> " + ex.Message);
                return -1;
            }
        }

        static string GetCommandOutput(string command, string args)
        {
            try
            {
                ProcessStartInfo psi = new ProcessStartInfo
                {
                    FileName = command,
                    Arguments = args,
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };
                using (Process proc = Process.Start(psi))
                {
                    string output = proc.StandardOutput.ReadToEnd();
                    proc.WaitForExit();
                    return output.Trim();
                }
            }
            catch
            {
                return "";
            }
        }

        static void Main(string[] args)
        {
            Console.Title = "HEIMA CREATIVE - Kolaborasi Tim";
            Console.OutputEncoding = System.Text.Encoding.UTF8;

            while (true)
            {
                Console.Clear();
                Console.WriteLine("=====================================================");
                Console.WriteLine("             HEIMA CREATIVE - TIM PROJECT            ");
                Console.WriteLine("=====================================================");
                Console.WriteLine();
                Console.WriteLine("  [1] Gabung / Ambil Update Terbaru dari GitHub");
                Console.WriteLine("  [2] Simpan dan Kirim Update ke GitHub");
                Console.WriteLine("  [3] Upload / Deploy Website ke Vercel");
                Console.WriteLine("  [0] Keluar");
                Console.WriteLine();
                Console.WriteLine("=====================================================");
                Console.Write("Pilih nomor [1/2/3] lalu tekan Enter: ");
                string choice = Console.ReadLine();

                if (choice == "1")
                {
                    FiturGabung();
                }
                else if (choice == "2")
                {
                    FiturKirim();
                }
                else if (choice == "3")
                {
                    FiturVercel();
                }
                else if (choice == "0")
                {
                    break;
                }
            }
        }

        static void FiturGabung()
        {
            Console.Clear();
            Console.WriteLine("=====================================================");
            Console.WriteLine("        GABUNG / AMBIL UPDATE TERBARU (PULL)         ");
            Console.WriteLine("=====================================================");
            Console.WriteLine();

            string currentName = GetCommandOutput("git", "config --global user.name");
            if (string.IsNullOrEmpty(currentName))
            {
                Console.WriteLine("Halo! Sepertinya Anda baru pertama kali memakai Git di laptop ini.");
                Console.WriteLine("Silakan masukkan identitas Anda terlebih dahulu:\n");
                Console.Write("Masukkan Nama Anda        : ");
                string name = Console.ReadLine();
                Console.Write("Masukkan Email GitHub Anda : ");
                string email = Console.ReadLine();

                if (!string.IsNullOrEmpty(name))
                    RunProcess("git", "config --global user.name \"" + name + "\"");
                if (!string.IsNullOrEmpty(email))
                    RunProcess("git", "config --global user.email \"" + email + "\"");
                Console.WriteLine();
            }

            string baseDir = AppDomain.CurrentDomain.BaseDirectory;
            string insideGit = Path.Combine(baseDir, ".git");
            string subGit = Path.Combine(baseDir, "HEIMA.CREATIVE", ".git");

            if (Directory.Exists(insideGit))
            {
                Console.WriteLine("Mengambil update terbaru dari GitHub...\n");
                RunProcess("git", "pull origin main", baseDir);
                Console.WriteLine("\n[SUKSES] Proyek Anda sudah yang paling baru!\n");
            }
            else if (Directory.Exists(subGit))
            {
                string targetDir = Path.Combine(baseDir, "HEIMA.CREATIVE");
                Console.WriteLine("[INFO] Folder HEIMA.CREATIVE sudah ada di komputer Anda.");
                Console.WriteLine("Mengambil update terbaru ke folder tersebut...\n");
                RunProcess("git", "pull origin main", targetDir);
                Console.WriteLine("\n[SUKSES] Folder HEIMA.CREATIVE berhasil diperbarui ke versi paling baru!\n");
            }
            else
            {
                Console.WriteLine("Mengunduh proyek HEIMA.CREATIVE ke komputer Anda...\n");
                int code = RunProcess("git", "clone " + REPO_URL + " HEIMA.CREATIVE", baseDir);
                if (code == 0)
                {
                    try
                    {
                        string currentExe = Process.GetCurrentProcess().MainModule.FileName;
                        string destExe = Path.Combine(baseDir, "HEIMA.CREATIVE", Path.GetFileName(currentExe));
                        File.Copy(currentExe, destExe, true);
                    }
                    catch { }

                    Console.WriteLine("\n[SUKSES] Proyek berhasil diunduh ke folder 'HEIMA.CREATIVE'!");
                    Console.WriteLine("Silakan buka folder 'HEIMA.CREATIVE' dan jalankan aplikasi ini di sana.\n");
                }
                else
                {
                    Console.WriteLine("\n[GAGAL] Tidak dapat mengunduh. Pastikan koneksi internet aktif.\n");
                }
            }

            Console.WriteLine("Tekan ENTER untuk kembali ke menu...");
            Console.ReadLine();
        }

        static void FiturKirim()
        {
            Console.Clear();
            Console.WriteLine("=====================================================");
            Console.WriteLine("             KIRIM UPDATE KE GITHUB (PUSH)           ");
            Console.WriteLine("=====================================================");
            Console.WriteLine();

            string baseDir = AppDomain.CurrentDomain.BaseDirectory;
            string targetDir = "";
            if (Directory.Exists(Path.Combine(baseDir, ".git")))
                targetDir = baseDir;
            else if (Directory.Exists(Path.Combine(baseDir, "HEIMA.CREATIVE", ".git")))
                targetDir = Path.Combine(baseDir, "HEIMA.CREATIVE");

            if (string.IsNullOrEmpty(targetDir))
            {
                Console.WriteLine("[ERROR] Tidak dapat menemukan folder proyek Git!\n");
                Console.WriteLine("Tekan ENTER untuk kembali ke menu...");
                Console.ReadLine();
                return;
            }

            Console.Write("Tulis keterangan apa yang Anda ubah (tekan Enter untuk langsung kirim): ");
            string pesan = Console.ReadLine();
            if (string.IsNullOrEmpty(pesan)) pesan = "Update proyek oleh tim";

            Console.WriteLine("\nMenyimpan dan mengirim ke GitHub...");
            RunProcess("git", "add .", targetDir);
            RunProcess("git", "commit -m \"" + pesan + "\"", targetDir);
            int pushCode = RunProcess("git", "push origin main", targetDir);

            if (pushCode == 0)
            {
                Console.WriteLine("\n[SUKSES] Perubahan berhasil terkirim ke GitHub!\n");
            }
            else
            {
                Console.WriteLine("\n[PERHATIAN] Gagal mengirim ke GitHub.");
                Console.WriteLine("Pastikan pemilik repo sudah mengundang Anda sebagai Collaborator di GitHub.");
                Console.WriteLine("Jika ada file baru dari teman lain, jalankan menu nomor [1] terlebih dahulu.\n");
            }

            Console.WriteLine("Tekan ENTER untuk kembali ke menu...");
            Console.ReadLine();
        }

        static void FiturVercel()
        {
            Console.Clear();
            Console.WriteLine("=====================================================");
            Console.WriteLine("             UPLOAD WEBSITE KE VERCEL                ");
            Console.WriteLine("=====================================================");
            Console.WriteLine();

            string baseDir = AppDomain.CurrentDomain.BaseDirectory;
            string deployDir = baseDir;
            if (File.Exists(Path.Combine(baseDir, "HEIMA.CREATIVE", "heima-creative.html")))
                deployDir = Path.Combine(baseDir, "HEIMA.CREATIVE");

            Console.WriteLine("Memulai proses upload ke Vercel...\n");
            RunProcess("cmd.exe", "/c npx -y vercel --prod", deployDir);

            Console.WriteLine("\nProses deploy selesai!\n");
            Console.WriteLine("Tekan ENTER untuk kembali ke menu...");
            Console.ReadLine();
        }
    }
}
